import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:proequity/app_pages/cases/widget/case_expansion_widget.dart';
import 'package:proequity/app_widgets/alert_widget.dart';

import '../../app_services/index.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_theme/theme_files/app_color.dart';
import '../../app_widgets/app_common/search_widget.dart';

class CasePage extends StatefulWidget {
  const CasePage({super.key});

  @override
  State<CasePage> createState() => _CasePageState();
}

class _CasePageState extends State<CasePage> {
  CaseService caseService = CaseService();
  AlertService alertService = AlertService();
  List caseLists = [];
  List searchHistory = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    debugPrint("----> Case Page <----");
    getSubmittedCases(context);
    searchController.addListener(searchListener);
    super.initState();
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
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
        searchHistory = caseLists;
      });
    } else {
      setState(() {
        searchHistory = caseLists.where((element) {
          final an = element['ApplicationNumber'].toString().toLowerCase();
          final cn = element['ContactPersonNumber'].toString().toLowerCase();
          final iName = element['InstituteName'].toString().toLowerCase();
          final input = value.toLowerCase();
          return an.contains(input) ||
              cn.contains(input) ||
              iName.contains(input);
        }).toList();
      });
    }
  }

  getSubmittedCases(BuildContext context) async {
    alertService.showLoading("Loading Submitted Cases...");
    var hasInternet = await InternetConnectivity().hasInternetConnection;
    if (hasInternet) {
      BoxStorage secureStorage = BoxStorage();
      var request = {
        "CustomerName": "",
        "loginToken": {
          "Token": secureStorage.getLoginToken(),
        }
      };
      if (!mounted) return;
      caseService.getSubmittedCases(context, request).then((response) async {
        caseLists = response['SubmittedCases'];
        searchHistory = response['SubmittedCases'];
        setState(() {});
        alertService.hideLoading();
      });
    } else {
      alertService.hideLoading();
      AlertService().errorToast("Please check your internet connection!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: SearchWidget(
                  controller: searchController,
                  hintText: "Search...",
                ),
              ),
              const SizedBox(height: 10),
              if (searchHistory.isEmpty)
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
              Expanded(
                child: ListView.builder(
                  itemCount: searchHistory.length,
                  itemBuilder: (context, index) {
                    return CaseExpansionWidget(
                      item: searchHistory[index],
                      leadingIconColor: AppColors.primaryColorOptions[0],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listWidget(list) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFD1DCFF),
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Icon(
                        LineAwesome.building,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${list['ApplicationNumber']} - ${list['CustomerName']}",
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.poppins().copyWith(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${list['DateOfVisit']} (${list['LocationName']})",
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${list['InstituteName']}",
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
