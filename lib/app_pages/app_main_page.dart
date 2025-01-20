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
  int _selectedIndex = 2; // Default index for Dashboard
  String appBarTitle = Constants.dashboard;

  // Define the list of pages
  static const List<Widget> _pages = <Widget>[
    AssignedPropertiesPage(),
    CasePage(),
    DashboardPage(),
    ReimbursementPage(),
    DataSyncPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(title: appBarTitle),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (!didPop) {
            final shouldPop = await _onBack(context);
            if (shouldPop) SystemNavigator.pop();
          }
        },
        child: _pages.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _selectedIndex == 2
            ? const Color(0xff1980e3)
            : const Color(0xffe8edf9),
        foregroundColor: _selectedIndex == 2 ? Colors.white : Colors.black,
        onPressed: () => _onItemTapped(2, Constants.dashboard),
        elevation: 16,
        child: const Icon(Icons.home_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Builds the Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      height: 60,
      notchMargin: 5,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          bottomMenuDynamic(LineAwesome.file_alt, 0, Constants.svFormTitle, "Site Visit"),
          bottomMenuDynamic(LineAwesome.receipt_solid, 1, Constants.caseTitle, "Case's"),
          const Expanded(child: Text('')), // Spacer
          bottomMenuDynamic(LineAwesome.calculator_solid, 3, Constants.reimbursementTitle, "Reimburse"),
          bottomMenuDynamic(LineAwesome.sync_solid, 4, Constants.dataSyncTitle, "Sync"),
        ],
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

  // Handles Back Button Press
  Future<bool> _onBack(BuildContext context) async {
    final exitApp = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Exit App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to exit the app?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return exitApp ?? false;
  }

  // Creates a dynamic Bottom Menu item
  Widget bottomMenuDynamic(IconData icon, int index, String title, String label) {
    final theme = Theme.of(context);
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: IconButton(
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 25, color: isSelected ? theme.primaryColor : Colors.black),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: isSelected ? theme.primaryColor : Colors.black,
              ),
            ),
          ],
        ),
        onPressed: () => _onItemTapped(index, title),
      ),
    );
  }
}
