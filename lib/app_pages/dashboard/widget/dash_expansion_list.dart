import 'dart:convert';
import 'dart:io';

import 'package:advance_expansion_tile/advance_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proequity/app_config/app_constants.dart';
import 'package:proequity/app_config/index.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:proequity/app_widgets/alert_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_services/index.dart';
import '../../../app_services/sqlite/database_service.dart';
import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_storage/secure_storage.dart';
import '../../../app_theme/theme_files/app_color.dart';

class DashExpansionTile extends StatelessWidget {
  final Color? leadingIconColor;
  final IconData? leadingIcon;
  final Color? iconColor;
  final dynamic item;
  final Function function;

  const DashExpansionTile({
    super.key,
    this.leadingIconColor,
    this.leadingIcon,
    this.iconColor,
    this.item,
    required this.function,
  });

  getColor(String status) {
    if (status == Constants.status[0]) {
      return Constants.statusPending; // PENDING
    } else if (status == Constants.status[1]) {
      return Constants.statusProcess; // PROCESS
    } else if (status == Constants.status[2]) {
      return Constants.statusCompleted; // COMPLETED
    }
  }

  Widget rowDetails(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Wrap(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            width: 200,
            child: Text(
              value.toString() == "" ? "-" : value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
        ]),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (Platform.isAndroid) {
      await launchUrl(launchUri);
    } else if (Platform.isIOS) {}
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AdvanceExpansionTileState> globalKey = GlobalKey();

    return AdvanceExpansionTile(
      key: globalKey,
      maintainState: false,
      textColor: leadingIconColor,
      iconColor: leadingIconColor,
      controlAffinity: ListTileControlAffinity.trailing,
      tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: getColor(item['Status']),
        ),
        child: Icon(
          leadingIcon ?? LineAwesome.building,
          color: Colors.white,
        ),
      ),
      title: Text(
        "${item['ApplicationNumber'].toString()} - ${item['CustomerName'].toString()}",
        overflow: TextOverflow.clip,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        "${item['ColonyName'] == '' ? 'NIL' : item['ColonyName']} - ${item['LocationName'].toString()}",
        overflow: TextOverflow.clip,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      decoration: CustomTheme.decoration,
      children: [
        rowDetails("Institute Name", item['InstituteName'].toString()),
        CustomTheme.defaultHeight10,
        if (item['ContactPersonNumber'].toString().length == 10) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contact Number",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  _makePhoneCall(item['ContactPersonNumber'].toString());
                },
                child: Text(
                  item['ContactPersonNumber'].toString().substring(0, 4) +
                      ('*' *
                          (item['ContactPersonNumber'].toString().length - 4)),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    decoration: TextDecoration.none,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
          CustomTheme.defaultHeight10,
        ],
        rowDetails("Priority", item['Priority'].toString()),
        CustomTheme.defaultHeight10,
        rowDetails("Date Of Visit", item['DateOfVisit'].toString()),
        CustomTheme.defaultHeight10,
        rowDetails("Address", item['Address'].toString()),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              width: 100.0,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "ViewSiteVisit",
                      arguments: item['PropId'].toString());
                  // Add your on pressed event here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'View',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (item['Status'] != Constants.status[2]) ...[
              Container(
                  padding: const EdgeInsets.all(7),
                  width: 100.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "siteVisitForm",
                          arguments: item['PropId'].toString());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ],
            if (item['Status'] == Constants.status[2]) ...[
              Container(
                  padding: const EdgeInsets.all(7),
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      print("--- Upload ${item['PropId'].toString()} ---");
                      uploadLocalToLive(item['PropId'].toString());
                      // function(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Upload',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ],
          ],
        ),
      ],
      onTap: () {
        // globalKey.currentState?.toggle();
      },
    );
  }

  uploadLocalToLive(String propId) async {
    AlertService alertService = AlertService();
    BoxStorage secureStorage = BoxStorage();
    SiteVisitService svService = SiteVisitService();
    PropertyLocationServices plService = PropertyLocationServices();
    LocationDetailServices lService = LocationDetailServices();
    OccupancyServices oServices = OccupancyServices();
    FeedbackServices fServices = FeedbackServices();
    BoundaryServices bServices = BoundaryServices();
    MeasurementServices mServices = MeasurementServices();
    CalculatorService scService = CalculatorService();
    CommentsServices ccService = CommentsServices();
    SketchService sketchService = SketchService();
    PhotographService photographService = PhotographService();
    UploadLocationMapService locationMapService = UploadLocationMapService();

    String token = "";
    token = secureStorage.getLoginToken();

    alertService.showLoading();

    /// ---------------------------- Property Location
    List pl = await plService.readSync(propId);
    if (pl.isNotEmpty) {
      var request1 = {
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
      svService.propertyLocation(request1).then((data) async {
        if (data["Status"]) {
          print("--- Property List ---");
        } else {
          alertService.hideLoading();
          alertService.errorToast("Error: Property Location");
        }
      });
    }

    /// LOCATION DETAILS - UPLOAD SYNC
    List l = await lService.readSync(propId);
    if (l.isNotEmpty) {
      var lReq = {
        "locationDetails": {
          "PropId": propId.toString(),
          "NearbyLandmark": l[0]['NearbyLandmark'].toString(),
          "Micromarket": l[0]['Micromarket'].toString(),
          "Latitude": l[0]['Latitude'].toString(),
          "Longitude": l[0]['Longitude'].toString(),
          "InfrastructureOfTheSurroundingArea":
              l[0]['InfrastructureOfTheSurroundingArea'].toString(),
          "NatureOfLocality": l[0]['NatureOfLocality'].toString(),
          "ClassOfLocality": l[0]['ClassOfLocality'].toString(),
          "ProximityFromCivicsAmenities":
              l[0]['ProximityFromCivicsAmenities'].toString().trim(),
          "NearestRailwayStation": l[0]['NearestRailwayStation'].toString(),
          "NearestMetroStation": l[0]['NearestMetroStation'].toString(),
          "NearestBusStop": l[0]['NearestBusStop'].toString(),
          "ConditionAndWidthOfApproachRoad":
              l[0]['ConditionAndWidthOfApproachRoad'].toString(),
          "SiteAccess": l[0]['SiteAccess'].toString(),
          "NeighborhoodType": l[0]['NeighborhoodType'].toString(),
          "NearestHospital": l[0]['NearestHospital'].toString(),
          "AnyNegativeToTheLocality":
              l[0]['AnyNegativeToTheLocality'].toString(),
        },
        "loginToken": {"Token": token.toString()}
      };
      svService.locationDetails(lReq).then((data) async {
        if (data["Status"]) {
          print("--- LOCATION DETAILS ---");
        } else {
          alertService.hideLoading();
          alertService.errorToast("Error: LOCATION DETAILS");
        }
      });
    }

    /// OCCUPANCY DETAILS
    List o = await oServices.readSync(propId);
    if (o.isNotEmpty) {
      var oReq = {
        "occupancyDetails": {
          "PropId": propId.toString(),
          "StatusOfOccupancy": o[0]['StatusOfOccupancy'].toString(),
          "OccupiedBy": o[0]['OccupiedBy'].toString(),
          "RelationshipOfOccupantWithCustomer":
              o[0]['RelationshipOfOccupantWithCustomer'].toString(),
          "OccupiedSince": o[0]['OccupiedSince'].toString(),
        },
        "loginToken": {"Token": token.toString()}
      };
      print("Occupancy Request -> ${jsonEncode(oReq)}");
      svService.occupancyDetails(oReq).then((data) async {
        print("Occupancy Response -> $data");
        if (data["Status"]) {
          print("--- OCCUPANCY DETAILS ---");
        } else {
          alertService.hideLoading();
          alertService.errorToast("Error: OCCUPANCY DETAILS");
        }
      });
    }

    /// FEEDBACK DETAILS
    List f = await fServices.readSync(propId);
    if (f.isNotEmpty) {
      var fReq = {
        "feedback": {
          "PropId": propId.toString(),
          "Amenities": f[0]['Amenities'].toString(),
          "MaintainanceLevel": f[0]['MaintainanceLevel'].toString(),
          "ApproxAgeOfProperty": f[0]['ApproxAgeOfProperty'].toString(),
        },
        "loginToken": {"Token": token.toString()}
      };
      svService.feedback(fReq).then((data) async {
        if (data["Status"]) {
          print("--- FEEDBACK DETAILS ---");
        } else {
          alertService.hideLoading();
          alertService.errorToast("Error: FEEDBACK DETAILS");
        }
      });
    }

    /// BOUNDARY DETAILS
    List b = await bServices.readSync(propId);
    if (b.isNotEmpty) {
      var request = {
        "boundaryDetails": {
          "PropId": propId.toString(),
          "AsPerSite": {
            "East": b[0]['East'].toString().trim(),
            "West": b[0]['West'].toString().trim(),
            "South": b[0]['South'].toString().trim(),
            "North": b[0]['North'].toString().trim(),
          }
        },
        "loginToken": {"Token": token.toString()}
      };
      svService.boundaryDetails(request).then((data) async {
        if (data["Status"]) {
          print("--- BOUNDARY DETAILS ---");
        } else {
          alertService.hideLoading();
          alertService.errorToast("Error: BOUNDARY DETAILS");
        }
      });
    }

    /// MEASUREMENT SHEET
    List m = await mServices.readSync(propId);
    if (m.isNotEmpty) {
      String jsonString = m[0]['Sheet'];
      List sheets = jsonDecode(jsonString);
      print("Measurement Sheet Req -> ${sheets}");
      for (int s = 0; s < sheets.length; s++) {
        var mReq = {
          "measurementSheets": {
            "SheetType": m[0]['SheetType'].toString(),
            "SizeType": m[0]['SizeType'].toString(),
            "PropId": propId.toString(),
            "Sheet": [sheets[s]],
          },
          "loginToken": {"Token": token.toString()}
        };
        svService.measurementSheet(mReq).then((data) async {
          print("Data received: $data");
          var status = data["Status"];
          if (status["IsSuccess"] == true) {
            print("--- MEASUREMENT DETAILS ---");
          } else {
            alertService.hideLoading();
            alertService.errorToast("Error: MEASUREMENT DETAILS");
          }
        });
      }
    }

    /// STAGE CALCULATOR
    List sc = await scService.readSync(propId);
    if (sc.isNotEmpty) {
      var scReq = {
        "stageCalculator": {
          "PropId": propId.toString(),
          "CalculatorDetails": {
            "Id": json.decode(sc[0]['Id']),
            "MasterId": json.decode(sc[0]['MasterId']),
            "Progress": json.decode(sc[0]['Progress']),
            "ProgressPer": json.decode(sc[0]['ProgressPer']),
            "ProgressPerAsPerPolicy":
                json.decode(sc[0]['ProgressPerAsPerPolicy']),
            "Recommended": json.decode(sc[0]['Recommended']),
            "RecommendedPer": json.decode(sc[0]['RecommendedPer']),
            "TotalFloor": json.decode(sc[0]['TotalFloor']),
            "CompletedFloor": json.decode(sc[0]['CompletedFloor'])
          }
        },
        "loginToken": {"Token": token.toString()}
      };
      svService.stageCalculator(scReq).then((data) async {
        if (data["Status"]) {
          print("--- STAGE CALCULATOR ---");
        } else {
          alertService.hideLoading();
          alertService.errorToast("Error: STAGE CALCULATOR");
        }
      });
    }

    /// CRITICAL COMMENTS
    List cc = await ccService.readSync(propId);
    if (cc.isNotEmpty) {
      var ccReq = {
        "criticalComment": {
          "PropId": propId.toString(),
          "Comment": cc[0]['Comment'].toString()
        },
        "loginToken": {"Token": token.toString()}
      };
      svService.criticalComment(ccReq).then((data) async {
        if (data["Status"]) {
          print("--- CRITICAL COMMENTS ---");
        } else {
          alertService.hideLoading();
          alertService.errorToast("Error: CRITICAL COMMENTS");
        }
      });
    }

    /// LOCATION MAP - UPLOAD SYNC
    await uploadLocationMap(propId);

    /// PROPERTY SKETCH - UPLOAD SYNC
    await uploadPropertySketch(propId);

    /// PHOTOGRAPH - UPLOAD SYNC
    await uploadPhotograph(propId);

    // Future.delayed(const Duration(seconds: 5), () {
    //   alertService.hideLoading();
    //         alertService.successToast(Constants.apiSuccessMessage);
    // });
    /// SUBMIT PROPERTIES
    Future.delayed(const Duration(seconds: 10), () {
      var finalReq = {
        "PropId": propId.toString(),
        "loginToken": {"Token": token.toString()}
      };
      svService.submitPropertyNew(finalReq).then((data) async {
        if (data['Status']) {
          final db = await DatabaseServices.instance.database;
          await db.rawQuery(
              'DELETE FROM ${Constants.propertyList} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.customerBankDetails} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.propertyLocation} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.locationDetails} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.occupancyDetails} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.feedback} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.boundaryDetails} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.measurementSheet} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.stageCalculator} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.criticalComment} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.locationMap} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.propertySketch} WHERE PropId =${propId.toString()}');
          await db.rawQuery(
              'DELETE FROM ${Constants.photograph} WHERE PropId =${propId.toString()}');
          alertService.hideLoading();
          alertService.successToast(Constants.apiSuccessMessage);
          function(data['Status']);
        } else {
          alertService.hideLoading();
          alertService.errorToast(Constants.apiErrorMessage);
        }
      });
    });

    /// ----------------------------
    /// Property List - UPLOAD SYNC
    // List pl = await plService.readSync(propId);
    // print(pl);
    // if (pl.isNotEmpty) {
    //   var request1 = {
    //     "propertyLocationDetails": {
    //       "PropId": propId.toString(),
    //       "City": pl[0]['City'].toString().trim(),
    //       "Colony": pl[0]['Colony'].toString().trim(),
    //       "PropertyAddressAsPerSite":
    //           pl[0]['PropertyAddressAsPerSite'].toString().trim(),
    //       "AddressMatching": pl[0]['AddressMatching'].toString().trim(),
    //       "LocalMuniciapalBody": pl[0]['LocalMuniciapalBody'].toString().trim(),
    //       "NameOfMunicipalBody": pl[0]['NameOfMunicipalBody'].toString().trim(),
    //     },
    //     "loginToken": {"Token": token.toString()}
    //   };
    //   svService.propertyLocation(request1).then((data) async {
    //     if (data["Status"]) {
    //       print("--- Property List ---");
    //
    //       /// LOCATION DETAILS - UPLOAD SYNC
    //       List l = await lService.readSync(propId);
    //       var lReq = {
    //         "locationDetails": {
    //           "PropId": propId.toString(),
    //           "NearbyLandmark": l[0]['NearbyLandmark'].toString(),
    //           "Micromarket": l[0]['Micromarket'].toString(),
    //           "Latitude": l[0]['Latitude'].toString(),
    //           "Longitude": l[0]['Longitude'].toString(),
    //           "InfrastructureOfTheSurroundingArea":
    //               l[0]['InfrastructureOfTheSurroundingArea'].toString(),
    //           "NatureOfLocality": l[0]['NatureOfLocality'].toString(),
    //           "ClassOfLocality": l[0]['ClassOfLocality'].toString(),
    //           "ProximityFromCivicsAmenities":
    //               l[0]['ProximityFromCivicsAmenities'].toString().trim(),
    //           "NearestRailwayStation": l[0]['NearestRailwayStation'].toString(),
    //           "NearestMetroStation": l[0]['NearestMetroStation'].toString(),
    //           "NearestBusStop": l[0]['NearestBusStop'].toString(),
    //           "ConditionAndWidthOfApproachRoad":
    //               l[0]['ConditionAndWidthOfApproachRoad'].toString(),
    //           "SiteAccess": l[0]['SiteAccess'].toString(),
    //           "NeighborhoodType": l[0]['NeighborhoodType'].toString(),
    //           "NearestHospital": l[0]['NearestHospital'].toString(),
    //           "AnyNegativeToTheLocality":
    //               l[0]['AnyNegativeToTheLocality'].toString(),
    //         },
    //         "loginToken": {"Token": token.toString()}
    //       };
    //       svService.locationDetails(lReq).then((data) async {
    //         if (data["Status"]) {
    //           print("--- LOCATION DETAILS ---");
    //
    //           /// OCCUPANCY DETAILS
    //           List o = await oServices.readSync(propId);
    //           var oReq = {
    //             "occupancyDetails": {
    //               "PropId": propId.toString(),
    //               "StatusOfOccupancy": o[0]['StatusOfOccupancy'].toString(),
    //               "OccupiedBy": o[0]['OccupiedBy'].toString(),
    //               "RelationshipOfOccupantWithCustomer":
    //                   o[0]['RelationshipOfOccupantWithCustomer'].toString(),
    //               "OccupiedSince": o[0]['OccupiedSince'].toString(),
    //             },
    //             "loginToken": {"Token": token.toString()}
    //           };
    //           svService.occupancyDetails(oReq).then((data) async {
    //             if (data["Status"]) {
    //               print("--- OCCUPANCY DETAILS ---");
    //
    //               /// FEEDBACK DETAILS
    //               List f = await fServices.readSync(propId);
    //               var fReq = {
    //                 "feedback": {
    //                   "PropId": propId.toString(),
    //                   "Amenities": f[0]['Amenities'].toString(),
    //                   "MaintainanceLevel": f[0]['MaintainanceLevel'].toString(),
    //                   "ApproxAgeOfProperty":
    //                       f[0]['ApproxAgeOfProperty'].toString(),
    //                 },
    //                 "loginToken": {"Token": token.toString()}
    //               };
    //               svService.feedback(fReq).then((data) async {
    //                 if (data["Status"]) {
    //                   print("--- FEEDBACK DETAILS ---");
    //
    //                   /// BOUNDARY DETAILS
    //                   List b = await bServices.readSync(propId);
    //                   var request = {
    //                     "boundaryDetails": {
    //                       "PropId": propId.toString(),
    //                       "AsPerSite": {
    //                         "East": b[0]['East'].toString().trim(),
    //                         "West": b[0]['West'].toString().trim(),
    //                         "South": b[0]['South'].toString().trim(),
    //                         "North": b[0]['North'].toString().trim(),
    //                       }
    //                     },
    //                     "loginToken": {"Token": token.toString()}
    //                   };
    //                   svService.boundaryDetails(request).then((data) async {
    //                     if (data["Status"]) {
    //                       print("--- BOUNDARY DETAILS ---");
    //
    //                       /// MEASUREMENT SHEET
    //                       List m = await mServices.readSync(propId);
    //                       var mReq = {
    //                         "measurementSheets": {
    //                           "SheetType": m[0]['SheetType'].toString(),
    //                           "SizeType": m[0]['SizeType'].toString(),
    //                           "PropId": propId.toString(),
    //                           "Sheet": jsonDecode(m[0]['Sheet']),
    //                         },
    //                         "loginToken": {"Token": token.toString()}
    //                       };
    //                       svService.measurementSheet(mReq).then((data) async {
    //                         if (data["Status"]) {
    //                           print("--- MEASUREMENT DETAILS ---");
    //
    //                           /// STAGE CALCULATOR
    //                           List sc = await scService.readSync(propId);
    //                           var scReq = {
    //                             "stageCalculator": {
    //                               "PropId": propId.toString(),
    //                               "CalculatorDetails": {
    //                                 "Id": json.decode(sc[0]['Id']),
    //                                 "MasterId": json.decode(sc[0]['MasterId']),
    //                                 "Progress": json.decode(sc[0]['Progress']),
    //                                 "ProgressPer":
    //                                     json.decode(sc[0]['ProgressPer']),
    //                                 "ProgressPerAsPerPolicy": json.decode(
    //                                     sc[0]['ProgressPerAsPerPolicy']),
    //                                 "Recommended":
    //                                     json.decode(sc[0]['Recommended']),
    //                                 "RecommendedPer":
    //                                     json.decode(sc[0]['RecommendedPer']),
    //                                 "TotalFloor":
    //                                     json.decode(sc[0]['TotalFloor']),
    //                                 "CompletedFloor":
    //                                     json.decode(sc[0]['CompletedFloor'])
    //                               }
    //                             },
    //                             "loginToken": {"Token": token.toString()}
    //                           };
    //                           svService
    //                               .stageCalculator(scReq)
    //                               .then((data) async {
    //                             if (data["Status"]) {
    //                               print("--- STAGE CALCULATOR ---");
    //
    //                               /// CRITICAL COMMENTS
    //                               List cc = await ccService.readSync(propId);
    //                               var ccReq = {
    //                                 "criticalComment": {
    //                                   "PropId": propId.toString(),
    //                                   "Comment": cc[0]['Comment'].toString()
    //                                 },
    //                                 "loginToken": {"Token": token.toString()}
    //                               };
    //                               svService
    //                                   .criticalComment(ccReq)
    //                                   .then((data) async {
    //                                 if (data["Status"]) {
    //                                   print("--- CRITICAL COMMENTS ---");
    //
    //                                   /// LOCATION MAP - UPLOAD SYNC
    //                                   await uploadLocationMap(propId);
    //
    //                                   /// PROPERTY SKETCH - UPLOAD SYNC
    //                                   await uploadPropertySketch(propId);
    //
    //                                   /// PHOTOGRAPH - UPLOAD SYNC
    //                                   await uploadPhotograph(propId);
    //
    //                                   /// SUBMIT PROPERTIES
    //                                   // alertService.hideLoading();
    //                                   var finalReq = {
    //                                     "PropId": propId.toString(),
    //                                     "loginToken": {
    //                                       "Token": token.toString()
    //                                     }
    //                                   };
    //                                   // alertService.hideLoading();
    //                                   // alertService.successToast(Constants.apiSuccessMessage);
    //                                   svService
    //                                       .submitPropertyNew(finalReq)
    //                                       .then((data) async {
    //                                     // Future.delayed(
    //                                     //     const Duration(seconds: 3), () {
    //                                     //   alertService.hideLoading();
    //                                     // });
    //                                     if (data['Status']) {
    //                                       final db = await DatabaseServices
    //                                           .instance.database;
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.propertyList} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.customerBankDetails} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.propertyLocation} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.locationDetails} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.occupancyDetails} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.feedback} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.boundaryDetails} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.measurementSheet} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.stageCalculator} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.criticalComment} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.locationMap} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.propertySketch} WHERE PropId =${propId.toString()}');
    //                                       await db.rawQuery(
    //                                           'DELETE FROM ${Constants.photograph} WHERE PropId =${propId.toString()}');
    //                                       alertService.hideLoading();
    //                                       alertService.successToast(
    //                                           Constants.apiSuccessMessage);
    //                                       function(data['Status']);
    //                                     } else {
    //                                       alertService.hideLoading();
    //                                       alertService.errorToast(
    //                                           Constants.apiErrorMessage);
    //                                     }
    //                                   });
    //                                 } else {
    //                                   alertService.hideLoading();
    //                                   alertService.errorToast(
    //                                       Constants.apiErrorMessage);
    //                                 }
    //                               });
    //                             } else {
    //                               alertService.hideLoading();
    //                               alertService
    //                                   .errorToast(Constants.apiErrorMessage);
    //                             }
    //                           });
    //                         } else {
    //                           alertService.hideLoading();
    //                           alertService
    //                               .errorToast(Constants.apiErrorMessage);
    //                         }
    //                       });
    //                     } else {
    //                       alertService.hideLoading();
    //                       alertService.errorToast(Constants.apiErrorMessage);
    //                     }
    //                   });
    //                 } else {
    //                   alertService.hideLoading();
    //                   alertService.errorToast(Constants.apiErrorMessage);
    //                 }
    //               });
    //             } else {
    //               alertService.hideLoading();
    //               alertService.errorToast(Constants.apiErrorMessage);
    //             }
    //           });
    //         } else {
    //           alertService.hideLoading();
    //           alertService.errorToast(Constants.apiErrorMessage);
    //         }
    //       });
    //     } else {
    //       alertService.hideLoading();
    //       alertService.errorToast(Constants.apiErrorMessage);
    //     }
    //   });
    // } else {
    //   alertService.hideLoading();
    //   alertService.errorToast(Constants.apiErrorMessage);
    // }
  }

  getBase64String(String path) {
    final bytes = File(path.toString()).readAsBytesSync();
    return base64Encode(bytes);
  }

  deleteLiveData(list) {
    BoxStorage secureStorage = BoxStorage();
    SiteVisitService svService = SiteVisitService();

    var token = secureStorage.getLoginToken();
    var request = {
      "photograph": {
        "Id": int.parse(list['Id'].toString()),
        "PropId": list['PropId'].toString()
      },
      "loginToken": {"Token": token.toString()}
    };
    svService.deleteImageNew(request).then((r1) {});
  }

  uploadLocationMap(String propId) async {
    BoxStorage secureStorage = BoxStorage();
    SiteVisitService svService = SiteVisitService();
    UploadLocationMapService locationMapService = UploadLocationMapService();

    var token = secureStorage.getLoginToken();

    /// LOCATION MAP - UPLOAD SYNC
    List lm = await locationMapService.readSync(propId);
    print("LocationMap --- >${lm.length}");
    print("LocationMap --- >${jsonEncode(lm)}");
    for (var i in lm) {
      String path = i['ImagePath'].toString();
      String valid = path == "" ? "" : path;
      String baseString = "";
      if (!Uri.parse(path).isAbsolute && valid != "") {
        baseString = await getBase64String(path);
      }
      var lmReq = {
        "loginToken": {"Token": token.toString()},
        "imageDetails": {
          "PropId": propId.toString(),
          "ImageDesc": i['ImageDesc'].toString().trim(),
          "ImageName": i['ImageName'].toString().trim(),
          "IsResizeImage": true,
          "ImageOrder": i['ImageOrder'].toString().trim(),
          "ImageBase64String": baseString.toString(),
        },
      };
      String id = i['Id'].toString();
      String isActive = i['IsActive'].toString();
      if (id == "0" && isActive == "N") {
        await locationMapService.deleteById(id);
      } else if (id != "0" && isActive == "N") {
        await deleteLiveData(i);
      } else {
        print("LOCATION Request --> ${jsonEncode(lmReq)}");

        svService.locationMap(lmReq).then((data) async {
          print("--- LOCATION MAP UPLOADS ---");
          // await locationMapService.deleteRecord([propId]);
        });
      }
    }
  }

  uploadPropertySketch(String propId) async {
    BoxStorage secureStorage = BoxStorage();
    SiteVisitService svService = SiteVisitService();
    SketchService sketchService = SketchService();
    PhotographService photographService = PhotographService();
    var token = secureStorage.getLoginToken();
    List psListUpload = await sketchService.readSync(propId);
    print("PROPERTY --- >${psListUpload.length}");
    print("PROPERTY --- >${jsonEncode(psListUpload)}");
    try {
      for (var list in psListUpload) {
        String path = list['ImagePath'].toString();
        String valid = path == "" ? "" : path;
        String baseString = "";
        if (!Uri.parse(path).isAbsolute && valid != "") {
          baseString = await getBase64String(path);
        }
        var psReq = {
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
          // await sketchService.updateSyncStatus(["N", id]);
          await sketchService.deleteById(id);
        } else if (id != "0" && isActive == "N") {
          await deleteLiveData(list);
        } else {
          print("PS Request --> ${jsonEncode(psReq)}");

          svService.propertySketch(psReq).then((data) async {
            print("PS Response -> ${jsonEncode(data)}");
          });
        }
      }
    } catch (e) {
      print("PROPERTY SKETCH Error: $e");
    }
  }

  uploadPhotograph(String propId) async {
    BoxStorage secureStorage = BoxStorage();
    SiteVisitService svService = SiteVisitService();
    PhotographService photographService = PhotographService();
    var token = secureStorage.getLoginToken();

    List photo = await photographService.readSync(propId);
    print("photo --- >${photo.length}");
    print("photo --- >${jsonEncode(photo)}");
    try {
      for (var list in photo) {
        String path = list['ImagePath'].toString();
        String valid = path == "" ? "" : path;
        String baseString = "";
        if (!Uri.parse(path).isAbsolute && valid != "") {
          baseString = await getBase64String(path);
        }
        var photoReq = {
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
        String id = list['Id'].toString();
        String isActive = list['IsActive'].toString();
        if (id == "0" && isActive == "N") {
          // await photographService.updateSyncStatus(["N", id]);
          await photographService.deleteById(id);
        } else if (id != "0" && isActive == "N") {
          await deleteLiveData(list);
        } else {
          print("Photograph Request --> ${jsonEncode(photoReq)}");
          svService.photograph(photoReq).then((data) async {
            print("Photograph Response -> ${jsonEncode(data)}");
          });
        }
      }
    } catch (e) {
      print("PHOTOGRAPH Error: $e");
    }
  }
}
