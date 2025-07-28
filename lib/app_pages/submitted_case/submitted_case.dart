import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app/common_functions.dart';

import '../../app_services/submitted_case_services.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_utils/app/search_widget.dart';
import '../../app_utils/app_widget/no_data_found.dart';
import 'widgets/case_expansion_widget.dart';

class SubmittedCase extends StatefulWidget {
  const SubmittedCase({super.key});

  @override
  State<SubmittedCase> createState() => _SubmittedCaseState();
}

class _SubmittedCaseState extends State<SubmittedCase> {
  AlertService alertService = AlertService();
  SubmittedCaseServices services = SubmittedCaseServices();
  BoxStorage secureStorage = BoxStorage();
  List caseLists = [];
  List searchHistory = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    debugPrint("----> Submitted Case Page <----");
    super.initState();
    CommonFunctions().loadData(context);
    CommonFunctions().checkPermission();
    getSubmittedCases(context);
    searchController.addListener(searchListener);
  }

  @override
  Widget build(BuildContext context) {
    List sh = searchHistory;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            // SizedBox(
            //   height: 30,
            //   width: double.infinity,
            //   child: ElevatedButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => const ViewMapPage(),
            //           ),
            //         );
            //       },
            //       style: ElevatedButton.styleFrom(
            //           elevation: 3, backgroundColor: Colors.teal[300]),
            //       child: Text(
            //         'View tracking List',
            //         style: TextStyle(fontSize: 14),
            //       )),
            // ),
            // const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: SearchWidget(
                controller: searchController,
                hintText: "Search...",
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: sh.isEmpty
                  ? NoDataFound()
                  : CaseExpansionWidget(searchList: sh),
            ),
          ],
        ),
      ),
    );
  }

  void searchListener() {
    search(searchController.text);
  }

  void search(String value) {
    if (value.isEmpty) {
      setState(() {
        searchHistory = caseLists;
      });
    } else {
      setState(() {
        searchHistory = caseLists.where((element) {
          String an = element['ApplicationNumber'].toString().toLowerCase();
          String cn = element['ContactPersonNumber'].toString().toLowerCase();
          String iName = element['InstituteName'].toString().toLowerCase();
          String input = value.toLowerCase();
          return an.contains(input) ||
              cn.contains(input) ||
              iName.contains(input);
        }).toList();
      });
    }
  }

  getSubmittedCases(BuildContext context) async {
    List result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      alertService.hideLoading();
      alertService.errorToast("Please check your internet connection!");
    } else {
      alertService.showLoading();
      var request = {
        "CustomerName": "",
        "loginToken": {
          "Token": secureStorage.getLoginToken(),
        }
      };
      if (!context.mounted) return;
      services.getSubmittedCases(context, request).then((response) async {
        caseLists = response['SubmittedCases'];
        searchHistory = response['SubmittedCases'];
        alertService.hideLoading();
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    searchController.removeListener(searchListener);
    searchController.dispose();
    super.dispose();
  }
}
