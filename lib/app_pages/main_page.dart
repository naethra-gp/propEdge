import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:prop_edge/app_theme/app_color.dart';
import 'package:prop_edge/app_utils/alert_service2.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app/app_button_widget.dart';
import 'package:safe_device/safe_device.dart';

import '../app_config/app_constants.dart';
import '../app_utils/app/app_bar.dart';
import '../app_utils/app_widget/global_alert_widget.dart';
import 'index.dart';

class MainPage extends StatefulWidget {
  final int index;
  const MainPage({super.key, required this.index});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2; // Default index for Dashboard
  String appBarTitle = Constants.dashboard;
  AlertService alertService = AlertService();
  // Define the list of pages
  static const List<Widget> _pages = <Widget>[
    AssignedProperties(),
    SubmittedCase(),
    Dashboard(),
    ReimbursementPage(),
    DataSync(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.index;
    checkMockLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: AppColors.black,
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
          title: appBarTitle,
          // leading: TextButton(
          //     onPressed: () {},
          //     child: Text(
          //       'Tracking',
          //       style: TextStyle(
          //         color: Colors.white,
          //         decoration: TextDecoration.none,
          //       ),
          //     )),
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (!didPop) {
              bool? confirm = await alertService.confirmAlert(
                context,
                'Are you sure?',
                'You want to exit the application?',
              );
              if (confirm!) SystemNavigator.pop();
            }
          },
          child: _pages.elementAt(_selectedIndex),
        ),
        floatingActionButton: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      width: 0.5,
                      color: AppColors.primary,
                    ),
                  ),
                  backgroundColor: _selectedIndex == 2
                      ? const Color(0xff1980e3)
                      : const Color(0xffe8edf9),
                  foregroundColor:
                      _selectedIndex == 2 ? Colors.white : Colors.black,
                  onPressed: () => _onItemTapped(2, Constants.dashboard),
                  elevation: 16,
                  child: const Icon(LineAwesome.home_solid, size: 30),
                ),
                // Transform.translate(
                //     offset: Offset(0, 10), // Moves text upwards
                //     child: InkWell(
                //       onTap: () {
                //         print('Clicked');
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => const ViewMapPage(),
                //           ),
                //         );
                //       },
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           "Tracking",
                //           style: TextStyle(
                //             decoration: TextDecoration.none,
                //             fontWeight: FontWeight.bold,
                //             color: AppColors.primary,
                //           ),
                //         ),
                //       ),
                //     )),
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // Builds the Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      height: 60,
      surfaceTintColor: AppColors.primary,
      shadowColor: AppColors.primary,
      notchMargin: 5,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          bottomMenuDynamic(
            LineAwesome.file_alt,
            0,
            Constants.svFormTitle,
            "Site Visit",
          ),
          bottomMenuDynamic(
            LineAwesome.receipt_solid,
            1,
            Constants.caseTitle,
            "Case's",
          ),
          const Expanded(child: Text('')), // Spacer
          bottomMenuDynamic(
            LineAwesome.calculator_solid,
            3,
            Constants.reimbursementTitle,
            "Reimburse",
          ),
          bottomMenuDynamic(
            LineAwesome.sync_solid,
            4,
            Constants.dataSyncTitle,
            "Sync",
          ),
          // bottomMenuDynamic(
          //   LineAwesome.sync_solid,
          //   5,
          //   Constants.dataSyncTitle,
          //   "Tracking List",
          // ),
        ],
      ),
    );
  }

  // Creates a dynamic Bottom Menu item
  Widget bottomMenuDynamic(icon, int index, title, label) {
    ThemeData theme = Theme.of(context);
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: IconButton(
        splashColor: Colors.transparent,
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 25,
              color: isSelected ? theme.primaryColor : Colors.black,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: isSelected ? theme.primaryColor : Colors.black,
              ),
            ),
          ],
        ),
        onPressed: () => _onItemTapped(index, title),
      ),
    );
  }

  // Handles Bottom Navigation item taps
  void _onItemTapped(int index, String title) {
    setState(() {
      _selectedIndex = index;
      appBarTitle = title;
    });
  }

  checkMockLocation() async {
    bool isMockLocation = await SafeDevice.isMockLocation;
    if (isMockLocation) {
      if (!mounted) return;
      exitAlert(context);
      return;
    }
  }

  void exitAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GlobalAlertWidget(
          image: 'assets/images/pngegg.png',
          title: 'Mock Location detected!',
          description: 'Suspicious GPS activity detected!',
          buttonWidget: AppButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            title: 'Close App',
          ),
        );
      },
    );
  }
}
