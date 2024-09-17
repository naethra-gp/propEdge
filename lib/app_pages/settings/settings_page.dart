import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:proequity/app_storage/secure_storage.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:provider/provider.dart';

import '../../app_config/app_static_functions.dart';
import '../../app_theme/app_theme.dart';
import '../../app_theme/theme_files/app_color.dart';
import '../../app_theme/theme_files/theme_provider.dart';
import '../../app_widgets/index.dart';
import 'widgets/menu_list_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  BoxStorage secureStorage = BoxStorage();
  Map<dynamic, dynamic> user = {};
  String version = "1.0.1";
  @override
  void initState() {
    getVersion();
    user = secureStorage.getUserDetails();
    super.initState();
  }
  getVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    darkMode = context.isDarkMode;
    setState(() {});
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Settings",
        action: false,
      ),
      body: Material(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: BigUserCard(
                  backgroundColor: AppColors.primary,
                  settingColor: Colors.green,
                  cardRadius: 10,
                  userName: user['Name'].toString(),
                  userProfilePic: const AssetImage("assets/images/img_2.png"),
                ),
              ),
            ),
            Expanded(
              child: Consumer<ThemeProvider>(
                builder: (c, themeProvider, _) {
                  return settings(themeProvider: themeProvider);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "App Version: $version",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            CustomTheme.defaultSize,
          ],
        ),
      ),
    );
  }

  settings({required ThemeProvider themeProvider}) {
    List<String> themeMode = [
      "Light",
      "Dark",
      "System",
    ];
    int themeValue = AppThemes.appThemeOptions.indexWhere(
      (theme) => theme.mode == themeProvider.selectedThemeMode,
    );
    return ListView(
        physics: const RangeMaintainingScrollPhysics(),
        children: ListTile.divideTiles(context: context, tiles: [
          MenuListWidget(
            themeValue: themeValue,
            leadingIcon: themeValue == 1 ? LineAwesome.moon : LineAwesome.sun,
            title: "Change Theme",
            trailing: DropdownButton(
              underline: Container(), //make underline empty
              value: themeMode[themeValue],
              onChanged: (value) {
                // int mode = themeMode.indexOf(value!);
                themeProvider.setSelectedThemeMode(
                  AppThemes.appThemeOptions[themeMode.indexOf(value!)].mode,
                );
              },
              items: themeMode.map((mode) {
                return DropdownMenuItem(
                    value: mode.toString(),
                    child: Text(
                      mode,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                    ));
              }).toList(),
            ),
          ),
          // MenuListWidget(
          //   themeValue: themeValue,
          //   leadingIcon: Icons.exit_to_app_outlined,
          //   title: "Logout",
          //   trailing: const Icon(Icons.arrow_forward_ios_outlined),
          // ),
          const Text(""),
        ]).toList());
  }
}
