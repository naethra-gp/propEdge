import 'package:advance_expansion_tile/advance_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:proequity/app_config/app_constants.dart';
import 'package:proequity/app_config/index.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import '../../app_services/sqlite/sqlite_services.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_theme/theme_files/app_color.dart';
import '../../app_widgets/alert_widget.dart';

import '../../app_widgets/app_common/search_widget.dart';
import '../site_visit_form/assigned_properties.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List userSummary = [];
  List propertyList = [];
  List foundProperty = [];
  BoxStorage secureStorage = BoxStorage();
  AlertService alertService = AlertService();
  PropertyListServices propertyListServices = PropertyListServices();
  UserCaseSummaryServices userCaseSummaryServices = UserCaseSummaryServices();
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<AdvanceExpansionTileState> globalKey = GlobalKey();
  int? expandedItemIndex;

  @override
  void dispose() {
    searchController.removeListener(searchListener);
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    debugPrint("----> Dashboard Page <----");
    getPropertyList();
    getUserCaseSummary();
    searchController.addListener(searchListener);
    super.initState();
  }

  Future<void> getPropertyList() async {
    propertyList = await propertyListServices.read();
    foundProperty = await propertyListServices.read();
    setState(() {});
  }

  Future<void> getUserCaseSummary() async {
    userSummary = await userCaseSummaryServices.read();
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

  void searchListener() {
    search(searchController.text);
  }

  void search(String value) {
    if (value.isEmpty) {
      setState(() {
        foundProperty = propertyList;
      });
    } else {
      setState(() {
        foundProperty = propertyList.where((element) {
          final an = element['ApplicationNumber'].toString().toLowerCase();
          final cn = element['CustomerName'].toString().toLowerCase();
          final ins = element['InstituteName'].toString().toLowerCase();
          final date = element['DateOfVisit'].toString().toLowerCase();
          final ln = element['LocationName'].toString().toLowerCase();
          final input = value.toLowerCase();
          return an.contains(input) ||
              cn.contains(input) ||
              ins.contains(input) ||
              date.contains(input) ||
              ln.contains(input);
        }).toList();
      });
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
              /// --- USER CASE SUMMARY
              CustomTheme.defaultSize,
              if (userSummary.isNotEmpty) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    dashFirstCard(
                      'Total Cases',
                      userSummary[0]['TotalCase'].toString(),
                      Constants.dashCaseColor,
                    ),
                    dashFirstCard(
                      'Total Visit',
                      userSummary[0]['CaseSubmitted'].toString(),
                      Constants.dashTotalColor,
                    ),
                    dashFirstCard(
                      'Submitted Case',
                      userSummary[0]['CaseSubmittedToday'].toString(),
                      Constants.dashSubmitColor,
                    ),
                  ],
                ),
                CustomTheme.defaultSize,
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: AppColors.primary,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "ALLOCATION",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const Divider(
                                color: Colors.white,
                                thickness: 0.5,
                                height: 0,
                                indent: 10,
                                endIndent: 10),
                            if (userSummary.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    homeCard('Spill',
                                        userSummary[0]['SpillCase'].toString()),
                                    homeCard('Today',
                                        userSummary[0]['TodayCase'].toString()),
                                    homeCard(
                                        'Tomorrow',
                                        userSummary[0]['TomorrowCase']
                                            .toString()),
                                    homeCard('Total',
                                        userSummary[0]['CaseForVisit'].toString()),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              CustomTheme.defaultSize,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: SizedBox(
                  height: 45,
                  child: SearchWidget(
                    controller: searchController,
                    hintText: "Search...",
                  ),
                ),
              ),
              CustomTheme.defaultSize,
              if (foundProperty.isEmpty) ...[
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/no_data_found.png",
                        height: 200,
                        width: 200,
                      ),
                      const Text(
                        'No data found!',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
              CustomExpandedListView(
                searchList: foundProperty,
                function: (value) {
                  print("Value -> $value");
                  if (value) {
                    Navigator.pushReplacementNamed(context, "mainPage",
                        arguments: 2);
                  }
                },
              ),
              CustomTheme.defaultSize,
            ],
          ),
        ),
      ),
    );
  }

  /// USER CASE SUMMARY CARD
  Widget dashFirstCard(title, count, color) {
    return Expanded(
      child: Card(
        elevation: 5,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(count,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget homeCard(title, count) {
    return Expanded(
      child: Card(
        elevation: 10,
        color: const Color(0xff587CEC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 9,
                                    color: Colors.white,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Text(count,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 16, color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
