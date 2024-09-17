import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proequity/app_config/index.dart';
import 'package:proequity/app_pages/index.dart';
import 'package:proequity/app_widgets/index.dart';

import 'site_visit_form/assigned_properties.dart';

class MainPage extends StatefulWidget {
  final int index;
  const MainPage({super.key, required this.index});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 2;
  String appBarTitle = Constants.dashboard;

  static const List<Widget> _pages = <Widget>[
    AssignedPropertiesPage(),
    CasePage(),
    DashboardPage(),
    ReimbursementPage(),
    DataSyncPage(),
  ];

  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.index;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(title: appBarTitle),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          final bool shouldPop = await _onBack(context);
          if (shouldPop) {
            SystemNavigator.pop();
          }
        },
        child: _pages.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _selectedIndex == 2
            ? const Color(0xff1980e3)
            : const Color(0xffe8edf9),
        foregroundColor: _selectedIndex == 2 ? Colors.white : Colors.black,
        onPressed: () {
          _onItemTapped(2, Constants.dashboard);
        },
        elevation: 16,
        child: const Icon(Icons.home_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        notchMargin: 5,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            bottomMenuDynamic(LineAwesome.file_alt, 0, Constants.svFormTitle, "Site Visit"),
            bottomMenuDynamic(
                LineAwesome.receipt_solid, 1, Constants.caseTitle, "Case's"),
            const Expanded(child: Text('')),
            bottomMenuDynamic(
                LineAwesome.calculator_solid, 3, Constants.reimbursementTitle, "Reimburse"),
            bottomMenuDynamic(
                LineAwesome.sync_solid, 4, Constants.dataSyncTitle, "Sync"),
          ],
        ),
      ),
    );
  }

  _onItemTapped(int index, String title) {
    setState(() {
      _selectedIndex = index;
      appBarTitle = title;
    });
  }

  Future<bool> _onBack(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text(
            'Exit App',
            style:
                TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to Exit app?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'No',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      }),
    );

    return exitApp ?? false;
  }

  // DYNAMIC BOTTOM MENU WIDGET
  Widget bottomMenuDynamic(IconData icon, int index, String title, String label) {
    var theme = Theme.of(context);
    return Expanded(
      // child: IconButton(
      //   icon: Icon(icon,
      //       size: 25,
      //       color: _selectedIndex == index ? theme.primaryColor : Colors.black),
      //   onPressed: () {
      //     _onItemTapped(index, title.toString());
      //   },
      // ),
      child: IconButton(
        icon: InkWell(
          // onTap: dataSync,
          splashFactory: InkRipple.splashFactory,
          splashColor: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 25,
                color:
                    _selectedIndex == index ? theme.primaryColor : Colors.black,
              ),
              Text(
                label.toString(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color:
                  _selectedIndex == index ? theme.primaryColor : Colors.black,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          _onItemTapped(index, title.toString());
        },
      ),
    );
  }
}
