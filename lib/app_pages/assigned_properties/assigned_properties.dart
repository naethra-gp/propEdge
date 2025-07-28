import 'package:flutter/material.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import '../../app_services/local_db/local_services/property_list_services.dart';
import '../../app_utils/app/common_functions.dart';
import '../../app_utils/app/search_widget.dart';
import '../../app_utils/app_widget/no_data_found.dart';
import 'widget/property_expansion_widget.dart';

class AssignedProperties extends StatefulWidget {
  const AssignedProperties({super.key});

  @override
  State<AssignedProperties> createState() => _AssignedPropertiesState();
}

class _AssignedPropertiesState extends State<AssignedProperties> {
  final TextEditingController searchController = TextEditingController();
  PropertyListService service = PropertyListService();
  AlertService alertService = AlertService();
  List propertyList = [];
  List searchList = [];

  @override
  void initState() {
    debugPrint("---> Assigned Properties Page <---");
    CommonFunctions().loadData(context);
    CommonFunctions().checkPermission();
    getList();
    searchController.addListener(searchListener);
    super.initState();
  }

  Future<void> getList() async {
    propertyList = await service.read();
    searchList = propertyList;
    setState(() {});
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
              Expanded(
                child: searchList.isEmpty
                    ? NoDataFound()
                    : PropertyExpansionWidget(
                        searchList: searchList,
                        onUpload: (done) {
                          if (done) {
                            getList();
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchListener() {
    search(searchController.text.toString());
  }

  void search(String value) {
    if (value.isEmpty) {
      searchList = propertyList;
    } else {
      searchList = propertyList.where((e) {
        String an = e['ApplicationNumber'].toString().toLowerCase();
        String cn = e['CustomerName'].toString().toLowerCase();
        String ins = e['InstituteName'].toString().toLowerCase();
        String date = e['DateOfVisit'].toString().toLowerCase();
        String ln = e['LocationName'].toString().toLowerCase();
        String input = value.toLowerCase();
        return an.contains(input) ||
            cn.contains(input) ||
            ins.contains(input) ||
            date.contains(input) ||
            ln.contains(input);
      }).toList();
    }
    setState(() {});
  }

  @override
  void dispose() {
    searchController.removeListener(searchListener);
    searchController.dispose();
    super.dispose();
  }
}
