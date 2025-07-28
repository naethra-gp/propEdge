import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:prop_edge/app_services/local_db/local_services/dropdown_services.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app/common_functions.dart';
import 'package:prop_edge/app_utils/app_widget/no_data_found.dart';

import '../../app_services/local_db/local_services/local_reimbursement_services.dart';
import '../../app_services/reimbursement_service.dart';
import '../../app_theme/app_color.dart';
import '../../app_theme/custom_theme.dart';
import '../../app_utils/app/search_widget.dart';

class ReimbursementPage extends StatefulWidget {
  const ReimbursementPage({super.key});

  @override
  State<ReimbursementPage> createState() => _ReimbursementPageState();
}

class _ReimbursementPageState extends State<ReimbursementPage> {
  List reimbursement = [];
  List searchHistory = [];
  final TextEditingController searchController = TextEditingController();
  ReimbursementService reimbursementServices = ReimbursementService();
  LocalReimbursementServices localService = LocalReimbursementServices();
  AlertService alertService = AlertService();
  bool hasInternet = false;
  StreamSubscription? subscription;
  List expDD = [];
  DropdownServices dropdownServices = DropdownServices();

  @override
  void initState() {
    debugPrint("----> Reimbursement Page <----");
    CommonFunctions().loadData(context);
    checkInternet();
    CommonFunctions().checkPermission();
    searchController.addListener(searchListener);
    getReimbursement();
    getDropdown();
    super.initState();
  }

  getReimbursement() async {
    reimbursement = await localService.read();
    searchHistory = reimbursement;
    setState(() {});
  }

  String getExpenseName(String natureOfExpenseId) {
    try {
      var matchedExpense = expDD.firstWhere(
        (expense) => expense['Id'].toString() == natureOfExpenseId,
      );
      return matchedExpense['Name'];
    } catch (e) {
      return '';
    }
  }

  getDropdown() async {
    expDD = await dropdownServices.readByType('NatureOfExpense');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List sh = searchHistory;
    return Material(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: !hasInternet
                        ? null
                        : () {
                            Navigator.pushNamed(
                              context,
                              'view_reimbursement',
                            );
                          },
                    child: const Text(
                      "Live Reimbursement",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        'addReimbursement',
                        arguments: {},
                      );
                    },
                    child: const Text(
                      "Add New",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
                child: SearchWidget(
                  controller: searchController,
                  hintText: "Search...",
                ),
              ),
              CustomTheme.defaultHeight10,
              Expanded(child: sh.isEmpty ? NoDataFound() : listWidget()),
              CustomTheme.defaultHeight10,
            ],
          ),
        ),
      ),
    );
  }

  Widget listWidget() {
    return ListView.builder(
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        final list = searchHistory[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              title: Text(
                "${getExpenseName(list['NatureOfExpense'].toString())} - Rs. ${list['TotalAmount']}",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
              ),
              subtitle: Text(
                list['BillName'],
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem<String>(
                    onTap: () {
                      Navigator.pushNamed(context, 'local_view_details',
                          arguments: [list]);
                    },
                    child: Text(
                      'View Record',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    onTap: () {
                      Navigator.pushNamed(context, 'addReimbursement',
                          arguments: list);
                    },
                    child: Text(
                      'Edit Record',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      bool? confirm = await alertService.confirmAlert(
                        context,
                        'Confirm',
                        "Would you like to delete this bill?",
                      );
                      if (confirm!) {
                        // int result = await localService.removeBill([
                        //   "N",
                        //   "N",
                        //   list['primaryId'].toString(),
                        // ]);
                        int result = await localService
                            .deleteByIdLocal(list['primaryId'].toString());
                        if (result == 1) {
                          if (!mounted) return;
                          getReimbursement();
                        }
                      }
                    },
                    child: Text(
                      'Delete Record',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                icon: Icon(Icons.more_vert),
                offset: Offset(0, 40),
              ),
            ),
          ),
        );
      },
    );
  }

  checkInternet() async {
    List result = await (Connectivity().checkConnectivity());
    if (result.contains(ConnectivityResult.none)) {
      hasInternet = false;
    } else {
      hasInternet = true;
    }
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.none)) {
        hasInternet = false;
      } else {
        hasInternet = true;
      }
      setState(() {});
    });
  }

  void searchListener() {
    search(searchController.text);
  }

  void search(String value) {
    if (value.isEmpty) {
      setState(() {
        searchHistory = reimbursement;
      });
    } else {
      setState(() {
        searchHistory = reimbursement.where((element) {
          final an = getExpenseName(element['NatureOfExpense'].toString())
              .toLowerCase();
          final cn = element['TotalAmount'].toString().toLowerCase();
          final input = value.toLowerCase();
          return an.contains(input) || cn.contains(input);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    searchController.removeListener(searchListener);
    searchController.dispose();
    subscription?.cancel();
    super.dispose();
  }

  Widget menuItem(IconData icon, String text, ctx) {
    // var theme = Theme.of(ctx);
    return ListTile(
      // leading: Icon(
      //   icon
      // ),
      title: Text(
        text.toString(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
