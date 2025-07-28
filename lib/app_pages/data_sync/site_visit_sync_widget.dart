import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../app_config/app_constants.dart';
import '../../app_services/local_db/local_services/live_to_local_insert.dart';
import '../../app_services/local_db/local_services/property_list_services.dart';
import '../../app_services/local_db/local_services/user_case_summary_service.dart';
import '../../app_services/site_visit_service.dart';
import '../../app_storage/secure_storage.dart';
import '../../app_utils/alert_service.dart';
import 'widget/ds_list_widget.dart';

class SiteVisitSyncWidget extends StatefulWidget {
  final bool hasInternet;
  const SiteVisitSyncWidget({super.key, required this.hasInternet});

  @override
  State<SiteVisitSyncWidget> createState() => _SiteVisitSyncWidgetState();
}

class _SiteVisitSyncWidgetState extends State<SiteVisitSyncWidget> {
  // Initialize services as final since they don't change
  final SiteVisitService siteVisitService = SiteVisitService();
  final AlertService alertService = AlertService();
  final BoxStorage secureStorage = BoxStorage();
  final UserCaseSummaryService caseSummaryService = UserCaseSummaryService();
  final PropertyListService plService = PropertyListService();
  final LiveToLocalInsert ltlService = LiveToLocalInsert();

  @override
  Widget build(BuildContext context) {
    return DsListWidget(
      upload: false,
      title: 'Site Visit Data Sync',
      leadingIcon: LineAwesome.building,
      onPressed: () async {
        Fluttertoast.cancel();
        if (!widget.hasInternet) {
          await alertService.errorToast(Constants.checkInternetMsg);
        } else {
          final confirm = await alertService.confirmAlert(
            context,
            null,
            'Do you want download?\n1. User Case Summary\n2. Site Visit Data',
          );
          if (confirm == true) {
            await getUserSummary();
          }
        }
      },
    );
  }

  Future<void> getUserSummary() async {
    // Added Future<void> for better type safety
    final token = secureStorage.getLoginToken();
    await alertService.showLoading("Fetching User Case Summary...");

    final params = {
      "CustomerName": "",
      "loginToken": {"Token": token}
    };

    final response = await siteVisitService.getUserSummary(params);
    alertService.hideLoading();

    if (response != false && response['Summary'] != null) {
      await caseSummaryService.insert(response['Summary']);
      await getProperties(); // Move this after successful summary insertion
    } else {
      alertService.errorToast("Error: User Summary!");
    }
  }

  Future<void> getProperties() async {
    final token = secureStorage.getLoginToken();
    alertService.showLoading("Getting Property Data...");

    final params = {
      "CustomerName": "",
      "loginToken": {"Token": token}
    };

    try {
      final response = await siteVisitService.getPropertyList(params);
      if (response == false || response['PropertyList'] == null) {
        throw Exception("Failed to get property list");
      }

      if (response['PropertyList'].isEmpty) {
        alertService.hideLoading();
        alertService.errorToast("No data found");
        return;
      }

      final unAssignResponse =
          await siteVisitService.getUnAssignProperty(params);
      final List unAssignedProperties = unAssignResponse['UnassignedProperty'];
      final List assignedProperties = response['PropertyList'];

      // Filter out unassigned properties
      final filteredProperties = assignedProperties
          .where((prop) =>
              !unAssignedProperties.contains(prop['PropId'].toString()))
          .toList();

      // Get existing property list and handle pending records
      final existingProperties = await plService.read();
      final processedPropIds = <String>[];

      for (final prop in existingProperties) {
        if (prop['Status'].toString() == Constants.status[0]) {
          await deleteLocalRecords([prop['PropId'].toString()]);
        } else {
          processedPropIds.add(prop['PropId'].toString());
        }
      }

      // Filter out already processed properties
      final newProperties = filteredProperties
          .where(
              (prop) => !processedPropIds.contains(prop['PropId'].toString()))
          .toList();

      // Insert new properties
      await plService.insert(newProperties);
      // Process property details sequentially
      for (int i = 0; i < newProperties.length; i++) {
        await getPropertyDetailBasedOnId(
          newProperties[i]['PropId'],
          () {
            if (i == newProperties.length - 1) {
              alertService.successToast(Constants.apiSuccessMessage);
              alertService.hideLoading();
            }
          },
        );
      }
    } catch (e) {
      // alertService.errorToast("Try again!");
      alertService.hideLoading();
    }
  }

  Future<void> getPropertyDetailBasedOnId(
      String propId, Function() callback) async {
    final token = secureStorage.getLoginToken();
    final request = {
      "PropId": propId,
      "loginToken": {"Token": token}
    };

    final response = await siteVisitService.getPropertyDetails(request);
    if (response['PropertyDetails'].isEmpty) {
      alertService.hideLoading();
      alertService.errorToast("No details found");
      return;
    }
    await ltlService.insertAll(propId, response['PropertyDetails']);
    callback();
  }

  Future<void> deleteLocalRecords(List<String> propIds) async {
    final tables = [
      Constants.propertyList,
      Constants.customerBankDetails,
      Constants.propertyDetails,
      Constants.areaDetails,
      Constants.occupancyDetails,
      Constants.boundaryDetails,
      Constants.measurementSheet,
      Constants.stageCalculator,
      Constants.criticalComment,
      Constants.locationMap,
      Constants.propertyPlan,
      Constants.photograph,
    ];

    for (final table in tables) {
      await plService.deleteByPropId(table, propIds);
    }
  }
}
