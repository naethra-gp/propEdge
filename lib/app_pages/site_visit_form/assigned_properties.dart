import 'package:flutter/material.dart';
import 'package:proequity/app_services/sqlite/sqlite_services.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:proequity/app_widgets/alert_widget.dart';

import '../../app_widgets/app_common/search_widget.dart';
import '../dashboard/widget/dash_expansion_list.dart';

class AssignedPropertiesPage extends StatefulWidget {
  const AssignedPropertiesPage({super.key});

  @override
  State<AssignedPropertiesPage> createState() => _AssignedPropertiesPageState();
}

class _AssignedPropertiesPageState extends State<AssignedPropertiesPage> {
  final TextEditingController searchController = TextEditingController();

  PropertyListServices propertyListServices = PropertyListServices();
  AlertService alertService = AlertService();

  List assignedPropertyList = [];
  List searchList = [];

  @override
  void initState() {
    debugPrint("---> Assigned Properties Page <---");
    getAssignedProperties();
    searchController.addListener(searchListener);
    super.initState();
  }

  Future<void> getAssignedProperties() async {
    assignedPropertyList = await propertyListServices.read();
    searchList = await propertyListServices.read();
    setState(() {});
  }

  @override
  void dispose() {
    searchController.removeListener(searchListener);
    searchController.dispose();
    super.dispose();
  }

  void searchListener() {
    search(searchController.text);
  }

  void search(String value) {
    if (value.isEmpty) {
      setState(() {
        searchList = assignedPropertyList;
      });
    } else {
      setState(() {
        searchList = assignedPropertyList.where((element) {
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 50,
                  child: SearchWidget(
                    controller: searchController,
                    hintText: "Search...",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (searchList.isEmpty)
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
                      ),
                      CustomTheme.defaultSize,
                    ],
                  ),
                ),
              CustomExpandedListView(
                searchList: searchList, function: (value) {
                  Navigator.pushReplacementNamed(context, "mainPage",
                      arguments: 0);
              },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomExpandedListView extends StatelessWidget {
  final List searchList;
  final Function function;

  const CustomExpandedListView({
    super.key,
    required this.searchList, required this.function,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          ...searchList.asMap().keys.toList().map(
                (item) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  child: DashExpansionTile(
                    item: searchList[item],
                    function: (value) {
                      function(value);
                    },

                    // leadingIconColor: AppColors.primaryColorOptions[item],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
