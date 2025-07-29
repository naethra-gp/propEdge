import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/location_service.dart';
import '../../app_services/user_service.dart';
import '../../app_storage/secure_storage.dart';

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
              // TextButton(
              //     onPressed: () {},
              //     child: Text(
              //       'Map List',
              //       style: TextStyle(
              //           color: Colors.white, decoration: TextDecoration.none),
              //     )),
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
                onSelected: (String result) async {
                  switch (result) {
                    case 'settings':
                      Navigator.pushNamed(context, "settings");
                      break;
                    // case 'ff track data':
                    //   Navigator.pushNamed(context, "track_data");
                    //   break;
                    case 'db track data':
                      Navigator.pushNamed(context, "db_track_data");
                      break;
                    case 'logout':
                      bool checkTrackStatus = await isTripInTrackingState();
                      if (checkTrackStatus) {
                        bool? isConfirmLogout = await AlertService().confirmAlert(
                            context,
                            'Alert!',
                            'Logout will end your trip. Please make sure you have completed all your trip');
                        if (isConfirmLogout!) {
                          // LocationService().stopListeningMannual();
                          confirmLogout(context);
                          return;
                        }
                      } else {
                        confirmLogout(context);
                        return;
                      }
                      // print('logout filters');
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  // PopupMenuItem<String>(
                  //   value: 'ff track data',
                  //   child: menuItem(
                  //       LineAwesome.map_marker_solid, 'Flat file', context),
                  // ),
                  PopupMenuItem<String>(
                    value: 'db track data',
                    child: menuItem(
                        LineAwesome.map_marker_solid, 'Location log', context),
                  ),
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

  logout(context) async {
    UserServices userServices = UserServices();
    BoxStorage boxStorage = BoxStorage();
    AlertService alertService = AlertService();
    alertService.showLoading();

    // Check if trip is in tracking state and handle it
    if (await isTripInTrackingState()) {
      await LocationService().stopListeningMannual();
      await LocationService().uploadDataBydate();
    }

    var token = boxStorage.getLoginToken();
    var request = {
      "loginToken": {"Token": token}
    };
    userServices.logoutService(context, request).then((response) async {
      alertService.hideLoading();
      if (response['LogoutStatus']['IsSuccess']) {
        // Store end trip date when logging out during tracking
        LocationService().deleteLocalData();
        String todayDate = DateTime.now().toString();
        List<String> endTripList = await boxStorage.get('end_trip_date') ?? [];
        if (await isTripInTrackingState()) {
          endTripList.add(todayDate);
          await boxStorage.save('end_trip_date', endTripList);
        }
        await boxStorage.deleteUserDetails();
        Navigator.pushNamedAndRemoveUntil(context, "login", (route) => false);
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  Future<bool> isTripInTrackingState() async {
    BoxStorage boxStorage = BoxStorage();
    String todayDate = DateTime.now().toString().substring(0, 10);
    List<String> startTripList = await boxStorage.get('start_trip_date') ?? [];
    List<String> endTripList = await boxStorage.get('end_trip_date') ?? [];

    debugPrint('---> Checking Trip State for Logout:');
    debugPrint('---> Today: $todayDate');
    debugPrint('---> Start Trip List: $startTripList');
    debugPrint('---> End Trip List: $endTripList');

    if (startTripList.isEmpty) return false;

    // Get the latest start and end times for today
    DateTime? lastStartTime;
    DateTime? lastEndTime;

    // Find the latest start time for today
    for (String startTime in startTripList) {
      if (startTime.substring(0, 10) == todayDate) {
        DateTime dateTime = DateTime.parse(startTime.replaceAll(' ', 'T'));
        if (lastStartTime == null || dateTime.isAfter(lastStartTime)) {
          lastStartTime = dateTime;
        }
      }
    }

    // Find the latest end time for today
    for (String endTime in endTripList) {
      if (endTime.substring(0, 10) == todayDate) {
        DateTime dateTime = DateTime.parse(endTime.replaceAll(' ', 'T'));
        if (lastEndTime == null || dateTime.isAfter(lastEndTime)) {
          lastEndTime = dateTime;
        }
      }
    }

    debugPrint('---> Last Start Time: $lastStartTime');
    debugPrint('---> Last End Time: $lastEndTime');

    // Trip is active if:
    // 1. We have a start time today AND
    // 2. Either there's no end time OR the last start is after the last end
    bool isActive = lastStartTime != null &&
        (lastEndTime == null || lastStartTime.isAfter(lastEndTime));

    debugPrint('---> Trip is active: $isActive');
    return isActive;
  }
}
