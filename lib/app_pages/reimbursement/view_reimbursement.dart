import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:prop_edge/app_services/local_db/local_services/dropdown_services.dart';
import 'package:prop_edge/app_theme/app_color.dart';
import 'package:prop_edge/app_utils/alert_service.dart';

import '../../app_services/reimbursement_service.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_theme/custom_theme.dart';
import '../../app_utils/alert_service2.dart';
import '../../app_utils/app/app_bar.dart';
import '../../app_utils/app/search_widget.dart';
import '../../app_utils/app_widget/no_data_found.dart';

class ViewReimbursement extends StatefulWidget {
  const ViewReimbursement({super.key});

  @override
  State<ViewReimbursement> createState() => _ViewReimbursementState();
}

class _ViewReimbursementState extends State<ViewReimbursement> {
  List reimbursement = [];
  List searchHistory = [];
  final TextEditingController searchController = TextEditingController();
  // ReimbursementServices reimbursementServices = ReimbursementServices();
  ReimbursementService reService = ReimbursementService();
  BoxStorage secureStorage = BoxStorage();
  List expDD = [];
  DropdownServices dropdownServices = DropdownServices();

  bool hasInternet = false;
  StreamSubscription? subscription;
  AlertService alertService = AlertService();

  @override
  void initState() {
    getDropdown();
    getReimbursement();
    debugPrint("----> Reimbursement Online Page <----");
    searchController.addListener(searchListener);
    super.initState();
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

  Future<void> getReimbursement() async {
    alertService.showLoading();
    var token = secureStorage.getLoginToken();
    var request = {
      "loginToken": {"Token": token}
    };
    reService.getReimbursement(context, request).then((result) async {
      alertService.hideLoading();
      if (result != false) {
        reimbursement = result['Reimbursement'];
        searchHistory = result['Reimbursement'];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarWidget(
          title: "Reimbursement",
          action: false,
        ),
        body: Material(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: <Widget>[
                  CustomTheme.defaultHeight10,
                  SizedBox(
                    height: 50,
                    child: SearchWidget(
                      controller: searchController,
                      hintText: "Search...",
                    ),
                  ),
                  CustomTheme.defaultHeight10,
                  Expanded(
                    child: searchHistory.isEmpty
                        ? NoDataFound()
                        : ListView.builder(
                            itemCount: searchHistory.length,
                            itemBuilder: (context, index) {
                              final item = searchHistory[index];
                              return listWidget(item);
                            },
                          ),
                  ),
                  CustomTheme.defaultHeight10,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listWidget(list) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          // border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: Text(
            "${getExpenseName(list['NatureOfExpense'].toString()).toUpperCase()} - Rs.${list['TotalAmount']}",
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
          subtitle: Text(
            list['BillName'].toString(),
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          trailing: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.primary),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'view_reimbursement_details',
                  arguments: [list]);
            },
            icon: Icon(LineAwesome.eye, color: Colors.white),
          ),
        ),
      ),
    );
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
}
