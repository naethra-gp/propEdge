import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:prop_edge/app_config/app_constants.dart';
import 'package:prop_edge/app_utils/app/common_functions.dart';
import 'package:prop_edge/main.dart';
import 'dart:math' as math;
import '../../../app_utils/app/logger.dart';
import '../../../location_service.dart';
import '../db/database_services.dart';

class TrackingServices {
  // // Store the last inserted location
  double? _lastLatitude;
  double? _lastLongitude;
  // // Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth's radius in meters
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }

  Future<void> insertLocation(
      LocationData locationData, String trackStatus) async {
    debugPrint('--- insert after $locationData ----');
    final db = await DatabaseServices.instance.database;
    await db.insert(Constants.locationTracking, {
      'Latitude': locationData.latitude,
      'Longitude': locationData.longitude,
      'Timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'SyncStatus': 'N',
      'TrackStatus': trackStatus
    });
  }

  // readLastLatLon() async {
  //   final db = await DatabaseServices.instance.database;
  //   final result = await db.rawQuery(
  //       "SELECT Latitude, Longitude FROM ${Constants.locationTracking} ORDER BY primaryId DESC LIMIT 1");
  //   if (result.isNotEmpty) {
  //     final row = result.first;
  //     final double lat = row['Latitude'] as double;
  //     final double lon = row['Longitude'] as double;
  //     print('lat $lat long $lon');
  //     return {'latitude': lat, 'longitude': lon};
  //   } else {
  //     return null; // or return default value if needed
  //   }
  // }
  readLastLatLon() async {
    final db = await DatabaseServices.instance.database;
    final result = await db.rawQuery('''
    SELECT Latitude, Longitude, TrackStatus, primaryId 
    FROM ${Constants.locationTracking}
    WHERE TrackStatus = 'V'
    UNION ALL
    SELECT Latitude, Longitude, TrackStatus, primaryId 
    FROM ${Constants.locationTracking}
    WHERE TrackStatus = 'S'
    ORDER BY primaryId DESC
    LIMIT 1
  ''');
    if (result.isNotEmpty) {
// Because UNION ALL keeps order, but we want the 'v' record if exists,
// so we pick the first record with TrackStatus='v', else 's'.
      var row = result.firstWhere((r) => r['TrackStatus'] == 'V',
          orElse: () => result.firstWhere((r) => r['TrackStatus'] == 'S'));
      final double lat = (row['Latitude'] is int)
          ? (row['Latitude'] as int).toDouble()
          : row['Latitude'] as double;
      final double lon = (row['Longitude'] is int)
          ? (row['Longitude'] as int).toDouble()
          : row['Longitude'] as double;
      print('lat $lat long $lon');
      return {'latitude': lat, 'longitude': lon};
    } else {
      return null; // or default value
    }
  }

  Future<void> insertLocationFromRaw(
      double latitude, double longitude, String trackStatus) async {
    debugPrint('--- Lat: $latitude, Lng: $longitude ----');
    LogService().w('--- Lat: $latitude, Lng: $longitude ----');
    var distance = 0.0;
    // int count = await LocationService().getDataforLogin();
    // if (count == 0) {
    // await insertLocationToDb(latitude, longitude, "S");
    // commonFunctions.logToFile('----> Count 0 executed..');
    // } else {
    // If this is a start or end point, always insert
    if (trackStatus == 'S' || trackStatus == 'E') {
      await insertLocationToDb(latitude, longitude, trackStatus);
      commonFunctions.logToFile('---> Track Status S or E');
      return;
    }
    // For regular tracking points, check distance
    else {
      commonFunctions.logToFile('---> Track Status Empty');
      final latestLocation = await readLastLatLon();
      if (latestLocation != null) {
        _lastLatitude = latestLocation['latitude'];
        _lastLongitude = latestLocation['longitude'];
        if (_lastLatitude != null && _lastLongitude != null) {
          distance = _calculateDistance(
              _lastLatitude!, _lastLongitude!, latitude, longitude);
          debugPrint(
              'Distance from last point: ${distance.toStringAsFixed(2)} meters');
          LogService().i(
              'Distance from last point: ${distance.toStringAsFixed(2)} meters');
          // Only insert if distance is >= 100 meters
          if (distance >= 100) {
            await insertLocationToDb(latitude, longitude, "V");
          } else {
            await insertLocationToDb(latitude, longitude, "");
            // debugPrint('Skipping location - too close to last point');
            LogService().i('Skipping location - too close to last point');
          }
        } else {
          // Handle missing lat/lon gracefully
          await insertLocationToDb(latitude, longitude, "");
          // LogService().w(
          //     'Previous latitude or longitude was null, skipping distance check.');
        }
      } else {
        await insertLocationToDb(latitude, longitude, "");
      }
      // }
    }
  }

  Future<void> insertLocationToDb(
      double latitude, double longitude, String trackStatus) async {
    // LogService().i('-----> Inserted Lat and Long ${latitude} and ${longitude}');
    CommonFunctions()
        .logToFile('-----> Inserted Lat and Long ${latitude} and ${longitude}');
    final db = await DatabaseServices.instance.database;
    await db.insert(Constants.locationTracking, {
      'Latitude': latitude,
      'Longitude': longitude,
      'Timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'SyncStatus': 'N',
      'TrackStatus': trackStatus
    });
  }

  Future<Map<String, List<List<Map<String, dynamic>>>>>
      fetchRecordsGroupedByDate() async {
    final db = await DatabaseServices.instance.database;
    // Fetch all records sorted by Timestamp
    List<Map<String, dynamic>> records = await db.rawQuery('''
    SELECT * FROM ${Constants.locationTracking}
    ORDER BY Timestamp
  ''');
    Map<String, List<List<Map<String, dynamic>>>> groupedByDate = {};
    List<Map<String, dynamic>> tempGroup = [];
    bool isGrouping = false;
    for (var record in records) {
      // Convert timestamp to Date (yyyy-MM-dd)
      String recordDate = DateFormat('yyyy-MM-dd').format(
        DateTime.fromMillisecondsSinceEpoch(record['Timestamp']),
      );
      // Initialize a new date if needed
      groupedByDate.putIfAbsent(recordDate, () => []);
      // Start grouping when 'S' is found
      if (record['TrackStatus'] == 'S') {
        isGrouping = true;
        tempGroup = []; // Start a new group
      }
      // Add record to the current group
      if (isGrouping) {
        tempGroup.add(record);
      }
      // Stop grouping when 'E' is found
      if (record['TrackStatus'] == 'E') {
        groupedByDate[recordDate]?.add(List.from(tempGroup)); // Store group
        isGrouping = false; // Reset for next sequence
      }
    }
    return groupedByDate;
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    final db = await DatabaseServices.instance.database;
    return await db.query('locations');
  }

  Future<void> deleteLocations(List<int> ids) async {
    final db = await DatabaseServices.instance.database;
    await db.delete('locations', where: 'primaryId IN (${ids.join(',')})');
  }

  Future<void> updateLatestTrackStatus() async {
    print("update--->");
    final db = await DatabaseServices.instance.database;
    await db.rawUpdate('''
    UPDATE ${Constants.locationTracking}
    SET TrackStatus = ?
    WHERE Timestamp = (SELECT MAX(Timestamp) FROM ${Constants.locationTracking})
  ''', ['E']);
  }

  read() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.locationTracking}");
  }

  // readBySync() async {
  //   final db = await DatabaseServices.instance.database;
  //   return await db.rawQuery(
  //       "SELECT * FROM ${Constants.locationTracking} WHERE SyncStatus = 'N'");
  // }
  readBySync() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.locationTracking} WHERE TrackStatus = 'S' or TrackStatus = 'V' or TrackStatus = 'E' ");
  }
}
