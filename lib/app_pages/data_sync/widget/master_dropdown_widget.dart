import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proequity/app_config/index.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../../../app_config/app_constants.dart';
import '../../../app_services/data_sync_service.dart';
import '../../../app_services/sqlite/dropdown_services.dart';
import '../../../app_storage/secure_storage.dart';
import '../../../app_widgets/alert_widget.dart';

class MasterDropdownWidget extends StatefulWidget {
  const MasterDropdownWidget({super.key});

  @override
  State<MasterDropdownWidget> createState() => _MasterDropdownWidgetState();
}

class _MasterDropdownWidgetState extends State<MasterDropdownWidget> {
  AlertService alertService = AlertService();
  BoxStorage secureStorage = BoxStorage();
  DataSyncService dataSyncService = DataSyncService();
  DropdownServices dropdownServices = DropdownServices();

  List dropdownData = [];
  String lastUpdate = "";
  bool hasInternet = false;
  StreamSubscription? subscription;

  @override
  void initState() {
    lastUpdate = secureStorage.get("lastUpdate") ?? "";
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
      decoration: BoxDecoration(
        boxShadow: CustomTheme.boxShadow,
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: const Icon(
            Icons.format_list_bulleted_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Dropdown Master",
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        isThreeLine: false,
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
        trailing: IconButton(
          icon: const InkWell(
            splashFactory: InkRipple.splashFactory,
            splashColor: Colors.blue,
            child: Column(
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
          onPressed: dataSync,
        ),
      ),
    );
  }

  Future<void> dataSync() async {
    if (!hasInternet) {
      alertService.errorToast("Please check your internet!");
    } else {
      alertService.showLoading(Constants.loadingMessage);
      var token = secureStorage.getLoginToken();
      var request = {
        "loginToken": {"Token": token}
      };
      dataSyncService.getDropdownData(context, request).then((result) async {
        alertService.hideLoading();
        if (result != false) {
          var list = result['ListOptions'];
          setState(() {
            dropdownData = [list];
            secureStorage.save(
                "lastUpdate", list['LastUpdatedDate'].toString());
          });
          list.forEach((k, v) async => await dropdownServices.insert(k, v));
          alertService.successToast(Constants.apiSuccessMessage);
        }
      });
    }
  }
}
