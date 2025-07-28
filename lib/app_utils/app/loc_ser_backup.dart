// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';
// import 'package:prop_edge/app_storage/secure_storage.dart';
// import 'package:prop_edge/app_utils/alert_service.dart';
// import '../../app_config/app_constants.dart';
// import '../../app_services/local_db/db/database_services.dart';
// import '../../app_services/local_db/local_services/tracking_service.dart';

// class LocationService {
//   static final LocationService _instance = LocationService._internal();
//   factory LocationService() => _instance;

//   LocationService._internal();
//   BoxStorage secureStorage = BoxStorage();
//   AlertService alertService = AlertService();
//   final Location location = Location();
//   StreamSubscription<LocationData>? _locationSubscription;
//   TrackingServices tracking = TrackingServices();
//   BoxStorage boxStorage = BoxStorage();

//   // Function to get the current location
//   // Future<Position> getxCurrentLocation() async {
//   //   bool serviceEnabled;
//   //   LocationPermission permission;

//   //   // Check if location services are enabled
//   //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   if (!serviceEnabled) {
//   //     alertService.errorToast('Location services are disabled.');
//   //   }

//   //   // Check and request location permission
//   //   permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.denied) {
//   //       alertService.errorToast('Location permissions are denied');
//   //     }
//   //   }

//   //   if (permission == LocationPermission.deniedForever) {
//   //     alertService.errorToast('Location permissions are permanently denied');
//   //   }

//   //   // Get the current position
//   //   return await Geolocator.getCurrentPosition(
//   //     locationSettings: (defaultTargetPlatform == TargetPlatform.android)
//   //         ? AndroidSettings(
//   //             accuracy: LocationAccuracy.high,
//   //             forceLocationManager: true,
//   //             intervalDuration: const Duration(seconds: 5),
//   //             distanceFilter: 10,
//   //           )
//   //         : AppleSettings(
//   //             accuracy: LocationAccuracy.best,
//   //             distanceFilter: 10,
//   //           ),
//   //   );
//   // }

//   Future<LocationData?> getCurrentLocation() async {
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         alertService.errorToast('Location services are disabled.');
//         return null;
//       }
//     }

//     PermissionStatus permission = await location.hasPermission();
//     if (permission == PermissionStatus.denied) {
//       permission = await location.requestPermission();
//       if (permission == PermissionStatus.denied) {
//         alertService.errorToast('Location permissions are denied.');
//         return null;
//       }
//     }

//     if (permission == PermissionStatus.deniedForever) {
//       alertService.errorToast(
//           'Location permissions are permanently denied. Please enable them in settings.');
//       return null;
//     }

//     try {
//       LocationData position = await location.getLocation();
//       debugPrint("Location: ${position.latitude}, ${position.longitude}");
//       return position;
//     } catch (e) {
//       alertService.errorToast('Failed to get location: $e');
//       return null;
//     }
//   }

//   Future<void> startTracking() async {
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }

//     PermissionStatus permission = await location.hasPermission();
//     if (permission == PermissionStatus.denied) {
//       permission = await location.requestPermission();
//       if (permission != PermissionStatus.granted) {
//         return;
//       }
//     }
//     // 👉 STEP 1: Get login-time coordinates from secureStorage or boxStorage
//     String? latStr = await secureStorage.get('login_latitude');
//     String? lonStr = await secureStorage.get('login_longitude');

//     if (latStr != null && lonStr != null) {
//       final startLat = double.tryParse(latStr);
//       final startLon = double.tryParse(lonStr);

//       if (startLat != null && startLon != null) {
//         LocationData loginLocation = LocationData.fromMap({
//           'latitude': startLat,
//           'longitude': startLon,
//         });
//         await _saveLocation(loginLocation, "S");
//       }
//     }

//     await MethodChannel('/../../app_utils/app/location_Service')
//         .invokeMethod('startForegroundService');

//     // String trackStatus = "S";
//     DateTime lastUpdate = DateTime.now().subtract(Duration(minutes: 1));
//     _locationSubscription = location.onLocationChanged.listen(
//       (LocationData position) async {
//         try {
//           bool serviceEnabled = await location.serviceEnabled();
//           if (!serviceEnabled) {
//             _locationSubscription?.cancel();
//             debugPrint('----- Location stopped While tracking ------');
//             return;
//           }

