import 'dart:convert';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:retry/retry.dart';

import '../app_config/app_constants.dart';
import '../app_storage/secure_storage.dart';
import '../app_utils/alert_service2.dart';
import '../app_utils/app/app_button_widget.dart';
import '../app_utils/app_widget/global_alert_widget.dart';

class Connection {
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  final AlertService _alertService = AlertService();
  final BoxStorage _secureStorage = BoxStorage();

  // Check if the device is connected to the internet
  Future<bool> isConnectedToInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Future<Map<String, dynamic>?> post(
      String url, Map<String, dynamic> body) async {
    if (!await isConnectedToInternet()) {
      _alertService.hideLoading();
      _alertService.errorToast(Constants.internetErrorMessage);
      return null;
    }

    try {
      final headers = {
        ..._defaultHeaders,
        'Authorization':
            'Basic ${base64Encode(utf8.encode("${Constants.basicAuthUsername}:${Constants.basicAuthPassword}"))}',
      };

      final retryOptions = RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 3),
        maxDelay: const Duration(seconds: 15),
      );

      final response = await retryOptions.retry(
        () async {
          if (!await isConnectedToInternet()) {
            _alertService.hideLoading();
            throw HttpException(Constants.internetErrorMessage);
          }

          final res = await http.post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
            encoding: Encoding.getByName('utf-8'),
          );

          if (res.statusCode == 401) {
            final context = AlertService.navigatorKey.currentContext;
            if (context != null && context.mounted) {
              await _secureStorage.deleteUserDetails();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (route) => false);
            }
            return res;
          }
          if (res.statusCode == 200) {
            return res;
          }

          throw HttpException('API call failed with status: ${res.statusCode}');
        },
        retryIf: (e) => e is http.ClientException || e is HttpException,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }

      final result = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 401) {
        _alertService.hideLoading();
        await _secureStorage.deleteUserDetails();
        _showLogoutAlert(result);
      } else {
        _alertService.hideLoading();
        _alertService.errorToast(
            result['ExceptionMessage']?.toString() ?? 'Unknown error occurred');
      }
      return null;
    } catch (e, stackTrace) {
      _alertService.hideLoading();
      if (e is SocketException) {
        _alertService.errorToast(
            'Please check your network connection. Poor network connection');
      } else {
        FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: true);
        _alertService.errorToast(e.toString());
      }
      return null;
    }
  }

  void _showLogoutAlert(Map<String, dynamic> result) {
    final context = AlertService.navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => GlobalAlertWidget(
        image: 'assets/images/logout.png',
        title: result['Title']?.toString() ?? 'Session Expired',
        description: result['ExceptionMessage']?.toString() ??
            'Your session has expired. Please login again.',
        buttonWidget: AppButton(
          onPressed: () async {
            await _secureStorage.deleteUserDetails();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'login',
                (route) => false,
              );
            }
          },
          title: 'Okay',
        ),
      ),
    );
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);
  @override
  String toString() => message;
}
