import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import '../../../app_config/app_constants.dart';
import '../../../app_services/reimbursement_service.dart';
import '../../../app_services/sqlite/reimbursement_services.dart';
import '../../../app_storage/secure_storage.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_widgets/alert_widget.dart';
import 'sync_button_widget.dart';

class ReimbursementSyncWidget extends StatefulWidget {
  const ReimbursementSyncWidget({super.key});

  @override
  State<ReimbursementSyncWidget> createState() =>
      _ReimbursementSyncWidgetState();
}

class _ReimbursementSyncWidgetState extends State<ReimbursementSyncWidget> {
  AlertService alertService = AlertService();
  BoxStorage secureStorage = BoxStorage();
  ReimbursementService liveService = ReimbursementService();
  ReimbursementServices localService = ReimbursementServices();
  List reimbursement = [];
  String lastUpdate = "";
  bool hasInternet = false;
  StreamSubscription? subscription;

  @override
  void initState() {
    lastUpdate = secureStorage.get("reimbursementUpdate") ?? "";
    checkInternet();
    super.initState();
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    subscription?.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Container(
      decoration: CustomTheme.decoration,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          "Reimbursement Sync",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: lastUpdate.toString().isNotEmpty
            ? Text(
                "Last Sync: $lastUpdate",
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
              )
            : const Text(""),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SyncButtonWidget(
              icons: Icons.cloud_upload_outlined,
              label: "Upload",
              onTap: () async {
                if (!hasInternet) {
                  alertService.errorToast("Please check your internet!");
                  // Navigator.of(context).pop();
                } else {
                  List list = await localService.readBasedOnSync();
                  if (list.isEmpty) {
                    alertService.errorToast(Constants.noDataSyncErrorMessage);
                  } else {
                    String msg =
                        "Do you want to upload ${list.length} records.";
                    alertService.confirm(context, msg, "Ok", "Cancel",
                        () async {
                      Navigator.of(context).pop();
                      uploadSync(list);
                    });
                  }
                }
              },
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  uploadSync(List list) async {
    if (list.isEmpty) {
      alertService.hideLoading();
      alertService.errorToast("No data to Sync!");
    } else {
      for (int i = 0; i < list.length; i++) {
        String path = list[i]['BillPath'].toString();
        String valid = path == "" ? "" : path;
        String baseString = "";
        if (!Uri.parse(path).isAbsolute && valid != "") {
          baseString = await getBase64String(list[i]);
          setState(() {});
        }
        String id = list[i]['Id'].toString();
        String isActive = list[i]['IsActive'].toString();
        if (id == "0" && isActive == "N") {
          deleteLocalSql(list[i]['primaryId'].toString());
        } else {
          await saveReimbursement(list[i], baseString);
        }
      }
    }
  }

  getBase64String(list) {
    final bytes = File(list['BillPath']).readAsBytesSync();
    return base64Encode(bytes);
  }

  saveReimbursement(list, baseString) {
    alertService.showLoading(Constants.loadingMessage);
    var token = secureStorage.getLoginToken();
    Map<String, dynamic> request = {
      "reimbursements": [
        {
          "primaryId": list['primaryId'].toString(),
          "Id": list['Id'],
          "ExpenseDate": list['ExpenseDate'],
          "NatureOfExpense": list['NatureOfExpense'],
          "NoOfDays": list['NoOfDays'],
          "TravelAllowance": list['TravelAllowance'],
          "TotalAmount": list['TotalAmount'],
          "ExpenseComment": list['ExpenseComment'],
          "BillPath": list['BillPath'],
          "BillName": list['BillName'].toString(),
          "BillBase64String": baseString,
          "IsActive": list['IsActive'],
          "SyncStatus": "Y"
        }
      ],
      "loginToken": {"Token": token.toString()}
    };
    liveService.saveReimbursement(request).then((result) async {
      alertService.hideLoading();
      if (result['Status']) {
        deleteLocalSql(list['primaryId'].toString());
        alertService.successToast(Constants.apiSuccessMessage);
      } else {
        alertService.errorToast(Constants.apiErrorMessage);
      }
    });
  }

  deleteLocalSql(String id) async {
    await localService.deleteById(id);
    lastUpdate = DateFormat('dd-MMM-yyyy hh:mm:ss a').format(DateTime.now());
    secureStorage.save("reimbursementUpdate", lastUpdate);
    setState(() {});
  }
}
