import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../../../app_config/app_constants.dart';
import '../../../app_services/index.dart';
import '../../../app_services/sqlite/database_service.dart';
import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_storage/secure_storage.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_widgets/alert_widget.dart';
import 'sync_button_widget.dart';

class SiteVisitSyncWidget extends StatefulWidget {
  const SiteVisitSyncWidget({super.key});

  @override
  State<SiteVisitSyncWidget> createState() => _SiteVisitSyncWidgetState();
}

class _SiteVisitSyncWidgetState extends State<SiteVisitSyncWidget> {
  AlertService alertService = AlertService();
  List userSummary = [];
  List propertyList = [];
  List propertyDetailsBasedOnPropId = [];

  BoxStorage secureStorage = BoxStorage();
  DataSyncService dataSyncService = DataSyncService();
  DashboardService dashboardService = DashboardService();
  SiteVisitService siteVisitService = SiteVisitService();

  CustomerService customerService = CustomerService();
  LocationDetailServices locationDetailServices = LocationDetailServices();
  PropertyListServices propertyListServices = PropertyListServices();
  ReimbursementServices reimbursementServices = ReimbursementServices();
  UserCaseSummaryServices userCaseSummaryServices = UserCaseSummaryServices();
  CalculatorService calculatorService = CalculatorService();
  PropertyLocationServices propertyLocationServices =
      PropertyLocationServices();
  OccupancyServices occupancyServices = OccupancyServices();
  FeedbackServices feedbackServices = FeedbackServices();
  BoundaryServices boundaryServices = BoundaryServices();
  MeasurementServices measurementServices = MeasurementServices();
  CommentsServices commentsServices = CommentsServices();
  SketchService sketchService = SketchService();
  PhotographService photographService = PhotographService();
  UploadLocationMapService locationMapService = UploadLocationMapService();

  String token = "";

  bool hasInternet = false;
  StreamSubscription? subscription;

