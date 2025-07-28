import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:prop_edge/location_service.dart';

/// A service class that handles all alert-related operations including:
/// - Loading indicators
/// - Toast messages
/// - Alert dialogs
/// - Confirmation dialogs
class AlertService {
  // Singleton instance
  static final AlertService _instance = AlertService._internal();
  factory AlertService() => _instance;
  AlertService._internal();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Common styles
  static const _toastConfig = {
    'length': Toast.LENGTH_LONG,
    'gravity': ToastGravity.BOTTOM,
    'timeInSecForIosWeb': 1,
    'fontSize': 12.0,
  };

  static const _loadingConfig = {
    'loadingStyle': EasyLoadingStyle.light,
    'indicatorType': EasyLoadingIndicatorType.fadingCircle,
    'toastPosition': EasyLoadingToastPosition.center,
    'animationStyle': EasyLoadingAnimationStyle.scale,
  };

  /// Shows a loading indicator with optional title
  Future<void> showLoading([String? title]) async {
    EasyLoading.instance
      ..loadingStyle = _loadingConfig['loadingStyle'] as EasyLoadingStyle
      ..indicatorType =
          _loadingConfig['indicatorType'] as EasyLoadingIndicatorType
      ..toastPosition =
          _loadingConfig['toastPosition'] as EasyLoadingToastPosition
      ..animationStyle =
          _loadingConfig['animationStyle'] as EasyLoadingAnimationStyle
      ..textStyle = const TextStyle(fontWeight: FontWeight.w500);

    await EasyLoading.show(
      status: title ?? 'Please wait...',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: false,
    );
  }

  /// Hides the loading indicator
  Future<void> hideLoading() async {
    await EasyLoading.dismiss();
  }

  /// Shows an error toast message
  Future<bool?> errorToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: _toastConfig['length'] as Toast,
      gravity: _toastConfig['gravity'] as ToastGravity,
      timeInSecForIosWeb: _toastConfig['timeInSecForIosWeb'] as int,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: _toastConfig['fontSize'] as double,
    );
  }

  /// Shows a success toast message
  Future<bool?> successToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: _toastConfig['length'] as Toast,
      gravity: _toastConfig['gravity'] as ToastGravity,
      timeInSecForIosWeb: _toastConfig['timeInSecForIosWeb'] as int,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: _toastConfig['fontSize'] as double,
    );
  }

  /// Shows a default toast message
  Future<bool?> toast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: _toastConfig['length'] as Toast,
      gravity: _toastConfig['gravity'] as ToastGravity,
      timeInSecForIosWeb: _toastConfig['timeInSecForIosWeb'] as int,
      fontSize: _toastConfig['fontSize'] as double,
    );
  }

  /// Common dialog builder with blur effect
  Widget _buildDialogContent({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    final theme = Theme.of(context);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.none,
          ),
        ),
        content: Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.none,
          ),
        ),
        actions: actions,
      ),
    );
  }

  /// Shows a confirmation dialog
  Future<bool?> confirmAlert(
      BuildContext context, String? title, String content) {
    final theme = Theme.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _buildDialogContent(
        context: context,
        title: title ?? "Confirm",
        content: content,
        actions: [
          TextButton(
            child: Text(
              "No",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Yes",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows an alert dialog
  Future<bool?> alert(BuildContext context, String? title, String content) {
    final theme = Theme.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _buildDialogContent(
        context: context,
        title: title ?? "Alert",
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Okay",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  confirmAlertOK(BuildContext context, String? title, String content) {
    ThemeData theme = Theme.of(context);
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Disables the back button
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              title: Text(
                title ?? "Alert",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
              content: Text(
                content.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "OK",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showLocationEnableDialog() async {
    final Location location = Location();

    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false, // Cannot tap outside to dismiss
      builder: (BuildContext context) {
        ThemeData theme = Theme.of(context);

        return PopScope(
          // onWillPop: () async => false, // Disable back button
          canPop: false,
          onPopInvokedWithResult: (didPop, result) => false,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              title: Text(
                "Location Required",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Text(
                "Please turn on the Location to continue the Process.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    bool enabled = await location.requestService();
                    if (enabled) {
                      Navigator.of(context).pop(); // Close dialog
                      // Add a small delay to ensure location service is fully enabled
                      // await Future.delayed(const Duration(milliseconds: 500));
                      // Retry getting location
                      LocationService().getCurrentLocation();
                    }
                  },
                  child: Text(
                    "Turn On",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
