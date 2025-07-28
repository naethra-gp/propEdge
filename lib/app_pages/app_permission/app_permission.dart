import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app_storage/secure_storage.dart';
import '../../app_utils/app/app_button_widget.dart';
import '../../app_utils/app/common_functions.dart';
import 'widget/ap_list_tile.dart';

class AppPermission extends StatefulWidget {
  const AppPermission({super.key});

  @override
  State<AppPermission> createState() => _AppPermissionState();
}

class _AppPermissionState extends State<AppPermission> {
  // Instance of secure storage
  final BoxStorage _boxStorage = BoxStorage();

  // Static list of required permissions with their descriptions
  static const List<Map<String, String>> _permissionList = [
    {
      "title": "Camera Permission",
      "description":
          "The app uses the camera to capture photos and videos of the property during surveys and uploads them to the live server."
    },
    {
      "title": "Location Permission",
      "description":
          "The app requires access to the customer's property location to retrieve their current latitude and longitude."
    },
    {
      "title": "Phone State Permission",
      "description":
          "The app uses the customer's device ID to ensure that only registered customers can access the app."
    },
    {
      "title": "Battery Optimization",
      "description":
          "To ensure proper functionality, please disable battery optimization for this app."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              // Title section
              const Text(
                "We required following permissions",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Generate permission list tiles
              ..._permissionList.map((permission) => Column(
                    children: [
                      ApListTile(
                        title: permission['title']!,
                        description: permission['description']!,
                      ),
                      const Divider(),
                    ],
                  )),
              const SizedBox(height: 25),
              // Proceed button
              AppButton(
                title: "Proceed",
                onPressed: () => _handlePermissions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles requesting all required permissions and navigation
  Future<void> _handlePermissions(BuildContext context) async {
    try {
      // Request all required permissions
      await [
        Permission.camera,
        Permission.location,
        Permission.phone,
        Permission.notification,
      ].request();

      // Save permission status
      await _boxStorage.save("permission", "true");
      await _boxStorage.save("fmtLogin", true);

      // Check battery optimization
      await CommonFunctions().checkBatteryOptimization();

      // Navigate to login screen if context is still valid
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
    } catch (e, stackTrace) {
      CommonFunctions()
          .appLog(e, stackTrace, fatal: true, reason: "PERMISSION SCREEN");
    }
  }
}
