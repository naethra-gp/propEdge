import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:proequity/app_widgets/alert_widget.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import '../../app_services/sqlite/sqlite_services.dart';
import '../../app_widgets/app_common/search_widget.dart';

class ReimbursementPage extends StatefulWidget {
  const ReimbursementPage({super.key});

  @override
  State<ReimbursementPage> createState() => _ReimbursementPageState();
}

class _ReimbursementPageState extends State<ReimbursementPage> {
  List reimbursement = [];
  List searchHistory = [];
  final TextEditingController searchController = TextEditingController();
  ReimbursementServices reimbursementServices = ReimbursementServices();
  bool hasInternet = false;
  StreamSubscription? subscription;

  @override
  void initState() {
    debugPrint("----> Reimbursement Page <----");
    checkInternet();
    searchController.addListener(searchListener);
    getReimbursement();
    super.initState();
  }

  checkInternet() async {
    List result0 = await (Connectivity().checkConnectivity());
    if (result0.contains(ConnectivityResult.none)) {
      hasInternet = false;
    } else {
      hasInternet = true;
    }
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        hasInternet = false;
      } else {
        hasInternet = true;
      }
      setState(() {});
    });
  }
  @override
  void dispose() {
    searchController.removeListener(searchListener);
    searchController.dispose();
    subscription?.cancel();
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
          final an = element['NatureOfExpense'].toString().toLowerCase();
          final cn = element['TotalAmount'].toString().toLowerCase();
          final input = value.toLowerCase();
          return an.contains(input) || cn.contains(input);
        }).toList();
      });
    }
  }

  Future<void> getReimbursement() async {
    reimbursement = await reimbursementServices.read();
    searchHistory = await reimbursementServices.read();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                'onlineReimbursement',
                              );
                            },
                      child: const Text(
                        "View Reimbursement",
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
                          'reimbursementForm',
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
                  ]),
              SizedBox(
                height: 50,
                child: SearchWidget(
                  controller: searchController,
                  hintText: "Search...",
                ),
              ),
              CustomTheme.defaultHeight10,
              if (searchHistory.isEmpty)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/no_data_found.jpg",
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
                    final item = searchHistory[index];
                    return listWidget(item);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      child: Container(
        decoration: CustomTheme.decoration,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
            child: const Icon(
              LineAwesome.rupee_sign_solid,
              color: Colors.white,
            ),
          ),
          title: Text(
            "${list['NatureOfExpense']} - Rs. ${list['TotalAmount']}",
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            list['BillName'],
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'viewReimbursement',
                    arguments: list['primaryId'].toString(),
                  );
                },
                icon: const Icon(
                  Icons.remove_red_eye,
                  size: 25,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    'reimbursementForm',
                    arguments: list,
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  size: 25,
                ),
              ),
              IconButton(
                onPressed: () {
                  AlertService().confirm(
                      context,
                      "Remove this ${list['NatureOfExpense'].toString().trim()} bill?",
                      null,
                      null, () async {
                    int result = await reimbursementServices
                        .removeBill(["N", "N", list['primaryId'].toString()]);
                    if (result == 1) {
                      if (!mounted) return;
                      Navigator.of(context).pop();
                      getReimbursement();
                    }
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
