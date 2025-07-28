import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unique_identifier/unique_identifier.dart';

import '../../app_config/app_constants.dart';
import '../../app_model/login_model.dart';
import '../../app_services/user_service.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_utils/alert_service.dart';
import '../../app_utils/app/app_button_widget.dart';
import '../../app_utils/app/location_service.dart';
import 'widgets/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String serialNumber = '';
  LoginRequestModel loginRequestModel = LoginRequestModel();
  BoxStorage secureStorage = BoxStorage();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController deviceIdController = TextEditingController();
  AlertService alertService = AlertService();
  UserServices userServices = UserServices();
  bool hidePassword = true;
  SizedBox defaultHeight = const SizedBox(height: 20);

  @override
  void initState() {
    super.initState();
    initSetup();
  }

  initSetup() async {
    await getDeviceId();
    _fetchAppVersion();
  }

  @override
  void dispose() {
    deviceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            LoginHeaderBg(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      heading(),
                      const SizedBox(height: 20),
                      UsernameWidget(
                        onSaved: (String value) {
                          loginRequestModel.userName = value;
                        },
                      ),
                      defaultHeight,
                      PasswordWidget(
                        hidePassword: hidePassword,
                        onSaved: (String value) {
                          loginRequestModel.password = value;
                        },
                        onPressed: () {
                          hidePassword = !hidePassword;
                          setState(() {});
                        },
                      ),
                      defaultHeight,
                      DeviceWidget(
                        controller: deviceIdController,
                        onSaved: (String value) {
                          loginRequestModel.iMEINumber = value;
                        },
                      ),
                      const SizedBox(height: 30),
                      AppButton(
                        title: 'Login',
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          checkConditions();
                        },
                      ),
                      defaultHeight,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  heading() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Login',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  getDeviceId() async {
    await Permission.phone.request();
    String uniqueId;
    try {
      uniqueId = await UniqueIdentifier.serial ?? 'Unknown';
    } on PlatformException {
      uniqueId = 'Failed to get platform version.';
    }
    setState(() {
      serialNumber = uniqueId;
      loginRequestModel.iMEINumber = serialNumber;
      deviceIdController.text = serialNumber;
    });
  }

  checkConditions() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      alertService.showLoading("Fetching User's Location...");
      await getLocation();
      alertService.hideLoading();
      formSubmit();
    }
  }

  Future<void> _fetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid) {
      String version = androidInfo.version.release.toString();
      loginRequestModel.appVersion = packageInfo.version.toString();
      loginRequestModel.platform = "Android";
      loginRequestModel.platformVersion = version;
    }
  }
  getLocation() async {
    try {
      LocationData? position = await LocationService().getCurrentLocation();
      debugPrint("position $position");
      loginRequestModel.latitude = position?.latitude?.toString() ?? "";
      loginRequestModel.longitude = position?.longitude?.toString() ?? "";
    } catch (e) {
      debugPrint("Error getting location: $e");
      alertService.errorToast('Error getting location. Please check your location settings.');
    }
  }

  formSubmit() {
    // TODO: CHECK BEFORE LIVE MODE ---
    loginRequestModel.userName = "gnanaprakasam@naethra.com";
    loginRequestModel.password = "User@123";
    loginRequestModel.iMEINumber = "8ef32d2c35806173";

    /// LIVE ---
    if (loginRequestModel.latitude == null ||
        loginRequestModel.longitude == null ||
        loginRequestModel.latitude!.isEmpty ||
        loginRequestModel.longitude!.isEmpty) {
      alertService.errorToast('Location Error. Unable to Login');
      return;
    }
    alertService.showLoading("Verifying Login Details...");
    var params = {
      "userDetail": {
        "UserName": loginRequestModel.userName,
        "Password": loginRequestModel.password,
        "IMEINumber": loginRequestModel.iMEINumber,
        "AppVersion": loginRequestModel.appVersion,
        "Platform": loginRequestModel.platform,
        "PlatformVersion": loginRequestModel.platformVersion,
        "Latitude": loginRequestModel.latitude,
        "Longitude": loginRequestModel.longitude,
      },
      "userCredential": {
        "ClientName": Constants.clientName,
        "Password": Constants.clientPassword
      }
    };
    debugPrint("Login Params: ${jsonEncode(params)}");
    userServices.loginService(context, params).then((res) async {
      alertService.hideLoading();
      
      if (res == null) {
        alertService.errorToast('Server error occurred. Please try again.');
        return;
      }

      try {
        final loginStatus = res['LoginStatus'];
        if (loginStatus == null) {
          await alertService.errorToast('Invalid response from server');
          return;
        }

        String msg = loginStatus['Message']?.toString() ?? 'Unknown error occurred';
        
        if (loginStatus['IsSuccess'] == true) {
          await secureStorage.saveUserDetails(loginStatus);
          Navigator.pushNamedAndRemoveUntil(
              context, 'mainPage', arguments: 2, (_) => false);
        } else {
          await alertService.errorToast(msg);
        }
      } catch (e) {
        debugPrint("Error processing login response: $e");
        await alertService.errorToast('Error processing server response');
      }
    }).catchError((error) {
      alertService.hideLoading();
      debugPrint("Login error: $error");
      alertService.errorToast('Connection error. Please try again.');
    });
  }
}
