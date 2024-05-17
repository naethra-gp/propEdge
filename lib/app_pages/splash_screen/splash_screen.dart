import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:proequity/app_pages/app_main_page.dart';

import '../../app_config/index.dart';
import '../../app_storage/secure_storage.dart';
import '../user/login/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  BoxStorage secureStorage = BoxStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      getValidationData();
    });
  }

  Future getValidationData() async {
    debugPrint('--->>> Splash Screen <<<---');
    var user = secureStorage.getUserDetails();
    var checkPermission = secureStorage.get("setPermission");
    if (checkPermission != null && checkPermission) {
      if (user != null) {
        if (user['IsSuccess'] == true) {
          isLoggedIn = true;
          Navigator.pushReplacementNamed(context, 'mainPage', arguments: 2);
        } else {
          isLoggedIn = false;
          Navigator.pushReplacementNamed(context, 'login');
        }
      } else {
        isLoggedIn = false;
        Navigator.pushReplacementNamed(context, 'login');
      }
    } else {
      Navigator.pushReplacementNamed(context, 'askPermission');
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return EasySplashScreen(
      logo: Image.asset(Constants.appLogo),
      logoWidth: 150,
      title: Text(
        " Your trusted companion during buying and selling of your property ",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: theme.primaryColor,
        ),
      ),
      showLoader: false,
      navigator: dynamicNavigation(),
      durationInSeconds: 3,
    );
  }

  dynamicNavigation() async {
    return isLoggedIn == false
        ? const LoginPage()
        : const MainPage(
            index: 2,
          );
  }
}
