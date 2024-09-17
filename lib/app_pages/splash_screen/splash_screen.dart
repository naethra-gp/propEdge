import 'dart:io';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proequity/app_pages/app_main_page.dart';

import '../../app_config/index.dart';
import '../../app_storage/secure_storage.dart';
import '../user/login/login_page.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
    // createStorageFolder();
    Future.delayed(const Duration(seconds: 2), () {
      getValidationData();
    });
    // permission();
  }

  createStorageFolder() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
  }

  Future getValidationData() async {
    debugPrint('--->>> Splash Screen <<<---');
    var user = secureStorage.getUserDetails();
    var permission = secureStorage.get("permission");
    if (permission != "true") {
      Navigator.pushReplacementNamed(context, 'permission');
    } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return EasySplashScreen(
      logo: Image.asset(Constants.appLogo),
      logoWidth: 150,
      title: Text(
        "Your trusted companion during buying and selling of your property",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: theme.primaryColor),
      ),
      showLoader: false,
      navigator: dynamicNavigation(),
      durationInSeconds: 3,
    );
  }

  dynamicNavigation() async {
    return isLoggedIn == false ? const LoginPage() : const MainPage(index: 2);
  }
}