  @override
  void dispose() {
    Fluttertoast.cancel();
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    token = secureStorage.getLoginToken();
    checkInternet();
    setState(() {});
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
                  } else {
                    List property = await propertyListServices.readBySync();
                    if (property.isEmpty) {
                      alertService.errorToast(Constants.noDataSyncErrorMessage);
                    } else {
                      String msg = "Do you want to upload ${property.length} records.";
                      alertService.confirm(context, msg, "Ok", "Cancel",
                          () async {
                        Navigator.of(context).pop();
                        for (int i = 0; i < property.length; i++) {
                          String propId = property[i]['PropId'].toString();
                          print("propId ----- $propId");
                          await pushPropertyLocation(context, propId);
                          await pushLocationDetails(context, propId);
                          await pushOccupancyDetails(context, propId);
                          await pushFeedbackDetails(context, propId);
                          await pushBoundaryDetails(context, propId);
                          await pushCriticalComments(context, propId);
                          await pushMeasurementSheet(context, propId);
                          await pushStageCalculator(context, propId);
                          await pushPropertySketch(context, propId);
                          await pushPhotographs(context, propId);
                          await pushLocationMap(context, propId);
                          await submitProperty(context, propId);
                          await propertyListServices
                              .deleteRecord([Constants.status[2], propId]);
                        }

                      });
                    }
                  }
                }),
            const SizedBox(width: 15),
            SyncButtonWidget(
                icons: Icons.cloud_download_outlined,
                label: "Download",
                onTap: () {
                  if (!hasInternet) {
                    alertService.errorToast("Please check your internet!");
                    // Navigator.of(context).pop();
                  } else {
                    String msg = "Download data now?";
                    alertService.confirm(context, msg, "Ok", "Cancel",
                        () async {
                      newPullFun(context);
                      // Navigator.of(context).pop();
                      // getPropertyListData(context);
                      // getUserSummary(context);
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }

  newPullFun(BuildContext context) async {
    Navigator.of(context).pop();
    alertService.showLoading("Please wait...");
    await getUserSummary(context);
    await getPropertyListData(context);
  }

  /// PULL SERVICE
  getUserSummary(context) async {
    var token = secureStorage.getLoginToken();
    var request = {
      "loginToken": {"Token": token}
    };
    alertService.showLoading("Getting User Summary...");
    dashboardService.getUserSummary(request).then((usrSummary) async {
      if (usrSummary != false && usrSummary['Summary'] != null) {
        userSummary = [usrSummary['Summary']];
        await userCaseSummaryServices.insert(usrSummary['Summary']);
      } else {
        alertService.errorToast("Error: User Summary!");
      }
    });
  }

  getPropertyListData(context) async {
    var token = secureStorage.getLoginToken();
    alertService.showLoading("Getting Property Data...");
    var customerRequest = {
      "CustomerName": "",
      "loginToken": {"Token": token}
    };
    dashboardService
        .getPropertyList( customerRequest)
        .then((propertyResponse) async {
      if (propertyResponse != false &&
          propertyResponse['PropertyList'] != null) {
        setState(() {
          propertyList = propertyResponse['PropertyList'];
        });
        for (var element in propertyList) {
          getPropertyDetailBasedOnId(context, element['PropId']);
        }
        await propertyListServices.insert(propertyList);
      } else {
        alertService.errorToast("Try again!!!");
      }
    });
  }

  getPropertyDetailBasedOnId(context, propId) async {
    var token = secureStorage.getLoginToken();
    var request = {
      "PropId": propId.toString(),
      "loginToken": {"Token": token}
    };
    alertService.showLoading("Getting ID Based Product Details...");
    dataSyncService.getPropertyDetails(request).then((metaData) async {
      // alertService.hideLoading();
      if (metaData != false && metaData['PropertyDetails'] != null) {
        propertyDetailsBasedOnPropId = [metaData['PropertyDetails']];
        var property = propertyDetailsBasedOnPropId[0];

        /// DELETE TABLE DATA'S
        final db = await DatabaseServices.instance.database;
        await db.rawQuery('DELETE FROM ${Constants.customerBankDetails}');
        await db.rawQuery('DELETE FROM ${Constants.propertyLocation}');
        await db.rawQuery('DELETE FROM ${Constants.locationDetails}');
        await db.rawQuery('DELETE FROM ${Constants.occupancyDetails}');
        await db.rawQuery('DELETE FROM ${Constants.feedback}');
        await db.rawQuery('DELETE FROM ${Constants.boundaryDetails}');
        await db.rawQuery('DELETE FROM ${Constants.criticalComment}');
        await db.rawQuery('DELETE FROM ${Constants.propertySketch}');
        await db.rawQuery('DELETE FROM ${Constants.measurementSheet}');
        await db.rawQuery('DELETE FROM ${Constants.photograph}');
        await db.rawQuery('DELETE FROM ${Constants.locationMap}');
        await db.rawQuery('DELETE FROM ${Constants.stageCalculator}');

        /// GETTING LIVE DATA'S
        var customer = property['CustomerBankDetails'];
        var propertyLocation = property['PropertyLocationDetails'];
        var location = property['LocationDetails'];
        var occupancy = property['OccupancyDetails'];
        var feedback = property['Feedback'];
        var boundary = property['BoundaryDetails'];
        var comments = property['CriticalComment'];
        var propertySketch = property['PropertySketch'];
        var calculator = property['StageCalculator']['CalculatorDetails'];
        var measurements = property['MeasurementSheet'];
        var photograph = property['Photographs'];
        var locationMap = property['LocationMap'];
        try {
          alertService.showLoading("Inserting new records...");
          /// LIVE DATA TO INSERT LOCAL SQL
          await customerService.insert(propId, customer);
          await propertyLocationServices.insert(propId, propertyLocation);
          await locationDetailServices.insert(propId, location);
          await occupancyServices.insert(propId, occupancy);
          await feedbackServices.insert(propId, feedback);
          await boundaryServices.insert(propId, boundary);
          await commentsServices.insert(propId, comments);
          await sketchService.insert(propId, propertySketch);
          await calculatorService.insert(propId, calculator);
          await measurementServices.insert(propId, measurements);
          await photographService.insert(propId, photograph);
          await locationMapService.insert(propId, locationMap);
        } catch (e) {
          print('Error occurred: $e');
        } finally {
          Future.delayed(Duration(seconds: 5), () {
            alertService.hideLoading();
          });
        }
      }
    });
  }

  /// PUSH SERVICE
  pushPropertyLocation(BuildContext ctx, String propId) async {
    List pl = await propertyLocationServices.readSync(propId);
    if (pl.isNotEmpty) {
      alertService.showLoading("Property Location Sync...");
      var request = {
        "propertyLocationDetails": {
          "PropId": propId.toString(),
          "City": pl[0]['City'].toString().trim(),
          "Colony": pl[0]['Colony'].toString().trim(),
          "PropertyAddressAsPerSite":
              pl[0]['PropertyAddressAsPerSite'].toString().trim(),
          "AddressMatching": pl[0]['AddressMatching'].toString().trim(),
          "LocalMuniciapalBody": pl[0]['LocalMuniciapalBody'].toString().trim(),
          "NameOfMunicipalBody": pl[0]['NameOfMunicipalBody'].toString().trim(),
        },
        "loginToken": {"Token": token.toString()}
      };
      siteVisitService
          .createPropertyLocationDetails(ctx, request)
          .then((data) async {
        if (data["Status"]) {
          // await propertyLocationServices.updateSyncStatus(['Y', propId]);
          await propertyLocationServices.deleteRecord([propId]);
          // alertService.hideLoading();
          // AlertService().successToast("Success");
        } else {
          // alertService.hideLoading();
          // AlertService().errorToast("Error Property Location");
        }
      });
    }
  }

  pushLocationDetails(BuildContext ctx, String propId) async {
    List val = await locationDetailServices.readSync(propId);
    if (val.isNotEmpty) {
      alertService.showLoading("Location Sync...");
      var request = {
        "locationDetails": {
          "PropId": propId.toString(),
          "NearbyLandmark": val[0]['NearbyLandmark'].toString(),
          "Micromarket": val[0]['Micromarket'].toString(),
          "Latitude": val[0]['Latitude'].toString(),
          "Longitude": val[0]['Longitude'].toString(),
          "InfrastructureOfTheSurroundingArea":
              val[0]['InfrastructureOfTheSurroundingArea'].toString(),
          "NatureOfLocality": val[0]['NatureOfLocality'].toString(),
          "ClassOfLocality": val[0]['ClassOfLocality'].toString(),
          "ProximityFromCivicsAmenities":
              val[0]['ProximityFromCivicsAmenities'].toString().trim(),
          "NearestRailwayStation": val[0]['NearestRailwayStation'].toString(),
          "NearestMetroStation": val[0]['NearestMetroStation'].toString(),
          "NearestBusStop": val[0]['NearestBusStop'].toString(),
          "ConditionAndWidthOfApproachRoad":
              val[0]['ConditionAndWidthOfApproachRoad'].toString(),
          "SiteAccess": val[0]['SiteAccess'].toString(),
          "NeighborhoodType": val[0]['NeighborhoodType'].toString(),
          "NearestHospital": val[0]['NearestHospital'].toString(),
          "AnyNegativeToTheLocality":
              val[0]['AnyNegativeToTheLocality'].toString(),
        },
        "loginToken": {"Token": token.toString()}
      };
      print("locationDetails --> ${jsonEncode(request)} ");
      siteVisitService.createLocationDetails(ctx, request).then((data) async {
        if (data["Status"]) {
          // await locationDetailServices.updateSyncStatus(['Y', propId]);
          await locationDetailServices.deleteRecord([propId]);
          // alertService.hideLoading();
          // AlertService().successToast("Success");
        } else {
          // alertService.hideLoading();
          // AlertService().errorToast("Error Location Details");
        }
      });
    }
  }

  pushOccupancyDetails(BuildContext ctx, String propId) async {
    List val = await occupancyServices.readSync(propId);
    if (val.isNotEmpty) {
      alertService.showLoading("Occupancy Sync...");
      var request = {
        "occupancyDetails": {
          "PropId": propId.toString(),
          "StatusOfOccupancy": val[0]['StatusOfOccupancy'].toString(),
          "OccupiedBy": val[0]['OccupiedBy'].toString(),
          "RelationshipOfOccupantWithCustomer":
              val[0]['RelationshipOfOccupantWithCustomer'].toString(),
          "OccupiedSince": val[0]['OccupiedSince'].toString(),
        },
        "loginToken": {"Token": token.toString()}
      };
      siteVisitService.createOccupancyDetails(ctx, request).then((data) async {
        if (data["Status"]) {
          // await occupancyServices.updateSyncStatus(['Y', propId]);
          await occupancyServices.deleteRecord([propId]);
          //alertService.hideLoading();
          // AlertService().successToast("Success");
        } else {
          //alertService.hideLoading();
          // AlertService().errorToast("Error Location Details");
        }
      });
    }
  }

  pushFeedbackDetails(BuildContext ctx, String propId) async {
    List val = await feedbackServices.readSync(propId);
    if (val.isNotEmpty) {
      alertService.showLoading("Feedback Sync...");
      var request = {
        "feedback": {
          "PropId": propId.toString(),
          "Amenities": val[0]['Amenities'].toString(),
          "MaintainanceLevel": val[0]['MaintainanceLevel'].toString(),
          "ApproxAgeOfProperty": val[0]['ApproxAgeOfProperty'].toString(),
        },
        "loginToken": {"Token": token.toString()}
      };
      siteVisitService.createFeedback(ctx, request).then((data) async {
        if (data["Status"]) {
          // await feedbackServices.updateSyncStatus(['Y', propId]);
          await feedbackServices.deleteRecord([propId]);
          //alertService.hideLoading();
          // AlertService().successToast("Success");
        } else {
          //alertService.hideLoading();
          // AlertService().errorToast("Error Location Details");
        }
      });
    }
  }

  pushBoundaryDetails(BuildContext ctx, String propId) async {
    List val = await boundaryServices.readSync(propId);
    if (val.isNotEmpty) {
      alertService.showLoading("Boundary Sync...");
      var request = {
        "boundaryDetails": {
          "PropId": propId.toString(),
          "AsPerSite": {
            "East": val[0]['East'].toString().trim(),
            "West": val[0]['West'].toString().trim(),
            "South": val[0]['South'].toString().trim(),
            "North": val[0]['North'].toString().trim(),
          }
        },
        "loginToken": {"Token": token.toString()}
      };
      siteVisitService.createBoundaryDetails(ctx, request).then((data) async {
        if (data["Status"]) {
          // await boundaryServices.updateSyncStatus(['Y', propId]);
          await boundaryServices.deleteRecord([propId]);
          //alertService.hideLoading();
          // AlertService().successToast("Success");
        } else {
          //alertService.hideLoading();
          // AlertService().errorToast("Error Location Details");
        }
      });
    }
  }

  pushCriticalComments(BuildContext ctx, String propId) async {
    List val = await commentsServices.readSync(propId);
    if (val.isNotEmpty) {
      alertService.showLoading("Comments Sync...");
      var request = {
        "criticalComment": {
          "PropId": propId.toString(),
          "Comment": val[0]['Comment'].toString()
        },
        "loginToken": {"Token": token.toString()}
      };
      siteVisitService.createCriticalComment(ctx, request).then((data) async {
        if (data["Status"]) {
          // await commentsServices.updateSyncStatus(['Y', propId]);
          await commentsServices.deleteRecord([propId]);
          //alertService.hideLoading();
          // AlertService().successToast("Comment Success");
        } else {
          //alertService.hideLoading();
          // AlertService().errorToast("Comment Failed!");
        }
      });
    }
  }

  pushMeasurementSheet(BuildContext ctx, String propId) async {
    List val = await measurementServices.readSync(propId);
    if (val.isNotEmpty) {
      alertService.showLoading("Measurement Sync...");
      var request = {
        "measurementSheets": {
          "SheetType": val[0]['SheetType'].toString(),
          "SizeType": val[0]['SizeType'].toString(),
          "PropId": propId.toString(),
          "Sheet": jsonDecode(val[0]['Sheet']),
        },
        "loginToken": {"Token": token.toString()}
      };
      siteVisitService.createMeasurementSheet(ctx, request).then((data) async {
        if (data["Status"]) {
          // await measurementServices.updateSyncStatus(['Y', propId]);
          await measurementServices.deleteRecord([propId]);
          //alertService.hideLoading();
          // AlertService().successToast("Measurement Sheets Success");
        } else {
          //alertService.hideLoading();
          // AlertService().errorToast("Measurement Sheets Failed!");
        }
      });
    }
  }

  pushStageCalculator(BuildContext ctx, String propId) async {
    List val = await calculatorService.readSync(propId);
    print("State Cal --> $val");
    if (val.isNotEmpty) {
      alertService.showLoading("Stage Calculator Sync...");
      var request = {
        "stageCalculator": {
          "PropId": propId.toString(),
          "CalculatorDetails": {
            "Id": json.decode(val[0]['Id']),
            "MasterId": json.decode(val[0]['MasterId']),
            "Progress": json.decode(val[0]['Progress']),
            "ProgressPer": json.decode(val[0]['ProgressPer']),
            "ProgressPerAsPerPolicy":
                json.decode(val[0]['ProgressPerAsPerPolicy']),
            "Recommended": json.decode(val[0]['Recommended']),
            "RecommendedPer": json.decode(val[0]['RecommendedPer']),
            "TotalFloor": json.decode(val[0]['TotalFloor']),
            "CompletedFloor": json.decode(val[0]['CompletedFloor'])
          }
        },
        "loginToken": {"Token": token.toString()}
      };
      print(jsonEncode(request));
      siteVisitService.createStageCalculator(ctx, request).then((data) async {
        if (data["Status"]) {
          // await calculatorService.updateSyncStatus(['Y', propId]);
          await calculatorService.deleteRecord([propId]);
          //alertService.hideLoading();
          // AlertService().successToast("Stage Calculator Success");
        } else {
          //alertService.hideLoading();
          // AlertService().errorToast("Stage Calculator Failed!");
        }
      });
    }
  }

  getBase64String(String path) {
    final bytes = File(path.toString()).readAsBytesSync();
    return base64Encode(bytes);
  }

  deleteLocalSql(String id) async {
    await sketchService.updateSyncStatus(["N", id]);
    await sketchService.deleteById(id);
    // if (!mounted) return;
    // getPropertyListData(context);
  }

  deleteLiveData(list) {
    alertService.showLoading("Deleting...");
    var token = secureStorage.getLoginToken();
    var request = {
      "photograph": {
        "Id": int.parse(list['Id'].toString()),
        "PropId": list['PropId'].toString()
      },
      "loginToken": {"Token": token.toString()}
    };
    siteVisitService.deleteImage(context, request).then((r1) {
      //alertService.hideLoading();
      if (r1['Status']) {
        deleteLocalSql(list['primaryId'].toString());
      }
    });
  }

  pushPropertySketch(BuildContext ctx, String propId) async {
    List val = await sketchService.readSync(propId);
    if (val.isNotEmpty) {
      alertService.showLoading("Property Sketch Sync...");
      for (var list in val) {
        String path = list['ImagePath'].toString();
        String valid = path == "" ? "" : path;
        String baseString = "";
        if (!Uri.parse(path).isAbsolute && valid != "") {
          baseString = await getBase64String(path);
          setState(() {});
        }
        var request = {
          "imageDetails": {
            "PropId": propId.toString(),
            "ImageBase64String": baseString.toString(),
            "ImageDesc": list['ImageDesc'].toString().trim(),
            "ImageName": list['ImageName'].toString().trim(),
            "IsResizeImage": true,
            "ImageOrder": list['ImageOrder'].toString().trim(),
          },
          "loginToken": {"Token": token.toString()}
        };
        String id = list['Id'].toString();
        String isActive = list['IsActive'].toString();
        if (id == "0" && isActive == "N") {
          await sketchService.updateSyncStatus(["N", id]);
          await sketchService.deleteById(id);
        } else if (id != "0" && isActive == "N") {
          await deleteLiveData(list);
        } else {
          siteVisitService
              .createPropertySketch(ctx, request)
              .then((data) async {
            //alertService.hideLoading();
            await sketchService.deleteRecord([propId]);

            // if (data["Status"]) {
            //   await sketchService.updateSyncStatus(['Y', propId]);
            //   if (!mounted) return;
            //   getPropertyListData(context);
            //   alertService.hideLoading();
            //   AlertService().successToast("Success");
            // } else {
            //   alertService.hideLoading();
            //   AlertService().errorToast("Error Location Details");
            // }
          });
        }
      }
    }
  }

  pushPhotographs(BuildContext ctx, String propId) async {
    List val = await photographService.readSync(propId);
    if (val.isNotEmpty) {
      alertService.showLoading("${Constants.photographTitle} Sync...");
      for (var list in val) {
        String path = list['ImagePath'].toString();
        String valid = path == "" ? "" : path;
        String baseString = "";
        if (!Uri.parse(path).isAbsolute && valid != "") {
          baseString = await getBase64String(path);
          setState(() {});
        }
        var request = {
          "imageDetails": {
            "PropId": propId.toString(),
            "ImageDesc": list['ImageDesc'].toString().trim(),
            "ImageName": list['ImageName'].toString().trim(),
            "IsResizeImage": true,
            "ImageOrder": list['ImageOrder'].toString().trim(),
            "ImageBase64String": baseString.toString(),
          },
          "loginToken": {"Token": token.toString()},
        };
        print("---------------");
        print("request --> ${jsonEncode(request)}");
        print("---------------");
        String id = list['Id'].toString();
        String isActive = list['IsActive'].toString();
        if (id == "0" && isActive == "N") {
          await photographService.updateSyncStatus(["N", id]);
          await photographService.deleteById(id);
        } else if (id != "0" && isActive == "N") {
          await deleteLiveData(list);
        } else {
          siteVisitService.createPhotograph(ctx, request).then((data) async {
            // await photographService.updateSyncStatus(['Y', propId]);
            await photographService.deleteRecord([propId]);
            if (!mounted) return;
            //alertService.hideLoading();
            // AlertService().successToast("Success");
          });
        }
      }
    }
  }

  pushLocationMap(BuildContext ctx, String propId) async {
    List val = await locationMapService.readSync(propId);
    if (val.isNotEmpty) {
      alertService.showLoading("${Constants.locationMapTitle} Sync...");
      for (var list in val) {
        String path = list['ImagePath'].toString();
        String valid = path == "" ? "" : path;
        String baseString = "";
        if (!Uri.parse(path).isAbsolute && valid != "") {
          baseString = await getBase64String(path);
          setState(() {});
        }
        var request = {
          "loginToken": {"Token": token.toString()},
          "imageDetails": {
            "PropId": propId.toString(),
            "ImageDesc": list['ImageDesc'].toString().trim(),
            "ImageName": list['ImageName'].toString().trim(),
            "IsResizeImage": true,
            "ImageOrder": list['ImageOrder'].toString().trim(),
            "ImageBase64String": baseString.toString(),
          },
        };
        String id = list['Id'].toString();
        String isActive = list['IsActive'].toString();
        if (id == "0" && isActive == "N") {
          await locationMapService.updateSyncStatus(["N", id]);
          await locationMapService.deleteById(id);
        } else if (id != "0" && isActive == "N") {
          await deleteLiveData(list);
        } else {
          siteVisitService.createLocationMap(ctx, request).then((data) async {
            await locationMapService.deleteRecord([propId]);
            //alertService.hideLoading();
            // AlertService().successToast("Success");
          });
        }
      }
    }
  }
  submitProperty(BuildContext ctx, String propId) async {
    alertService.showLoading("Submitting Property...");
    var request = {
      "PropId": propId.toString(),
      "loginToken": {
        "Token": token.toString()
      }
    };
    siteVisitService.submitProperty(context, request).then((data) async {
      Future.delayed(const Duration(seconds: 5), () {
        alertService.hideLoading();
      });
      if (data['Status']) {
        alertService.hideLoading();
        AlertService().successToast(Constants.apiSuccessMessage);
      } else {
        alertService.hideLoading();
        AlertService().errorToast(Constants.apiErrorMessage);
      }
    });
  }
}
