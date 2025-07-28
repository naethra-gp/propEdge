import 'dart:async';

import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';
// import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app_widget/no_data_found.dart';
import 'package:prop_edge/location_service.dart';
import '../../app_config/app_constants.dart';
import '../../app_services/local_db/local_services/property_list_services.dart';
import '../../app_services/local_db/local_services/user_case_summary_service.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_theme/app_color.dart';
import '../../app_theme/custom_theme.dart';
import '../../app_utils/app/common_functions.dart';
// import '../../app_utils/app/location_service.dart';
import '../../app_utils/app/search_widget.dart';
import '../assigned_properties/widget/property_expansion_widget.dart';
import 'widgets/first_card_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // State variables
  List userSummary = [];
  List propertyList = [];
  List foundProperty = [];
  List propertyListLocal = [];
  final BoxStorage secureStorage = BoxStorage();
  final AlertService alertService = AlertService();
  final PropertyListService service = PropertyListService();
  final TextEditingController searchController = TextEditingController();
  int? expandedItemIndex;
  final Color selectedColor = const Color(0xff587CEC);
  final List<Map<String, bool>> activeColor =
      List<Map<String, bool>>.generate(4, (_) => {"selected": false});
  BoxStorage boxStorage = BoxStorage();

  LocationService tracking = LocationService();
  List locList = [];
  List latLongList = [];
  bool strtClick = false;
  bool endclick = false;

  @override
  void initState() {
    super.initState();
    debugPrint("----> Dashboard Page <----");
    CommonFunctions().loadData(context);
    _initializeData();
    searchController.addListener(_searchListener);
    loadState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh state when returning to dashboard
    loadState();
  }

  // Initialize data on page load
  Future<void> _initializeData() async {
    CommonFunctions().checkPermission();
    await Future.wait([
      getPropertyList(),
      getUserCaseSummary(),
    ]);
  }

  void loadState() async {
    String todayDate = DateTime.now().toString().substring(0, 10);

    List<String> startTripList = await boxStorage.get('start_trip_date') ?? [];
    Set<String> endTripList =
        (await boxStorage.get('end_trip_date') ?? <String>[]).toSet();

    debugPrint('------> EL $endTripList');

    if (endTripList.length < startTripList.length) {
      setState(() {
        strtClick = true;
        endclick = false;
      });
    } else if (endTripList.length == startTripList.length) {
      setState(() {
        strtClick = false;
        endclick = true;
      });
    }

    debugPrint('---> Checking Dashboard State:');
    debugPrint('---> Today: $todayDate');
    debugPrint('---> Start Trip List: $startTripList');
    debugPrint('---> End Trip List: $endTripList');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Column(
            children: <Widget>[
              CustomTheme.defaultSize,
              if (userSummary.isNotEmpty) ...[
                _buildSummaryCards(),
                CustomTheme.defaultSize,
                _buildAllocationCard(),
              ],
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TrackButton(
                      title: 'Start Trip',
                      onclick: strtClick
                          ? null
                          : () async {
                              bool? isOptimize =
                                  await DisableBatteryOptimizationLatest
                                      .isBatteryOptimizationDisabled;

                              if (isOptimize == false) {
                                // Check if battery optimization is enabled
                                if (!context.mounted) return;
                                bool? confirm = await alertService.confirmAlert(
                                  context,
                                  'Disable Battery Optimization',
                                  'To ensure proper functionality, please disable battery optimization for this app.',
                                );

                                if (confirm!) {
                                  await CommonFunctions()
                                      .checkBatteryOptimization();
                                  return;
                                }
                              }
                              bool? isConfirm = await alertService.confirmAlert(
                                  context,
                                  'Start Trip',
                                  'Current location will be consider as start location. Please confirm to proceed.');
                              if (isConfirm!) {
                                alertService.showLoading();
                                await tracking.startTrackingFromCurrent();
                                /* String today = DateTime.now().toString().split(' ')[0];
                            boxStorage.save('start_trip_date', today);
                           */
                                String timestamp =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(DateTime.now());
                                List<String> startTripList =
                                    await boxStorage.get('start_trip_date') ??
                                        [];
                                startTripList
                                    .add(timestamp); // Store full timestamp
                                await boxStorage.save(
                                    'start_trip_date', startTripList);

                                setState(() {
                                  strtClick = true;
                                  endclick = false;
                                });
                                alertService.hideLoading();
                              }
                            },
                      color: Colors.green,
                    ),
                    if (strtClick)
                      TrackButton(
                        title: 'End Trip',
                        onclick: endclick
                            ? null
                            : () async {
                                bool? isConfirm = await alertService.confirmAlert(
                                    context,
                                    'End Trip',
                                    'Your Location tracking will get stop and you could not start any new trip for the day. Do you want to stop this tracking?');
                                if (isConfirm!) {
                                  alertService.showLoading();
                                  await tracking.stopListeningMannual();
                                  // await locService.stopLocationTracking();
                                  /*String today = DateTime.now().toString().split(' ')[0];
                            boxStorage.save('end_trip_date', today);*/
                                  String timestamp =
                                      DateFormat('yyyy-MM-dd HH:mm')
                                          .format(DateTime.now());
                                  List<String> endTripList =
                                      await boxStorage.get('end_trip_date') ??
                                          [];
                                  endTripList
                                      .add(timestamp); // Store full timestamp
                                  await boxStorage.save(
                                      'end_trip_date', endTripList);

                                  setState(() {
                                    endclick = true;
                                    strtClick = false;
                                  });
                                  //await getLocation();
                                  alertService.hideLoading();
                                }
                              },
                        color: Colors.red,
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _buildSearchBar(),
              CustomTheme.defaultSize,
              Expanded(
                child: foundProperty.isEmpty
                    ? const NoDataFound()
                    : PropertyExpansionWidget(
                        searchList: foundProperty,
                        onUpload: (done) {
                          if (done) {
                            getPropertyList();
                          }
                        },
                        onPropertySubmitted: () {
                          // Refresh both property list and user summary
                          _initializeData();
                        },
                      ),
              ),
              CustomTheme.defaultSize,
            ],
          ),
        ),
      ),
    );
  }

  // Build summary cards row
  Widget _buildSummaryCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FirstCardWidget(
          title: 'Total Cases',
          count: userSummary[0]['TotalCase'].toString(),
          color: Constants.dashCaseColor,
        ),
        FirstCardWidget(
          title: 'Total Visit',
          count: (int.parse(userSummary[0]['CaseSubmittedToday'].toString()) +
                  propertyListLocal.length)
              .toString(),
          color: Constants.dashTotalColor,
        ),
        FirstCardWidget(
          title: 'Submitted Case',
          count: userSummary[0]['CaseSubmitted'].toString(),
          color: Constants.dashSubmitColor,
        ),
      ],
    );
  }

  // Build allocation card
  Widget _buildAllocationCard() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: AppColors.primary,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "ALLOCATION",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 0.5,
                  height: 0,
                  indent: 10,
                  endIndent: 10,
                ),
                if (userSummary.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _buildHomeCard(
                            'Spill', userSummary[0]['SpillCase'].toString(), 0),
                        _buildHomeCard(
                            'Today', userSummary[0]['TodayCase'].toString(), 1),
                        _buildHomeCard('Tomorrow',
                            userSummary[0]['TomorrowCase'].toString(), 2),
                        _buildHomeCard('Total',
                            userSummary[0]['CaseForVisit'].toString(), 3),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Build search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 45,
        child: SearchWidget(
          controller: searchController,
          hintText: "Search...",
        ),
      ),
    );
  }

  // Build home card with optimized rebuilds
  Widget _buildHomeCard(String title, String count, int index) {
    final isSelected = activeColor[index]["selected"] ?? false;
    return Expanded(
      child: GestureDetector(
        onTap: () => _allocationClick(index, title),
        child: Card(
          elevation: 10,
          color: isSelected ? const Color(0xff364a91) : const Color(0xff587CEC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(
              color: isSelected ? Colors.white : Colors.transparent,
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 9,
                            color: Colors.white,
                          ) ??
                      const TextStyle(fontSize: 9, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                          ) ??
                      const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Handle allocation card click with optimized filtering
  void _allocationClick(int index, String title) {
    setState(() {
      // Reset all selections
      for (var i = 0; i < activeColor.length; i++) {
        activeColor[i]["selected"] = i == index;
      }

      // Filter properties based on date
      foundProperty = propertyList.where((list) {
        final dov = list['DateOfVisit'].toString();
        if (dov.isEmpty) return false;

        final todayAsString = DateFormat("dd-MMM-yyyy").format(DateTime.now());
        final todayConvert = DateFormat("dd-MMM-yyyy").parse(todayAsString);
        final listDate = DateFormat("dd-MMM-yyyy").parse(dov);
        final difference = todayConvert.difference(listDate).inDays;

        switch (title) {
          case "Today":
            return difference == 0;
          case "Spill":
            return difference > 0;
          case "Tomorrow":
            return difference < 0;
          default:
            return true;
        }
      }).toList();
    });
  }

  // Get property list from service
  Future<void> getPropertyList() async {
    propertyList = await service.read();
    propertyListLocal = await service.readByCompCount();
    debugPrint('---> ${propertyListLocal.length}');
    foundProperty = propertyList;
    setState(() {});
  }

  // Get user case summary from service
  Future<void> getUserCaseSummary() async {
    final service = UserCaseSummaryService();
    userSummary = await service.read();
    if (userSummary.isEmpty) {
      userSummary = [
        {
          "CaseForVisit": 0,
          "CaseSubmitted": 0,
          "CaseSubmittedToday": 0,
          "SpillCase": 0,
          "TodayCase": 0,
          "TomorrowCase": 0,
          "TotalCase": 0
        }
      ];
    }
    setState(() {});
  }

  // Handle search text changes
  void _searchListener() {
    _search(searchController.text);
  }

  // Search functionality with optimized filtering
  void _search(String value) {
    setState(() {
      if (value.isEmpty) {
        foundProperty = propertyList;
      } else {
        final input = value.toLowerCase();
        foundProperty = propertyList.where((element) {
          final an = element['ApplicationNumber'].toString().toLowerCase();
          final cn = element['CustomerName'].toString().toLowerCase();
          final ins = element['InstituteName'].toString().toLowerCase();
          final date = element['DateOfVisit'].toString().toLowerCase();
          final ln = element['LocationName'].toString().toLowerCase();
          return an.contains(input) ||
              cn.contains(input) ||
              ins.contains(input) ||
              date.contains(input) ||
              ln.contains(input);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

class TrackButton extends StatelessWidget {
  final String title;
  final VoidCallback? onclick;
  final Color color;

  const TrackButton({
    super.key,
    required this.title,
    required this.onclick,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: onclick,
        child: Text(
          title,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
