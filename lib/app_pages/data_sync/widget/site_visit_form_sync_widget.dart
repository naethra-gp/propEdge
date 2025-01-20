import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proequity/app_config/app_constants.dart';
import 'package:proequity/app_widgets/alert_widget.dart';

import '../../../app_services/index.dart';
import '../../../app_services/sqlite/database_service.dart';
import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_storage/secure_storage.dart';
import '../../../app_theme/custom_theme.dart';

class SiteVisitFormSyncWidget extends StatefulWidget {
  const SiteVisitFormSyncWidget({super.key});

  @override
  State<SiteVisitFormSyncWidget> createState() =>
      _SiteVisitFormSyncWidgetState();
}

class _SiteVisitFormSyncWidgetState extends State<SiteVisitFormSyncWidget> {
  bool hasInternet = false;
  StreamSubscription? subscription;
  String token = "";
  UserCaseSummaryServices caseSummaryServices = UserCaseSummaryServices();

  BoxStorage secureStorage = BoxStorage();
  AlertService alertService = AlertService();
  DashboardService dashService = DashboardService();
  PropertyListServices plService = PropertyListServices();
  LiveToLocalInsert ltlService = LiveToLocalInsert();
  DataSyncService dataSyncService = DataSyncService();
  PropertyLocationServices pLocService = PropertyLocationServices();
  @override
  void initState() {
    token = secureStorage.getLoginToken();
    checkInternet();
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    subscription?.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: CustomTheme.boxShadow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        leading: Container(
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
        title: Text(
          "Site Visit Sync",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: IconButton(
          icon: const InkWell(
            splashFactory: InkRipple.splashFactory,
            splashColor: Colors.blue,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.cloud_download_outlined,
                  size: 22,
                  color: Colors.redAccent,
                ),
                Text(
                  "Download",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            if (!hasInternet) {
              alertService.errorToast("Please check your internet!");
            } else {
              String msg = "Download data now?";
              alertService.confirmAlert(msg, downloadSync);
            }
          },
        ),
      ),
    );
  }

  downloadSync() async {
    Navigator.of(context).pop();
    await getUserSummary();
  }

  getUserSummary() async {
    var token = secureStorage.getLoginToken();
    var request = {
      "loginToken": {"Token": token}
    };
    alertService.showLoading("Getting User Case Summary...");
    dashService.getUserSummary(request).then((response) async {
      print("response $response");
      if (response != false && response['Summary'] != null) {
        await getPropertyListData();
        await caseSummaryServices.insert(response['Summary']);
      } else {
        alertService.errorToast(Constants.apiErrorMessage);
      }
    });
  }

  getPropertyListData() async {
    var token = secureStorage.getLoginToken();
    alertService.showLoading();
    var req = {
      "CustomerName": "",
      "loginToken": {"Token": token}
    };
    dashService.getPropertyList(req).then((res) async {
      if (res['PropertyList'].isNotEmpty) {
        dashService.getUnAssignProperty(req).then((res1) async {
          // alertService.hideLoading();
          List unAssign = res1['UnassignedProperty'];
          List property = res['PropertyList'];
          List filterProperty = property
              .where((e1) => !unAssign
                  .any((e2) => e1['PropId'].toString() == e2.toString()))
              .toList();
          final db = await DatabaseServices.instance.database;
          List propertyList = await plService.read();
          List fp = filterProperty;
          List processProperty = [];
          for (var pl in propertyList) {
            /// Status[0] = "Pending";
            if (pl['Status'].toString() == Constants.status[0].toString()) {
              List params = [pl['PropId'].toString()];
              print("---> Removed -- $params");
              await plService.deleteByPropId(Constants.propertyList, params);
              await plService.deleteByPropId(
                  Constants.customerBankDetails, params);
              await plService.deleteByPropId(
                  Constants.propertyLocation, params);
              await plService.deleteByPropId(Constants.locationDetails, params);
              await plService.deleteByPropId(
                  Constants.occupancyDetails, params);
              await plService.deleteByPropId(Constants.feedback, params);
              await plService.deleteByPropId(Constants.boundaryDetails, params);
              await plService.deleteByPropId(
                  Constants.measurementSheet, params);
              await plService.deleteByPropId(Constants.stageCalculator, params);
              await plService.deleteByPropId(Constants.criticalComment, params);
              await plService.deleteByPropId(Constants.locationMap, params);
              await plService.deleteByPropId(Constants.propertySketch, params);
              await plService.deleteByPropId(Constants.photograph, params);
            } else {
              processProperty.add(pl['PropId'].toString());
            }
          }
          // print("processProperty --> $processProperty");
          List fp2 = fp
              .where((e1) => !processProperty
                  .any((e2) => e1['PropId'].toString() == e2.toString()))
              .toList();
          await plService.insert(fp2);
          for (int i = 0; i < fp2.length; i++) {
            getPropertyDetailBasedOnId(fp2[i]['PropId'], () {
              if (i == fp2.length - 1) {
                alertService.successToast(Constants.apiSuccessMessage);
                alertService.hideLoading();
              }
            });
          }
        });
      } else {
        print("Else error");
        alertService.hideLoading();
        alertService.errorToast(Constants.noDataSyncErrorMessage);
      }
    });
  }

  getPropertyDetailBasedOnId(propId, Function() callback) async {
    var token = secureStorage.getLoginToken();
    var request = {
      "PropId": propId.toString(),
      "loginToken": {"Token": token}
    };
    print("Data - PropId : ${propId.toString()}");
    dataSyncService.getPropertyDetails(request).then((response) async {
      // print("response['PropertyDetails'] --- ${response['PropertyDetails']['PropertyLocationDetails']}");
      await ltlService.insertAll(propId, response['PropertyDetails']);
    });
    callback();
  }
}
