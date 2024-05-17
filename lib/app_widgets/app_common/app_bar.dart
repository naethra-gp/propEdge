import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proequity/app_widgets/alert_widget.dart';

import '../../app_services/index.dart';
import '../../app_storage/secure_storage.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? action;
  final bool? automaticallyImplyLeading;
  final Widget? leading;
  const AppBarWidget(
      {super.key,
      required this.title,
      this.action,
      this.leading,
      this.automaticallyImplyLeading});

  // Get Preferred Size For App Bar Widget
  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    var appBarHeight = AppBar().preferredSize.height;
    return AppBar(
      // iconTheme: const IconThemeData(color: Colors.white),
      // backgroundColor: theme.primaryColor,
      // shadowColor: theme.primaryColor,
      elevation: 5,
      leading: leading,
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      title: Text(
        title.toString(),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
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
                        menuItem(Icons.settings_outlined, 'Settings', context),
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
      title: Text(text.toString()),
    );
  }

  confirmLogout(ctx) {
    return showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'Confirm',
          style: GoogleFonts.lilitaOne().copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.exo2().copyWith(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'No',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white),
            child: const Text(
              'Yes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
    );
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
    // Hive.box('PROP_EQUITY_CONTROLS').clear();
    userServices.logoutService(context, request).then((response) async {
      alertService.hideLoading();
      if (response['LogoutStatus']['IsSuccess']) {
        await boxStorage.deleteUserDetails();
        Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
      } else {
        Navigator.of(context).pop();
      }
    });
  }
}