//           DateTime now = DateTime.now();
//           if (now.hour >= 23) {
//             print("Stopping location tracking after ${now.hour} PM.");
//             String timestamp =
//                 DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
//             List<String> startTripList =
//                 await boxStorage.get('end_trip_date') ?? [];
//             startTripList.add(timestamp); // Store full timestamp
//             await boxStorage.save('end_trip_date', startTripList);
//             stopListening();
//             navigateToMainPage();
//             return;
//           }
//           if (now.difference(lastUpdate).inMinutes >= 1) {
//             // LatLng newPoint = LatLng(position.latitude!, position.longitude!);
//             _saveLocation(position, "");
//             // trackStatus = "";
//             lastUpdate = now;

//             print(
//                 "Tracking Locations: ${position.latitude}, ${position.longitude} at $now");
//           }
//         } catch (e) {
//           alertService.errorToast("Error processing location data: $e");
//         }
//       },
//       onError: (error) {
//         alertService.errorToast("Location tracking error: $error");
//         debugPrint('----- loc tracking Stopped ------');
//         _locationSubscription?.cancel();
//       },
//     );
//   }

//   void navigateToMainPage() {
//     print("stopping");
//     AlertService.navigatorKey.currentState
//         ?.pushReplacementNamed('mainPage', arguments: 2);
//   }

//   Future<void> _saveLocation(
//       LocationData locationData, String trackStatus) async {
//     print("locationData $locationData");
//     tracking.insertLocation(locationData, trackStatus);
//   }

//   Future<LocationModel?> getFirstStartLocation() async {
//     final db = await DatabaseServices
//         .instance.database; // Replace with your actual DB getter

//     final List<Map<String, dynamic>> result = await db.query(
//       Constants.locationTracking, // Your table name
//       where: 'TrackStatus = ?',
//       whereArgs: ['S'],
//       orderBy: 'Timestamp ASC',
//       limit: 1,
//     );

//     if (result.isNotEmpty) {
//       return LocationModel.fromMap(result.first); // Your model constructor
//     }

//     return null;
//   }

//   void stopListening() async {
//     if (_locationSubscription != null) {
//       // tracking.updateLatestTrackStatus();
//       // updateStatus();
//       String? latStr = await secureStorage.get('login_latitude');
//       String? lonStr = await secureStorage.get('login_longitude');

//       if (latStr != null && lonStr != null) {
//         final startLat = double.tryParse(latStr);
//         final startLon = double.tryParse(lonStr);

//         if (startLat != null && startLon != null) {
//           LocationData loginLocation = LocationData.fromMap({
//             'latitude': startLat,
//             'longitude': startLon,
//           });
//           await _saveLocation(loginLocation, "E");
//         }
//       }
//       _locationSubscription?.cancel();
//       _locationSubscription = null;
//       await MethodChannel('/../../app_utils/app/location_Service')
//           .invokeMethod('stopForegroundService');

//       print("Location tracking stopped.");
//     }
//   }

//   updateStatus() async {
//     LocationData? currentLocation = await getCurrentLocation();
//     if (currentLocation != null) {
//       _saveLocation(currentLocation, 'E');
//     }
//   }
// }

// class LocationModel {
//   final double latitude;
//   final double longitude;
//   final int timestamp;
//   final String trackStatus;
//   final String syncStatus;

//   LocationModel({
//     required this.latitude,
//     required this.longitude,
//     required this.timestamp,
//     required this.trackStatus,
//     required this.syncStatus,
//   });

//   factory LocationModel.fromMap(Map<String, dynamic> map) {
//     return LocationModel(
//       latitude: map['Latitude'],
//       longitude: map['Longitude'],
//       timestamp: map['Timestamp'],
//       trackStatus: map['TrackStatus'],
//       syncStatus: map['SyncStatus'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'Latitude': latitude,
//       'Longitude': longitude,
//       'Timestamp': timestamp,
//       'TrackStatus': trackStatus,
//       'SyncStatus': syncStatus,
//     };
//   }
// }
