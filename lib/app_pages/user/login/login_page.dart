import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_config/index.dart';
import '../../../app_model/app_models.dart';
import '../../../app_services/index.dart';
import '../../../app_storage/local_storage.dart';
import '../../../app_storage/secure_storage.dart';
import '../../../app_widgets/alert_widget.dart';

import '../../../app_widgets/app_common/app_button_widget.dart';
import 'package:flutter_unique_id/flutter_unique_id.dart' as flutter_unique_id;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String serialNumber = '';
  LoginRequestModel loginRequestModel = LoginRequestModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController deviceIdController = TextEditingController();
  AlertService alertService = AlertService();
  UserServices userServices = UserServices();
  bool hidePassword = true;
  SizedBox defaultHeight = const SizedBox(height: 20);

  @override
  void initState() {
    permission();
    getDeviceId();
    // setState(() {
    //   userNameController.text = 'gnanaprakasam@naethra.com';
    //   passWordController.text = 'User@123';
    // loginRequestModel.iMEINumber = "8ef32d2c35806173";
    // deviceIdController.text = "8ef32d2c35806173";
    // });
    super.initState();
  }

  permission() async {
    // PermissionStatus status;
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.phone,
    //   Permission.camera,
    //   Permission.location,
    //   Permission.storage,
    //   Permission.manageExternalStorage,
    // ].request();
    // print(statuses[Permission.location]);
    // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
    // print("sdk --> ${info.version.sdkInt}");
    // if ((info.version.sdkInt) >= 33) {
    //   // status = await Permission.manageExternalStorage.request();
    //   var path = await ExternalPath.getExternalStoragePublicDirectory(
    //       ExternalPath.DIRECTORY_DOWNLOADS);
    //   await LocalStorage.getDBFolder();
    //   await LocalStorage.getReimbursementFolder();
    // } else {
    //   status = await Permission.storage.request();
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            headerBgImage(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          heading('Login'),
                          const SizedBox(height: 20),
                          userNameField(),
                          defaultHeight,
                          passwordField(),
                          defaultHeight,
                          deviceIdField(),
                          const SizedBox(height: 30),
                          AppButton(
                            title: 'Login',
                            onPressed: () {
                              formSubmit();
                            },
                          ),
                          defaultHeight,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  headerBgImage() {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.3,
      child: Container(
        height: 600,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login-bg-1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            Constants.appLogo,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  heading(String title) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  getDeviceId() async {
    await Permission.phone.request();
    String uniqueId;
    try {
      uniqueId = await flutter_unique_id.getUniqueId() ?? 'Unknown';
    } on PlatformException {
      uniqueId = 'Failed to get platform version.';
    }
    setState(() {
      serialNumber = uniqueId;
      loginRequestModel.iMEINumber = serialNumber;
      deviceIdController.text = serialNumber;
    });
  }

  Widget formField() {
    var theme = Theme.of(context);
    return TextFormField(
      obscureText: false,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.w500),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        // label: Text("Username"),
        hintText: 'Username',
        prefixIcon: Icon(LineAwesome.user_circle, color: theme.primaryColor),
        labelStyle: TextStyle(color: theme.primaryColor),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.5))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.5))),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        hintStyle: TextStyle(color: theme.primaryColor),
      ),
    );
  }

  userNameField() {
    var theme = Theme.of(context);
    return TextFormField(
      controller: userNameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500, color: theme.primaryColor, fontSize: 16),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        loginRequestModel.userName = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Username is mandatory!';
        }
        return null;
      },
      decoration: InputDecoration(
        // label: Text("Username"),
        hintText: 'Username',
        prefixIcon: Icon(LineAwesome.user_circle, color: theme.primaryColor),
        labelStyle: TextStyle(color: theme.primaryColor),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.5))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.5))),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        hintStyle: TextStyle(color: theme.primaryColor),
      ),
    );
  }

  passwordField() {
    var theme = Theme.of(context);
    return TextFormField(
      controller: passWordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: hidePassword,
      style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500, color: theme.primaryColor, fontSize: 16),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onSaved: (value) {
        loginRequestModel.password = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is mandatory!';
        }
        return null;
      },
      decoration: InputDecoration(
        // label: Text("Username"),
        hintText: 'Password',
        prefixIcon: Icon(LineAwesome.lock_solid, color: theme.primaryColor),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
          icon: Icon(hidePassword ? LineAwesome.eye : LineAwesome.eye_slash,
              size: 20, color: Theme.of(context).primaryColor),
        ),
        labelStyle: TextStyle(color: theme.primaryColor),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.5))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.5))),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        hintStyle: TextStyle(color: theme.primaryColor),
      ),
    );
  }

  deviceIdField() {
    var theme = Theme.of(context);
    return TextFormField(
      readOnly: true,
      controller: deviceIdController,
      style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500, color: theme.primaryColor, fontSize: 16),
      keyboardType: TextInputType.text,
      onSaved: (value) {
        loginRequestModel.iMEINumber = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Device ID is mandatory!';
        }
        return null;
      },
      decoration: InputDecoration(
        // label: Text("Username"),
        hintText: 'Device ID',
        prefixIcon:
            Icon(LineAwesome.mobile_alt_solid, color: theme.primaryColor),
        suffixIcon: IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: deviceIdController.text))
                .then((_) {
              alertService.toast('Copied to clipboard');
            });
          },
          icon: Icon(Icons.copy_outlined,
              size: 20, color: Theme.of(context).primaryColor),
        ),
        labelStyle: TextStyle(color: theme.primaryColor),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.5))),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.5))),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        hintStyle: TextStyle(color: theme.primaryColor),
      ),
    );
  }

  formSubmit() async {
    var hasInternet = await InternetConnectivity().hasInternetConnection;
    if (hasInternet) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        alertService.showLoading();
        var requestData = {
          "userDetail": {
            "UserName": loginRequestModel.userName,
            "Password": loginRequestModel.password,
            "IMEINumber": loginRequestModel.iMEINumber,

            // "UserName": "gnanaprakasam@naethra.com",
            // "Password": "User@123",
            // "IMEINumber": "8ef32d2c35806173",

            // "UserName": "haribasker.m@naethra.com",
            // "Password": "Hari@2016",
            // "IMEINumber": "00000000-5675-d2ff-ffff-ffff901140ac"

            // "UserName": "sriram.g@naethra.com",
            // "Password": "User@123",
            // "IMEINumber": "ffffffff-87f2-ca79-ffff-ffffaeafa913",
          },
          "userCredential": {
            "ClientName": Constants.clientName,
            "Password": Constants.clientPassword
          }
        };
        // print('Login Data -> ${jsonEncode(requestData)}');
        // if (!mounted) return;
        userServices.loginService(context, requestData).then((response) async {
          // print("response ${jsonEncode(response)}");
          var msg = response['LoginStatus']['Message'];
          if (response['LoginStatus']['IsSuccess']) {
            alertService.hideLoading();
            alertService.successToast(msg);
            BoxStorage secureStorage = BoxStorage();
            secureStorage.saveUserDetails(response['LoginStatus']);
            Navigator.pushNamedAndRemoveUntil(
                context, 'mainPage', arguments: 2, (route) => false);
          } else {
            alertService.hideLoading();
            alertService.errorToast(msg);
          }
        });
      } else {
        alertService.hideLoading();
        AlertService().errorToast("Login failed!");
      }
    } else {
      alertService.hideLoading();
      AlertService().errorToast("Please check your internet connection!");
    }
  }
}
