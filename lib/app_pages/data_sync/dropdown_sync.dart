import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prop_edge/app_utils/alert_service.dart';

import '../../app_config/app_constants.dart';
import '../../app_services/data_sync_services.dart';
import '../../app_services/local_db/db/database_services.dart';
import '../../app_services/local_db/local_services/dropdown_services.dart';
import '../../app_storage/secure_storage.dart';
import 'widget/ds_list_widget.dart';

class DropdownSync extends StatefulWidget {
  final bool hasInternet;
  const DropdownSync({super.key, required this.hasInternet});

  @override
  State<DropdownSync> createState() => _DropdownSyncState();
}

class _DropdownSyncState extends State<DropdownSync> {
  AlertService alertService = AlertService();
  BoxStorage secureStorage = BoxStorage();
  DataSyncService dataSyncService = DataSyncService();
  DropdownServices dropdownServices = DropdownServices();

  // List dropdownData = [];
  String lastUpdate = "";
  StreamSubscription? subscription;

  @override
  void initState() {
    lastUpdate = secureStorage.get("lastUpdate") ?? "-";
    super.initState();
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DsListWidget(
      upload: false,
      title: 'Dropdown Sync',
      leadingIcon: Icons.format_list_bulleted_outlined,
      subTitle: "Last Sync: $lastUpdate",
      onPressed: () async {
        Fluttertoast.cancel();
        if (!widget.hasInternet) {
          alertService.errorToast(Constants.checkInternetMsg);
          return;
        }
        bool? confirm = await alertService.confirmAlert(
            context, 'Confirm', 'Download Now?');
        if (confirm!) {
          dataSync();
        }
      },
    );
  }

  Future<void> dataSync() async {
    alertService.showLoading();
    var token = secureStorage.getLoginToken();
    var request = {
      "loginToken": {"Token": token}
    };
    dataSyncService.getDropdownData(context, request).then((result) async {
      if (result != false) {
        var list = result['ListOptions'];
        final db = await DatabaseServices.instance.database;
        await db.rawQuery('DELETE FROM ${Constants.dropdownList}');
        lastUpdate = list['LastUpdatedDate'].toString();
        secureStorage.save("lastUpdate", lastUpdate);
        setState(() {});
        for (var entry in list.entries) {
          if (entry.value != null) {
            await dropdownServices.insert(entry.key, entry.value);
          }
          if (entry.key == list.keys.last) {
            alertService.hideLoading();
            alertService.successToast(Constants.apiSuccessMessage);
          }
        }
      } else {
        alertService.hideLoading();
        lastUpdate = '-';
        setState(() {});
      }
    });
  }
}
