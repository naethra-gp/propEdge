import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app/common_functions.dart';

import '../../app_config/app_constants.dart';
import '../../app_config/app_strings.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_theme/app_color.dart';

/// A splash screen that handles initial app navigation based on user authentication state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Duration for which the splash screen is displayed
  static const _splashDuration = Duration(seconds: 3);
  final _secureStorage = BoxStorage();
  AlertService alertService = AlertService();

  @override
  void initState() {
    debugPrint('--->>> Splash Screen <<<---');
    super.initState();
    _handleNavigation();
  }

  /// Handles navigation logic after splash screen delay
  /// Checks user permissions and authentication state to determine next screen
  Future<void> _handleNavigation() async {
    // Wait for splash screen animation
    await Future.delayed(_splashDuration);

    // Ensure widget is still mounted before navigation
    if (!mounted) return;

    // Check if user has granted necessary permissions
    final permission = _secureStorage.get("permission");
    final permissionKey = _secureStorage.containsKey("permission");
    final firstLogin = _secureStorage.get("fmtLogin");
    final firstLoginKey = _secureStorage.containsKey("fmtLogin");

    debugPrint('permission: $permission');
    debugPrint('permissionKey: $permissionKey');
    if (permission != "true" || !firstLoginKey) {
      Navigator.pushReplacementNamed(context, 'permission');
      return;
    }

    // Check user authentication state
    final user = _secureStorage.getUserDetails();
    if (user != null && user['IsSuccess'] == true) {
      // Check if it's first login of the day
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String lastLoginDate = await _secureStorage.get('last_login_date') ?? '';
      debugPrint('-------> last Login date (splash) $lastLoginDate');

      bool isFirstLoginOfDay = lastLoginDate != today;

      if (isFirstLoginOfDay) {
        // If it's a new day, redirect to login page
        bool isConfirm = await AlertService().confirmAlertOK(context, 'Alert',
            'Please log in again. Your local mobile data will now be synced to the central server. Please wait...');
        // if (isConfirm) {
        //   AlertService().showLoading();
        //   await androidLogoutCallback();
        //   AlertService().hideLoading();
        //   await _secureStorage.save('autoTriggered', true);
        //   Navigator.pushReplacementNamed(context, 'login');
        // }
        if (isConfirm) {
          AlertService().showLoading();
          // await AlertService().androidLogoutCallback(context);
          await CommonFunctions().androidLogoutCallback(context);
          AlertService().hideLoading();
        }
      } else {
        // User is authenticated and has logged in today, navigate to main page
        Navigator.pushReplacementNamed(context, 'mainPage', arguments: 2);
      }
      // LocationService().startServiceChecker();
    } else {
      // User is not authenticated, navigate to login
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: EasySplashScreen(
        logo: Image.asset(Constants.appLogo),
        backgroundColor: theme.scaffoldBackgroundColor,
        logoWidth: 150,
        showLoader: true,
        loaderColor: AppColors.primary,
        durationInSeconds: _splashDuration.inSeconds,
        title: Text(
          AppStrings.splashText,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: theme.primaryColor,
          ),
        ),
      ),
    );
  }
}
