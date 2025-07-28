import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:prop_edge/app_utils/alert_service.dart';

import '../../app_services/local_db/local_services/tracking_service.dart';

/// A service class that handles all location-related operations including:
/// - Getting current location
/// - Tracking location updates
/// - Managing location permissions
/// - Saving location data
class LocationService {
  // Singleton instance
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  final AlertService _alertService = AlertService();
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  /// Checks and requests location service permissions
  /// Returns true if location services are enabled, false otherwise
  Future<bool> _checkAndRequestLocationService() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
      }
      return serviceEnabled;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      _alertService.errorToast('Failed to check location services: $e');
      return false;
    }
  }

  /// Checks and requests location permissions
  /// Returns true if permissions are granted, false otherwise
  Future<bool> _checkAndRequestLocationPermission() async {
    try {
      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
      }
      return permission == PermissionStatus.granted;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      _alertService.errorToast('Failed to check location permissions: $e');
      return false;
    }
  }

  /// Gets the current location of the device
  /// Returns LocationData if successful, null otherwise
  Future<LocationData?> getCurrentLocation() async {
    try {
      // Check location services
      if (!await _checkAndRequestLocationService()) {
        _alertService.errorToast('Location services are disabled.');
        return null;
      }

      // Check permissions
      if (!await _checkAndRequestLocationPermission()) {
        _alertService.errorToast('Location permissions are denied.');
        return null;
      }

      // Get current location
      final position = await _location.getLocation();
      return position;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      _alertService.errorToast('Failed to get location: $e');
      return null;
    }
  }

  /// Starts tracking location updates
  /// Continuously monitors location changes and saves them
  Future<void> startTracking() async {
    try {
      // Check prerequisites
      if (!await _checkAndRequestLocationService() ||
          !await _checkAndRequestLocationPermission()) {
        return;
      }

      // Cancel existing subscription if any
      await stopListening();

      // Start new location tracking
      _locationSubscription = _location.onLocationChanged.listen(
        (LocationData currentLocation) {
          _saveLocation(currentLocation);
        },
        onError: (error, stackTrace) {
          FirebaseCrashlytics.instance.recordError(error, stackTrace);
          _alertService.errorToast('Location tracking error: $error');
        },
      );
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      _alertService.errorToast('Failed to start location tracking: $e');
    }
  }

  /// Saves location data to local storage
  /// [locationData] The location data to save
  Future<void> _saveLocation(LocationData locationData) async {
    try {
      final tracking = TrackingServices();
      await tracking.insertLocation(locationData);
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      _alertService.errorToast('Failed to save location: $e');
    }
  }

  /// Stops tracking location updates and cleans up resources
  Future<void> stopListening() async {
    try {
      await _locationSubscription?.cancel();
      _locationSubscription = null;
      debugPrint("Location tracking stopped");
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      _alertService.errorToast('Failed to stop location tracking: $e');
    }
  }
}
