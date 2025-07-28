import 'dart:io';

// import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prop_edge/app_storage/secure_storage.dart';
import 'package:prop_edge/app_utils/alert_service2.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app/logger.dart';
import 'package:prop_edge/location_service.dart';

class CommonFunctions {
  final _secureStorage = BoxStorage();
  // REMOVE NULL VALUES
  removeNull(String value) {
    if (value.toString().toLowerCase() == 'null') {
      return '';
    }
    return value.toString().trim();
  }

  // checkBatteryOptimization() async {
  //   bool? isOptimize =
  //       await DisableBatteryOptimization.isBatteryOptimizationDisabled;
  //   if (!isOptimize!) {
  //     await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
  //   }
  // }

  Future<void> checkBatteryOptimization() async {
    final isOptimized =
        await DisableBatteryOptimizationLatest.isAllBatteryOptimizationDisabled;

    if (!isOptimized!) {
      await DisableBatteryOptimizationLatest
          .showDisableBatteryOptimizationSettings();
    }
  }

  Future<void> appLog(
    dynamic onError,
    StackTrace stack, {
    String reason = "",
    bool fatal = false,
  }) async {
    // NO NEED TO PRINT IN RELEASE MODE
    if (!kReleaseMode) {
      debugPrint("-----------------------------------");
      debugPrint("Page Name     : $reason");
      debugPrint("Fatal Error   : $fatal");
      debugPrint("Error Desc    : ${onError.toString()}");
      debugPrint("-----------------------------------");
    }

    /// FIREBASE CATCH RECORDS
    await FirebaseCrashlytics.instance.recordError(
      onError,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  checkPermission() async {
    final Location location = Location();

    PermissionStatus checkPermission = await location.hasPermission();
    bool serviceEnabled = await location.serviceEnabled();

    /// Check for Location Service Enabled
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        AlertService().errorToast('Location services are disabled.');
        return;
      }
    }
    if (checkPermission == PermissionStatus.denied) {
      checkPermission = await location.requestPermission();
      if (checkPermission == PermissionStatus.denied) {
        Fluttertoast.showToast(msg: 'Request Denied !');
        return;
      }
    }
    if (checkPermission == PermissionStatus.deniedForever) {
      Fluttertoast.showToast(msg: 'Denied Forever !');
      return;
    }
  }

  Future<void> logToFile(String message) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/app_log.txt';
    final file = File(path);
    final timestamp = DateTime.now().toIso8601String();
    await file.writeAsString('[$timestamp] $message\n', mode: FileMode.append);
  }

  void loadData(BuildContext context) async {
    int count = await LocationService().getDataforLogin();
    print("count---> $count");
    if (count == 0) {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  Future<void> androidLogoutCallback(BuildContext context) async {
    try {
      // AlertService().successToast('Calling Auto-logout..');
      CommonFunctions().logToFile('Calling Auto-logout..');
      final userDetails = _secureStorage.get('user');
      debugPrint('Fetched user details: $userDetails');
      if (userDetails != null) {
        AlertService().showLoading();
        final LocationService locationService = LocationService();
        await locationService.uploadLocationTrackingAuto();
        await _secureStorage.deleteUserDetails();
        await _secureStorage.deleteStartTripStatus();
        await _secureStorage.deleteEndTripStatus();
        await _secureStorage.save('logStatus', true);
        debugPrint('Auto-logout completed successfully at ${DateTime.now()}');
        // AlertService().successToast('uploaded successfully..');
        LogService().i('uploaded successfully..');
        CommonFunctions().logToFile('uploaded successfully..');
        AlertService().hideLoading();
        Navigator.pushReplacementNamed(context, 'login');
      }
    } catch (e, stack) {
      debugPrint('Error during auto-logout: $e');
      debugPrint('Stack trace: $stack');
      AlertService().errorToast('Error during auto-logout: $e');
      AlertService().showLoading();
    }
  }
}
