import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app/common_functions.dart';
import 'package:prop_edge/app_utils/app/logger.dart';

import '../../app_config/app_constants.dart';
import '../../app_services/local_db/db/database_services.dart';
import '../../app_services/local_db/local_services/tracking_service.dart';
import '../../app_services/site_visit_service.dart';
import '../../app_storage/secure_storage.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();
  final Location _location = Location();
  Location get location => _location;
  final AlertService _alertService = AlertService();
  final TrackingServices _trackingServices = TrackingServices();
  final BoxStorage _boxStorage = BoxStorage();
  bool isTrackingPaused = false;
  DateTime _lastUpdate = DateTime.now().subtract(const Duration(minutes: 1));
  bool _isSaving = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  LogService logService = LogService();
  CommonFunctions commonFunctions = CommonFunctions();

  // Add List to store location data
  List<Map<String, dynamic>> locationDataList = [];
  List<Map<String, dynamic>> latLongList = [];

  StreamSubscription<LocationData>? _locationSubscription;
  Timer? _autoStopTimer;

  /// Get the current location after checking permissions
  Future<LocationData?> getCurrentLocation() async {
    debugPrint('-----> called current Location.');
    if (!await _ensureServiceEnabled()) return null;
    if (!await _ensurePermissionGranted()) return null;

    try {
      final position = await _location.getLocation();
      debugPrint(
          "Current Location: ${position.latitude}, ${position.longitude}");
      return position;
    } catch (e) {
      _alertService.errorToast('Failed to get location: $e');
      return null;
    }
  }

  void _scheduleAutoStop() {
    // Cancel any existing timer
    _autoStopTimer?.cancel();

    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 0, 0);

    // If it's already past 11 PM, schedule for tomorrow
    final stopTime = now.isAfter(todayEnd)
        ? todayEnd.add(const Duration(days: 1))
        : todayEnd;

    final timeUntilStop = stopTime.difference(now);

    debugPrint(
        'Scheduling auto stop for: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(stopTime)}');
    debugPrint('Time until stop: ${timeUntilStop.inMinutes} minutes');

    _autoStopTimer = Timer(timeUntilStop, () async {
      debugPrint('Auto stop timer triggered at: ${DateTime.now()}');
      await stopListeningAuto();
    });
  }

  /// Stop tracking and save end coordinate for auto-logout
  Future<void> stopListeningAuto() async {
    // if (_locationSubscription != null) {
    _autoStopTimer?.cancel();
    try {
      // Save the current location as end point
      LocationData? position = await getCurrentLocation();
      if (position != null) {
        await _saveLocation(position, 'E');
      }

      // Cancel the location subscription
      await _locationSubscription?.cancel();
      _locationSubscription = null;

      // Try to stop the foreground service
      try {
        const platform = MethodChannel('com.propedge.app/location_service');

        await platform.invokeMethod('stopForegroundService');
      } catch (e) {
        debugPrint('Error stopping foreground service: $e');
        // Continue with logout even if service stop fails
      }

      debugPrint("Location tracking stopped - auto logout.");
    } catch (e) {
      debugPrint('Error in stopListeningAuto: $e');
      // Ensure subscription is cancelled even if there's an error
      await _locationSubscription?.cancel();
      _locationSubscription = null;
    }
    // }
  }

  Future<void> stopListeningMannual() async {
    // Cancel the auto-stop timer
    // _autoStopTimer?.cancel();
    // logService.i('---> Stop Listening mannual called');
    commonFunctions.logToFile('---> Stop Listening mannual called');
    // if (_locationSubscription != null) {
    await _saveMannualEnd();

    try {
      const platform = MethodChannel('com.propedge.app/location_service');
      await platform.invokeMethod('stopForegroundService');
    } catch (e, stackTrace) {
      CommonFunctions().appLog(e, stackTrace,
          fatal: true, reason: "Error stopping foreground service");
      await CommonFunctions().logToFile('Error stopping foreground service');
    }
  }

  /// Save location data to local DB with track status and List
  Future<void> _saveLocation(LocationData? locationData, String status) async {
    // Save to local DB
    await _trackingServices.insertLocation(locationData!, status);
  }

  Future<void> _saveMannualEnd() async {
    LocationData? position = await LocationService().getCurrentLocation();
    await _saveLocation(position, 'E');
    debugPrint('---> manually end');
  }

  Future<bool> _ensureServiceEnabled() async {
    if (!await _location.serviceEnabled()) {
      debugPrint('-----> Location service disabled.');
      _alertService.hideLoading();
      await _alertService.showLocationEnableDialog();
      // _alertService.showLoading();
      return await _location.serviceEnabled();
    }
    return true;
  }

  /// Check if location permission is granted
  Future<bool> _ensurePermissionGranted() async {
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      debugPrint('-----> Location permission requesting.');
      permission = await _location.requestPermission();
    }

    if (permission == PermissionStatus.deniedForever) {
      debugPrint(
          '-----> Location permission is permanently denied. Please enable it in settings.');
      _alertService.errorToast(
        'Location permission is permanently denied. Please enable it in settings.',
      );
      return false;
    }

    if (permission != PermissionStatus.granted) {
      debugPrint('-----> Location permission is not granted.');
      _alertService.errorToast('Location permission is not granted.');
      return false;
    }

    return true;
  }

  /// Start tracking location from current location as start point
  Future<void> startTrackingFromCurrent() async {
    print('---> start from current location called');
    // logService.i('---> start from current location called');
    await commonFunctions.logToFile('---> start from current location called');
    if (!await _ensureServiceEnabled() || !await _ensurePermissionGranted()) {
      return;
    }

    // Get and save current location as start point
    LocationData? currentLocation = await getCurrentLocation();
    if (currentLocation == null) {
      await Future.delayed(Duration(seconds: 2));
      currentLocation = await getCurrentLocation();
      commonFunctions.logToFile('Current Location $currentLocation');
    }
    if (currentLocation != null) {
      await _saveLocation(currentLocation, 'S');
      commonFunctions.logToFile('----->Current Location $currentLocation');
    }

    _lastUpdate = DateTime.now().subtract(const Duration(minutes: 1));
    _isSaving = false;

    // Schedule auto-stop at 11 PM
    _scheduleAutoStop();

    await MethodChannel('com.propedge.app/location_service')
        .invokeMethod('startForegroundService');
    await requestExactAlarmPermission();
    // startServiceChecker();
  }

  static Future<void> requestExactAlarmPermission() async {
    try {
      const platform = MethodChannel('com.propedge.app/location_service');
      await platform.invokeMethod('requestExactAlarmPermission');
    } on PlatformException catch (e) {
      print("Failed to request exact alarm permission: '${e.message}'.");
    }
  }

  bool isTripInTrackingState() {
    debugPrint('--> isTripStatecalled');
    BoxStorage boxStorage = BoxStorage();
    String todayDate = DateTime.now().toString().substring(0, 11);
    List<String> startTripList = boxStorage.get('start_trip_date') ?? [];
    List<String> endTripList = boxStorage.get('end_trip_date') ?? [];

    if (endTripList.length < startTripList.length) {
      return true;
    }
    return false;
  }

  bool isTimeBetween11And1159PM() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;

    // 23:00 is 11:00 PM, 23:59 is 11:59 PM
    return hour == 23 && minute >= 0 && minute <= 57;
  }

  Future<void> uploadDataBydate() async {
    // Initialize services
    BoxStorage secureStorage = BoxStorage();
    AlertService alertService = AlertService();
    TrackingServices trackingServices = TrackingServices();
    SiteVisitService siteVisitService = SiteVisitService();

    // Get login token
    String token = secureStorage.getLoginToken();

    try {
      // Read local tracking data
      List locationTracking = await trackingServices.readBySync();
      debugPrint(
          '---> Location Tracking Data Count: ${locationTracking.length}');
      debugPrint('---> Location Tracking Raw Data: $locationTracking');
      commonFunctions
          .logToFile('---> Location Tracking Raw Data: $locationTracking');

      if (locationTracking.isNotEmpty) {
        // Group data by date
        Map<String, List<Map<String, dynamic>>> groupedByDate = {};
        List<String> keysToRemove = [
          'primaryId',
          'SyncStatus'
        ]; // Specify keys you want to remove

        for (var entry in locationTracking) {
          String timestamp = entry["Timestamp"];
          String date = timestamp.split(" ")[0]; // Extract date part only

          Map<String, dynamic> cleanedEntry = Map.from(entry);

          for (String key in keysToRemove) {
            cleanedEntry.remove(key);
          }

          groupedByDate.putIfAbsent(date, () => []).add(cleanedEntry);
        }

        // var sortedMap = SplayTreeMap<String, List<String>>.from(groupedByDate);
        // Send data per date group
        for (var date in groupedByDate.keys) {
          List<Map<String, dynamic>> dataForDate = groupedByDate[date]!;

          var params = {
            "locationTracking": dataForDate,
            "loginToken": {
              "Token": token,
            },
          };

          debugPrint('-----> group by date : ${groupedByDate}');

          debugPrint('---> Sending Location Tracking Params: $params');

          var response =
              await siteVisitService.saveLocationTrackingDetails(params);
          debugPrint('---> Location Tracking Response: $response');

          if (response != null && response['Status'] != null) {
            if (response['Status']['IsSuccess'] == true) {
              debugPrint('---> Location Tracking Saved Successfully. <---');
              // logService
              //     .i('Location Tracking Saved Successfully but not deleted');
              commonFunctions.logToFile(
                  'Location Tracking Saved Successfully but not deleted');
              // deleteLocalData(); // Uncomment if needed
            } else {
              debugPrint(
                  '---> Location Tracking Save Failed: ${response['Status']['Message']} <---');
              // logService.i(
              //     '---> Location Tracking Save Failed: ${response['Status']['Message']} <---');
              commonFunctions.logToFile(
                  '---> Location Tracking Save Failed: ${response['Status']['Message']} <---');
              // if (context != null) {
              //   alertService.errorToast(
              //       'Failed to save location data: ${response['Status']['Message']}');
              // }
            }
          } else {
            debugPrint('---> Invalid response format from server <---');
            // if (context != null) {
            //   alertService.errorToast('Invalid response from server');
            // }
          }
        }
      } else {
        debugPrint('---> No Location Tracking Data to Save <---');
      }
    } catch (e, stackTrace) {
      debugPrint('---> Error in uploadLocationTracking: $e <---');
      debugPrint('---> Stack Trace: $stackTrace <---');
      CommonFunctions().appLog(e, stackTrace,
          fatal: true, reason: "UPLOAD LOCATION TRACKING");
      // if (context != null) {
      //   alertService.errorToast('Error saving location tracking: $e');
      // }
    } finally {
      // if (context != null) {
      //   alertService.hideLoading();
      // }
    }
  }

  Future<void> calculateTrackingData() async {
    List trackingData = await _trackingServices.read();
    locationDataList.clear(); // Clear existing data

    for (var data in trackingData) {
      locationDataList.add({
        'latitude': data['Latitude'],
        'longitude': data['Longitude'],
      });
    }
  }

  removeNull(value) {
    if (value == null || value == 'null') {
      return '';
    }
    return value.toString().trim();
  }

  deleteLocalData() async {
    AlertService alertService = AlertService();
    final db = await DatabaseServices.instance.database;
    await db.rawQuery('DELETE FROM ${Constants.locationTracking}');
    alertService.hideLoading();
  }

  uploadLocationTrackingAuto() async {
    /// GET TOKEN
    BoxStorage secureStorage = BoxStorage();
    String token = "";
    token = secureStorage.getLoginToken();
    TrackingServices trackingServices = TrackingServices();
    SiteVisitService siteVisitService = SiteVisitService();
    try {
      List locationTracking = await trackingServices.readBySync();
      commonFunctions.logToFile(
          'Location Tracking Data Count: ${locationTracking.length}');
      debugPrint(
          '---> Location Tracking Data Count: ${locationTracking.length}');
      debugPrint('---> Location Tracking Raw Data: $locationTracking');
      if (locationTracking.isNotEmpty) {
        AlertService().showLoading();
        if (locationTracking.length == 1) {
          AlertService().hideLoading();
          deleteLocalData();
          return;
        }

// Group data by date
        Map<String, List<Map<String, dynamic>>> groupedByDate = {};
        List<String> keysToRemove = [
          'primaryId',
          'SyncStatus'
        ]; // Specify keys you want to remove
        for (var entry in locationTracking) {
          String timestamp = entry["Timestamp"];
          String date = timestamp.split(" ")[0]; // Extract date part only
          Map<String, dynamic> cleanedEntry = Map.from(entry);
          for (String key in keysToRemove) {
            cleanedEntry.remove(key);
          }
          groupedByDate.putIfAbsent(date, () => []).add(cleanedEntry);
        }
// var sortedMap = SplayTreeMap<String, List<String>>.from(groupedByDate);
// Send data per date group
        for (var date in groupedByDate.keys) {
          List<Map<String, dynamic>> dataForDate = groupedByDate[date]!;
          var params = {
            "locationTracking": dataForDate,
            "loginToken": {
              "Token": token,
            },
          };
          debugPrint('-----> group by date : ${groupedByDate}');
          debugPrint('---> Sending Location Tracking Params: $params');
          var response =
              await siteVisitService.saveLocationTrackingDetails(params);
          debugPrint('---> Location Tracking Response: $response');
          commonFunctions.logToFile('Location Tracking Response: $response');
          commonFunctions
              .logToFile('Location Tracking Saved Successfully and deleted.');

          if (response != null) {
            AlertService().toast("Data Synced Successfully");
            await deleteLocalData();
            commonFunctions.logToFile('Data Synced Successfully..');
          } else {
            AlertService().toast("Failed to sync data $response");
            commonFunctions.logToFile('Failed to sync data');
          }
        }
        AlertService().hideLoading();
      } else {
        commonFunctions.logToFile('No Location Tracking Data to Save');
        debugPrint('---> No Location Tracking Data to Save <---');
      }
    } catch (e, stackTrace) {
      debugPrint('---> Error in uploadLocationTracking: $e <---');
      debugPrint('---> Stack Trace: $stackTrace <---');
      AlertService().hideLoading();
    } finally {
      AlertService().hideLoading();
    }
  }

  Future<int> getDataforLogin() async {
    List locationTracking = await _trackingServices.readBySync();
    return locationTracking.length;
  }

  // Add method to get location data list
  List<Map<String, dynamic>> getLocationDataList() {
    debugPrint('----> Get Lat and Long data');
    return locationDataList;
  }

  // Add method to clear location data list
  void clearLocationDataList() {
    locationDataList.clear();
  }
}

class LocationModel {
  final double latitude;
  final double longitude;
  final int timestamp;
  final String trackStatus;
  final String syncStatus;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.trackStatus,
    required this.syncStatus,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) => LocationModel(
        latitude: map['Latitude'],
        longitude: map['Longitude'],
        timestamp: map['Timestamp'],
        trackStatus: map['TrackStatus'],
        syncStatus: map['SyncStatus'],
      );

  Map<String, dynamic> toMap() => {
        'Latitude': latitude,
        'Longitude': longitude,
        'Timestamp': timestamp,
        'TrackStatus': trackStatus,
        'SyncStatus': syncStatus,
      };
}
