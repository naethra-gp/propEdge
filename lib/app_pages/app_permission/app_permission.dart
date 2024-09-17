import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proequity/app_storage/secure_storage.dart';
import 'package:proequity/app_widgets/app_common/app_button_widget.dart';

import '../../app_storage/local_storage.dart';

class AppPermission extends StatefulWidget {
  const AppPermission({super.key});

  @override
  State<AppPermission> createState() => _AppPermissionState();
}

class _AppPermissionState extends State<AppPermission> {
  BoxStorage boxStorage = BoxStorage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              const Text(
                "We required following permissions",
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 16),
              const ListTile(
                title: Text(
                  "Location Permission",
                  style: TextStyle(
                    // fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "The app requires access to the customer's property location to retrieve their current latitude and longitude.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // fontSize: 18,
                  ),
                ),
              ),
              const Divider(),
              const ListTile(
                title: Text(
                  "Phone State Permission",
                  style: TextStyle(
                    // fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "The app uses the customer's device ID to ensure that only registered customers can access the app.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // fontSize: 18,
                  ),
                ),
              ),
              const Divider(),
              const ListTile(
                title: Text(
                  "Storage Permission",
                  style: TextStyle(
                    // fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "The app uses local storage to save customer property-related data in the local database.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // fontSize: 18,
                  ),
                ),
              ),
              const Divider(),
              const ListTile(
                title: Text(
                  "Camera Permission",
                  style: TextStyle(
                    // fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "The app uses the camera to capture photos and videos of the property during surveys and uploads them to the live server.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // fontSize: 18,
                  ),
                ),
              ),
              // const Divider(),
              const SizedBox(height: 25),
              SizedBox(
                child: AppButton(
                  title: "Proceed",
                  onPressed: () {
                    getPermission(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  getPermission(BuildContext ctx) async {
    PermissionStatus status;
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.phone,
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.camera,
    ].request();
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
    if ((info.version.sdkInt) >= 33) {
      await LocalStorage.getDBFolder();
      await LocalStorage.getReimbursementFolder();
    }
    boxStorage.save("permission", "true");
    debugPrint("statuses -- $statuses");
    Navigator.pushNamedAndRemoveUntil(ctx, "login", (router) => false);
  }
}
