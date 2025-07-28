import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../app_services/user_service.dart';
import '../../app_storage/secure_storage.dart';
import '../alert_service.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? action;
  final bool? automaticallyImplyLeading;
  final Widget? leading;
  const AppBarWidget({
    super.key,
    required this.title,
    this.action,
    this.leading,
    this.automaticallyImplyLeading,
  });

  // Get Preferred Size For App Bar Widget
  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    return AppBar(
      elevation: 5,
      leading: leading,
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      title: Text(
        title.toString(),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: action == false
          ? []
          : [
              PopupMenuButton<String>(
                offset: Offset(0.0, appBarHeight),
                icon: const Icon(
                  LineAwesome.user_circle,
                  color: Colors.white,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                onSelected: (String result) {
                  switch (result) {
                    case 'settings':
                      Navigator.pushNamed(context, "settings");
                      break;
                    case 'logout':
                      confirmLogout(context);
                      // print('logout filters');
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'settings',
                    child:
                        menuItem(LineAwesome.tools_solid, 'Settings', context),
                  ),
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: menuItem(
                        LineAwesome.power_off_solid, 'Logout', context),
                  ),
                ],
              ),
            ],
    );
  }

  Widget menuItem(IconData icon, String text, ctx) {
    var theme = Theme.of(ctx);
    return ListTile(
      leading: Icon(
        icon,
        color: theme.primaryColor,
      ),
      title: Text(
        text.toString(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  confirmLogout(ctx) async {
    bool? confirm = await AlertService().confirmAlert(
      ctx,
      'Confirm',
      "Are you sure you want to logout?",
    );
    if (confirm!) {
      logout(ctx);
    }
  }

  logout(context) {
    UserServices userServices = UserServices();
    BoxStorage boxStorage = BoxStorage();
    AlertService alertService = AlertService();
    alertService.showLoading();
    var token = boxStorage.getLoginToken();
    var request = {
      "loginToken": {"Token": token}
    };
    userServices.logoutService(context, request).then((response) async {
      alertService.hideLoading();
      if (response != null && response['LogoutStatus']['IsSuccess']) {
        await boxStorage.deleteUserDetails();
        Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
      } else {
        Navigator.of(context).pop();
      }
    });
  }
}
