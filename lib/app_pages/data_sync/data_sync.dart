import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../app_services/local_db/local_services/dropdown_services.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_utils/alert_service.dart';
import 'dropdown_sync.dart';
import 'reimbursement_widget.dart';
import 'site_visit_sync_widget.dart';
import 'widget/online_offline_widget.dart';

class DataSync extends StatefulWidget {
  const DataSync({super.key});

  @override
  State<DataSync> createState() => _DataSyncState();
}

class _DataSyncState extends State<DataSync> {
  bool hasInternet = true;
  StreamSubscription? subscription;
  AlertService alertService = AlertService();
  BoxStorage secureStorage = BoxStorage();
  DropdownServices dropdownServices = DropdownServices();

  @override
  void initState() {
    debugPrint("---> Data Sync Page <---");
    checkInternet();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 25),
            OnlineOfflineWidget(hasInternet: hasInternet),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Sync Options",
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownSync(hasInternet: hasInternet),
            const SizedBox(height: 10),
            ReimbursementWidget(hasInternet: hasInternet),
            const SizedBox(height: 10),
            SiteVisitSyncWidget(hasInternet: hasInternet),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    subscription?.cancel();
    super.dispose();
  }
}
