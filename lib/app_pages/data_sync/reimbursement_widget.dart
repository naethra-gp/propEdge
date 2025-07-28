import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app/common_functions.dart';

import '../../app_config/app_constants.dart';
import '../../app_services/local_db/local_services/local_reimbursement_services.dart';
import '../../app_services/reimbursement_service.dart';
import '../../app_storage/secure_storage.dart';
import 'widget/ds_list_widget.dart';

class ReimbursementWidget extends StatefulWidget {
  final bool hasInternet;
  const ReimbursementWidget({super.key, required this.hasInternet});

  @override
  State<ReimbursementWidget> createState() => _ReimbursementWidgetState();
}

class _ReimbursementWidgetState extends State<ReimbursementWidget> {
  AlertService alertService = AlertService();
  BoxStorage secureStorage = BoxStorage();
  LocalReimbursementServices localService = LocalReimbursementServices();
  ReimbursementService liveService = ReimbursementService();

  @override
  Widget build(BuildContext context) {
    return DsListWidget(
      upload: true,
      title: 'Reimbursement Sync',
      leadingIcon: Icons.currency_rupee_outlined,
      onPressed: () async {
        Fluttertoast.cancel();
        if (!widget.hasInternet) {
          alertService.errorToast(Constants.checkInternetMsg);
        } else {
          List list = await localService.readBasedOnSync();
          if (list.isEmpty) {
            alertService.toast(
                "No data available to sync. All data is already synced.");
          } else {
            String msg = "Do you want to upload ${list.length} record?";
            if (!context.mounted) return;
            bool? status = await alertService.confirmAlert(context, null, msg);
            if (status!) {
              uploadSync(list);
            }
          }
        }
      },
    );
  }

  uploadSync(List list) async {
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
        bool show = list.length - 1 == i;
        await saveReimbursement(list[i], baseString, show);
      }
    }
  }

  getBase64String(list) {
    final bytes = File(list['BillPath']).readAsBytesSync();
    return base64Encode(bytes);
  }

  saveReimbursement(list, baseString, showMessage) {
    try {
      alertService.showLoading();
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
          if (showMessage) {
            alertService.successToast(Constants.apiSuccessMessage);
          }
        } else {
          if (showMessage) {
            alertService.errorToast(Constants.apiErrorMessage);
          }
        }
      });
    } catch (e, stackTrace) {
      CommonFunctions()
          .appLog(e, stackTrace, fatal: true, reason: "SAVE REIMBURSEMENT");
    }
  }

  deleteLocalSql(String id) async {
    await localService.deleteById(id);
    // lastUpdate = DateFormat('dd-MMM-yyyy hh:mm:ss a').format(DateTime.now());
    // secureStorage.save("reimbursementUpdate", lastUpdate);
    // setState(() {});
  }
}
