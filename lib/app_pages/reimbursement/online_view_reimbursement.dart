import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../../app_config/app_constants.dart';
import '../../app_services/index.dart';
import '../../app_services/sqlite/sqlite_services.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_theme/custom_theme.dart';
import '../../app_widgets/alert_widget.dart';
import '../../app_widgets/app_common/app_bar.dart';
import '../../app_widgets/app_common/search_widget.dart';

class OnlineReimbursementPage extends StatefulWidget {
  const OnlineReimbursementPage({super.key});

  @override
  State<OnlineReimbursementPage> createState() =>
      _OnlineReimbursementPageState();
}

class _OnlineReimbursementPageState extends State<OnlineReimbursementPage> {
  List reimbursement = [];
  List searchHistory = [];
  final TextEditingController searchController = TextEditingController();
  ReimbursementServices reimbursementServices = ReimbursementServices();
  ReimbursementService reService = ReimbursementService();
  BoxStorage secureStorage = BoxStorage();

  bool hasInternet = false;
  StreamSubscription? subscription;
  AlertService alertService = AlertService();

  @override
  void initState() {
    getReimbursement();
    // checkInternet();
    debugPrint("----> Reimbursement Online Page <----");
    searchController.addListener(searchListener);

    super.initState();
  }

  checkInternet() async {
    SimpleConnectionChecker simpleConnectionChecker = SimpleConnectionChecker()
      ..setLookUpAddress('pub.dev');
    subscription =
        simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        hasInternet = connected;
      });
    });
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
          final an = element['NatureOfExpense'].toString().toLowerCase();
          final cn = element['TotalAmount'].toString().toLowerCase();
          final input = value.toLowerCase();
          return an.contains(input) || cn.contains(input);
        }).toList();
      });
    }
  }

  Future<void> getReimbursement() async {
    alertService.showLoading(Constants.loadingMessage);
    var token = secureStorage.getLoginToken();
    var request = {
      "loginToken": {"Token": token}
    };
    reService.getReimbursement(context, request).then((result) async {
      alertService.hideLoading();
      if (result != false) {
        reimbursement = result['Reimbursement'];
        searchHistory = result['Reimbursement'];
        print("reimbursement -> $reimbursement");
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "View Reimbursement",
        action: false,
      ),
      body: Material(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: <Widget>[
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       TextButton(
                //         onPressed: !hasInternet ? null : () {
                //           Navigator.pushNamed(
                //             context,
                //             'reimbursementForm',
                //             arguments: {},
                //           );
                //         },
                //         child: const Text(
                //           "View Reimbursement",
                //           style: TextStyle(
                //             decoration: TextDecoration.underline,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //       const Spacer(),
                //       TextButton(
                //         onPressed: () {
                //           Navigator.pushNamed(
                //             context,
                //             'reimbursementForm',
                //             arguments: {},
                //           );
                //         },
                //         child: const Text(
                //           "Add New",
                //           style: TextStyle(
                //             decoration: TextDecoration.underline,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ]),
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
            ],
          ),
        ),
      ),
    );
  }
}
