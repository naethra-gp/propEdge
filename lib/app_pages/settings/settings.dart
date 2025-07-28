import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prop_edge/app_storage/secure_storage.dart';
import 'package:prop_edge/app_utils/alert_service.dart';

import '../../app_theme/app_color.dart';
import '../../app_utils/app/app_bar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AlertService alertService = AlertService();
  BoxStorage secureStorage = BoxStorage();
  bool isDarkMode = false;
  String _appVersion = "1.0.0";
  String _appName = "PropEdge";
  Map<dynamic, dynamic> user = {};

  @override
  void initState() {
    _fetchAppVersion();
    user = secureStorage.getUserDetails();
    super.initState();
  }

  Future<void> _fetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _appName = packageInfo.appName;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(title: 'Settings', action: false),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 25),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome ${user['Name'].toString()},",
                  textAlign: TextAlign.left,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                iconColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.label_outline),
                title: Text('App Name'),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                trailing: Text(
                  _appName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
              ListTile(
                iconColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.verified_outlined),
                title: Text('App Version'),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                trailing: Text(
                  _appVersion,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
