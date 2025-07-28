import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:prop_edge/app_utils/app_widget/no_data_found.dart';
import 'dart:io';
import '../../app_config/app_constants.dart';
import '../../app_services/local_db/local_services/property_list_services.dart';
import '../../app_services/local_db/local_services/user_case_summary_service.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_theme/app_color.dart';
import '../../app_theme/custom_theme.dart';
import '../../app_utils/alert_service.dart';
import '../../app_utils/app/common_functions.dart';
import '../../app_utils/app/location_service.dart';
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
  bool isTripStarted = false;
  bool isTripEnded = false;
  List latLongList = [];
  StreamSubscription<LocationData>? _locationSubscription;
  bool _isLocationEnabled = true;
  Timer? _locationCheckTimer;

  @override
  void initState() {
    super.initState();
    debugPrint("----> Dashboard Page <----");
    _checkLocationAndInitialize();
    searchController.addListener(_searchListener);
  }

  void _checkLocationAndInitialize() async {
    await _checkLocationService();
    await _initializeData();
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled = await Location().serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Location().requestService();
      if (!serviceEnabled) {
        alertService.errorToast(
            'Location services are disabled. Please enable GPS to continue tracking.');
        return;
      }
    }
    setState(() {
      _isLocationEnabled = true;
    });
  }

  // Initialize data on page load
  Future<void> _initializeData() async {
    await Future.wait([
      getPropertyList(),
      getUserCaseSummary(),
    ]);
  }

  void loadTripState() async {
    String tripStarted = await boxStorage.get('trip_started') ?? 'false';
    String tripEnded = await boxStorage.get('trip_ended') ?? 'false';

    setState(() {
      isTripStarted = tripStarted == 'true';
      isTripEnded = tripEnded == 'true';
    });
  }

  void saveTripState() async {
    await boxStorage.save('trip_started', isTripStarted.toString());
    await boxStorage.save('trip_ended', isTripEnded.toString());
  }

  Future<bool> getTripStatus() async {
    BoxStorage boxStorage = BoxStorage();
    String endTripStatus = await boxStorage.get('end_trip_date');
    if (endTripStatus.isEmpty) {
      return true;
    }
    return false;
  }

  void _startLocationMonitoring() {
    // Check location every 5 seconds
    _locationCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkLocationAvailability();
    });
  }

  void _stopLocationMonitoring() {
    _locationCheckTimer?.cancel();
    _locationCheckTimer = null;
  }

  Future<void> _checkLocationAvailability() async {
    bool serviceEnabled = await Location().serviceEnabled();
    PermissionStatus permission = await Location().hasPermission();

    if (!serviceEnabled ||
        permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      if (!mounted) return;
      // alertService.errorToast('Location services are required to use this app');
      bool? alert = await alertService.alert(context, null,
          'Location services are required to use this app. The app will now exit.');
      if (alert!) {
        // exit(0);
        SystemNavigator.pop();
      }
      // await Future.delayed(const Duration(seconds: 2));
      // exit(0);
    }
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
                        onclick: isTripStarted
                            ? null
                            : () async {
                                bool? isOptimize =
                                    await DisableBatteryOptimization
                                        .isBatteryOptimizationDisabled;

                                if (isOptimize == false) {
                                  if (!context.mounted) return;
                                  bool? confirm =
                                      await alertService.confirmAlert(
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

                                // Check location service before starting trip
                                await _checkLocationService();
                                if (!_isLocationEnabled) {
                                  return;
                                }

                                if (!mounted) return;
                                bool? isConfirm =
                                    await alertService.confirmAlert(
                                        context,
                                        'Start Trip',
                                        'Are you sure want to Start Trip?');
                                if (isConfirm!) {
                                  alertService.showLoading();
                                  setState(() {
                                    isTripStarted = true;
                                    isTripEnded = false;
                                    latLongList
                                        .clear(); // Clear previous trip data
                                  });
                                  _startLocationMonitoring(); // Start monitoring when trip starts
                                  saveTripState();
                                  alertService.hideLoading();
                                }
                              },
                        color: Colors.green),
                    if (isTripStarted)
                      TrackButton(
                        title: 'End Trip',
                        onclick: () async {
                          bool? isConfirm = await alertService.confirmAlert(
                              context,
                              'End Trip',
                              'Are you sure want to End Trip?');
                          if (isConfirm!) {
                            alertService.showLoading();
                            setState(() {
                              isTripStarted = false;
                              isTripEnded = true;
                            });
                            _stopLocationMonitoring(); // Stop monitoring when trip ends
                            saveTripState();
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
          count: userSummary[0]['CaseSubmitted'].toString(),
          color: Constants.dashTotalColor,
        ),
        FirstCardWidget(
          title: 'Submitted Case',
          count: userSummary[0]['CaseSubmittedToday'].toString(),
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
    _locationSubscription?.cancel();
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
