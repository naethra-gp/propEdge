import 'dart:convert';
import 'dart:io';

import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:prop_edge/app_utils/app_widget/row_detail_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_config/app_constants.dart';
import '../../../app_services/local_db/db/database_services.dart';
import '../../../app_services/local_db/local_services/local_services.dart';
import '../../../app_services/site_visit_service.dart';
import '../../../app_storage/secure_storage.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_theme/index.dart';
import '../../../app_utils/alert_service.dart';

class PropertyExpansionWidget extends StatelessWidget {
  final List searchList;
  final Function(bool) onUpload;
  final AlertService alertService = AlertService();
  PropertyExpansionWidget({
    super.key,
    required this.searchList,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ExpansionTileGroup(
        toggleType: ToggleType.expandOnlyCurrent,
        spaceBetweenItem: 8,
        onItemChanged: (index, isExpanded) {},
        children: [
          for (var item in searchList) ...[
            ExpansionTileItem.outlined(
              decoration: CustomTheme.decoration,
              borderRadius: BorderRadius.circular(5.0),
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: getColor(item['Status']),
                ),
                child: Icon(LineAwesome.building, color: Colors.white),
              ),
              title: _buildTitle(item),
              subtitle: _buildSubTitle(item),
              children: [
                RowDetailWidget(
                  title: "Institute Name",
                  value: item['InstituteName'].toString(),
                ),
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
                          String no = item['ContactPersonNumber'].toString();
                          _makePhoneCall(no);
                        },
                        child: Text(
                          maskNumber(item),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
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
                RowDetailWidget(
                  title: "Priority",
                  value: item['Priority'].toString(),
                ),
                CustomTheme.defaultHeight10,
                RowDetailWidget(
                  title: "Date Of Visit",
                  value: item['DateOfVisit'].toString(),
                ),
                CustomTheme.defaultHeight10,
                RowDetailWidget(
                  title: "Address",
                  value: item['Address'].toString(),
                ),
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
                        // ViewSiteVisit
                        onPressed: () {
                          Navigator.pushNamed(
                              context, "view_site_visit_form_data",
                              arguments: item['PropId'].toString());
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
                            // debugPrint(
                            //     "--- Uploading ${item['PropId'].toString()} ---");
                            // uploadLocalToLive(item['PropId'].toString());
                            Navigator.pushNamed(context, "site_visit_form",
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
                        ),
                      ),
                    ],
                    if (item['Status'] == Constants.status[2]) ...[
                      Container(
                        padding: const EdgeInsets.all(7),
                        width: 150.0,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            debugPrint(
                                "--- Uploading ${item['PropId'].toString()} ---");
                            uploadLocalToLive(item['PropId'].toString());
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
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  maskNumber(item) {
    String number = item['ContactPersonNumber'].toString();
    return number.substring(0, 4) + ('*' * (number.length - 4));
  }

  getColor(String status) {
    if (status == Constants.status[0]) {
      return Constants.statusPending; // PENDING
    } else if (status == Constants.status[1]) {
      return Constants.statusProcess; // PROCESS
    } else if (status == Constants.status[2]) {
      return Constants.statusCompleted; // COMPLETED
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  _buildTitle(item) {
    String a = item['ApplicationNumber'].toString();
    String b = item['CustomerName'].toString();
    return Text(
      "$a - $b",
      overflow: TextOverflow.clip,
      style: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  _buildSubTitle(item) {
    String a = item['ColonyName'] == '' ? '' : "${item['ColonyName']},";
    String b = " ${item['LocationName'].toString().trim()}";
    return Text(
      "$a$b",
      overflow: TextOverflow.clip,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12,
        color: Colors.black54,
      ),
    );
  }

  uploadLocalToLive(String propId) async {
    SiteVisitService siteVisitService = SiteVisitService();
    AlertService alertService = AlertService();
    BoxStorage secureStorage = BoxStorage();
    PropertyDetailsServices propertyService = PropertyDetailsServices();
    AreaServices areaService = AreaServices();
    OccupancyServices occupancyService = OccupancyServices();
    BoundaryServices boundaryService = BoundaryServices();
    MeasurementServices measurementServices = MeasurementServices();
    CalculatorService calculatorService = CalculatorService();
    CommentsServices commentsServices = CommentsServices();
    LocationMapService locationMapService = LocationMapService();
    PlanService planService = PlanService();
    PhotographService photographService = PhotographService();

    /// GET TOKEN
    String token = "";
    token = secureStorage.getLoginToken();
    alertService.showLoading('Please wait...');

    /// SAVE PROPERTY DETAILS
    List property = await propertyService.readSync(propId);
    final propertyType = property[0]['PropertyType'];
    bool propertyValid =
        propertyType == '953' || propertyType == '954' || propertyType == '952';

    var propertyParams = {
      "propertyDetails": {
        "PropId": propId,
        "AddressMatching": removeNull(property[0]['AddressMatching']),
        "AgeOfProperty": removeNull(property[0]['AgeOfProperty']),
        "AreaOfProperty": removeNull(property[0]['AreaOfProperty']),
        "BHKConfiguration": convertZero(property[0]['BHKConfiguration']),
        "City": convertZero(property[0]['City']),
        "Colony": removeNull(property[0]['Colony']),
        "ConditionOfProperty": convertZero(property[0]['ConditionOfProperty']),
        "ConstructionOldNew": convertZero(property[0]['ConstructionOldNew']),
        "DeveloperName": removeNull(property[0]['DeveloperName']),
        "Floor": convertZero(property[0]['Floor']),
        "FloorOthers": removeNull(property[0]['FloorOthers']),
        "KitchenAndCupboardsExisting":
            removeNull(property[0]['KitchenAndCupboardsExisting']),
        "KitchenOrPantry": removeNull(property[0]['KitchenOrPantry']),
        "KitchenType": convertZero(property[0]['KitchenType']),
        "LandArea": removeNull(property[0]['LandArea']),
        // "LocalMuniciapalBody": property[0]['LocalMuniciapalBody'],
        "MaintainanceLevel": removeNull(property[0]['MaintainanceLevel']),
        "NameOfMunicipalBody": removeNull(property[0]['NameOfMunicipalBody']),
        "NoOfLifts": removeNull(property[0]['NoOfLifts']),
        "NoOfStaircases": removeNull(property[0]['NoOfStaircases']),
        "Pincode": removeNull(property[0]['Pincode']),
        "PlotAreaMtrs": removeNull(property[0]['PlotAreaMtrs']),
        "PlotAreaSqft": removeNull(property[0]['PlotAreaSqft']),
        "PlotAreaYards": removeNull(property[0]['PlotAreaYards']),
        "PlotUnitType": removeNull(property[0]['PlotUnitType']),
        "ProjectName": removeNull(property[0]['ProjectName']),
        "PropertyAddressAsPerSite":
            removeNull(property[0]['PropertyAddressAsPerSite']),
        "PropertyArea": removeNull(property[0]['PropertyArea']),
        "PropertySubType": convertZero(property[0]['PropertySubType']),
        "PropertyType": convertZero(property[0]['PropertyType']),
        "Region": convertZero(property[0]['Region']),
        "Structure": convertZero(property[0]['Structure']),
        "StructureOthers": removeNull(property[0]['StructureOthers']),
      },
      "loginToken": {"Token": token}
    };
    // print("propertyParams ${jsonEncode(propertyParams)}");
    siteVisitService.savePropertyDetails(propertyParams).then((res1) {
      if (res1['Status'] == true) {
        debugPrint('---> Property Details Saved Successfully. <---');
      }
    });

    /// SAVE AREA DETAILS
    List area = await areaService.readSync(propId);
    var areaParam = {
      "areaDetails": {
        "AnyNegativeToTheLocality":
            removeNull(area[0]['AnyNegativeToTheLocality']),
        "ClassOfLocality": convertZero(area[0]['ClassOfLocality']),
        "ConditionAndWidthOfApproachRoad":
            removeNull(area[0]['ConditionAndWidthOfApproachRoad']),
        "InfrastructureConditionOfNeighboringAreas":
            convertZero(area[0]['InfrastructureConditionOfNeighboringAreas']),
        "InfrastructureOfTheSurroundingArea":
            convertZero(area[0]['InfrastructureOfTheSurroundingArea']),
        "LandUseOfNeighboringAreas":
            convertZero(area[0]['LandUseOfNeighboringAreas']),
        "Latitude": area[0]['Latitude'],
        "Longitude": area[0]['Longitude'],
        "NatureOfLocality": convertZero(area[0]['NatureOfLocality']),
        "NearbyLandmark": removeNull(area[0]['NearbyLandmark']),
        "PropId": propId,
        "PublicTransport": jsonDecode(area[0]['PublicTransport']),
        "SiteAccess": convertZero(area[0]['SiteAccess']),
      },
      "loginToken": {"Token": token}
    };
    siteVisitService.saveAreaDetails(areaParam).then((res1) {
      if (res1['Status'] == true) {
        debugPrint('---> Area Details Saved Successfully. <---');
      }
    });

    /// SAVE OCCUPANCY DETAILS
    List occupancy = await occupancyService.readSync(propId);
    var occupancyParams = {
      "occupancyDetails": {
        "PropId": propId,
        "StatusOfOccupancy":
            convertZero(occupancy[0]['StatusOfOccupancy'].toString()),
        "RelationshipOfOccupantWithCustomer": convertZero(
            occupancy[0]['RelationshipOfOccupantWithCustomer'].toString()),
        "OccupiedSince": removeNull(occupancy[0]['OccupiedSince'].toString()),
        "OccupiedBy": removeNull(occupancy[0]['OccupiedBy'].toString()),
        "OccupantContactNo":
            removeNull(occupancy[0]['OccupantContactNo'].toString()),
        "PersonMetAtSite":
            removeNull(occupancy[0]['PersonMetAtSite'].toString()),
        "PersonMetAtSiteContNo":
            removeNull(occupancy[0]['PersonMetAtSiteContNo'].toString()),
      },
      "loginToken": {"Token": token}
    };
    siteVisitService.saveOccupancyDetails(occupancyParams).then((res1) {
      if (res1['Status'] == true) {
        debugPrint('---> Occupancy Details Saved Successfully. <---');
      }
    });

    /// SAVE Boundary DETAILS
    List boundary = await boundaryService.readSync(propId);
    var boundaryParams = {
      "boundaryDetails": {
        "PropId": propId,
        "AsPerSite": {
          "East": removeNull(boundary[0]['East'].toString()),
          "West": removeNull(boundary[0]['West'].toString()),
          "South": removeNull(boundary[0]['South'].toString()),
          "North": removeNull(boundary[0]['North'].toString()),
        }
      },
      "loginToken": {"Token": token}
    };
    siteVisitService.saveBoundaryDetails(boundaryParams).then((res1) {
      if (res1['Status'] == true) {
        debugPrint('---> Boundary Details Saved Successfully. <---');
      }
    });

    if (propertyValid) {
      /// SAVE MEASUREMENTS DETAILS
      List measurement = await measurementServices.readSync(propId);
      if (measurement.isNotEmpty) {
        var mParam = {
          "measurementSheets": {
            "Sheet": jsonDecode(measurement[0]['Sheet']),
            "SheetType": measurement[0]['SheetType'],
            "SizeType": measurement[0]['SizeType'],
            "PropId": propId
          },
          "loginToken": {"Token": token}
        };
        siteVisitService.saveMeasurementDetails(mParam).then((res1) {
          if (res1['Status'] == true) {
            debugPrint('---> Measurement Details Saved Successfully. <---');
          }
        });
      }

      /// SAVE STAGE CALCULATOR DETAILS
      List calculator = await calculatorService.readSync(propId);
      if (calculator.isNotEmpty) {
        var calParams = {
          "stageCalculator": {
            "PropId": propId,
            "CalculatorDetails": {
              "Id": json.decode(calculator[0]['Id']),
              "MasterId": json.decode(calculator[0]['MasterId']),
              "Progress": json.decode(calculator[0]['Progress']),
              "ProgressPer": json.decode(calculator[0]['ProgressPer']),
              "ProgressPerAsPerPolicy":
                  json.decode(calculator[0]['ProgressPerAsPerPolicy']),
              "Recommended": json.decode(calculator[0]['Recommended']),
              "RecommendedPer": json.decode(calculator[0]['RecommendedPer']),
              "TotalFloor": json.decode(calculator[0]['TotalFloor']),
              "CompletedFloor": json.decode(calculator[0]['CompletedFloor']),
            }
          },
          "loginToken": {"Token": token}
        };
        siteVisitService.saveStageCalculatorDetails(calParams).then((res1) {
          if (res1['Status'] == true) {
            debugPrint('---> Calculator Details Saved Successfully. <---');
          }
        });
      }
    }

    /// SAVE CRITICAL COMMENTS DETAILS
    List comments = await commentsServices.readSync(propId);
    var commentsParams = {
      "criticalComment": {
        "PropId": propId,
        "Comment": removeNull(comments[0]['Comments']),
      },
      "loginToken": {"Token": token}
    };
    siteVisitService.saveCommentsDetails(commentsParams).then((res1) {
      if (res1['Status'] == true) {
        debugPrint('---> Comments Saved Successfully. <---');
      }
    });

    /// SAVE LOCATION MAP DETAILS
    List locationMap = await locationMapService.readSync(propId);
    for (var i in locationMap) {
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
        siteVisitService.saveLocationMapDetails(lmReq).then((data) async {
          debugPrint('---> Location Map Saved Successfully. <---');
        });
      }
    }

    /// SAVE PROPERTY PLAN DETAILS
    List propertyPlan = await planService.readSync(propId);
    for (var list in propertyPlan) {
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
        },
        "loginToken": {"Token": token.toString()}
      };
      // print(psReq);
      String id = list['Id'].toString();
      String isActive = list['IsActive'].toString();
      if (id == "0" && isActive == "N") {
        await planService.deleteById(id);
      } else if (id != "0" && isActive == "N") {
        await deleteLiveData(list);
      } else {
        siteVisitService.savePropertyPlanDetails(psReq).then((data) async {
          debugPrint('---> Property Plan Saved Successfully. <---');
        });
      }
    }

    /// SAVE PHOTOGRAPH DETAILS
    List photograph = await photographService.readSync(propId);
    for (var list in photograph) {
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
          "ImageBase64String": baseString.toString(),
        },
        "loginToken": {"Token": token.toString()},
      };
      String id = list['Id'].toString();
      String isActive = list['IsActive'].toString();
      if (id == "0" && isActive == "N") {
        await photographService.deleteById(id);
      } else if (id != "0" && isActive == "N") {
        await deleteLiveData(list);
      } else {
        siteVisitService.savePhotographDetails(photoReq).then((data) async {
          debugPrint('---> Photograph Saved Successfully. <---');
        });
      }
    }

    /// SUBMIT PROPERTIES
    Future.delayed(const Duration(seconds: 10), () {
      //   var finalReq = {
      //     "PropId": propId.toString(),
      //     "loginToken": {"Token": token.toString()}
      //   };
      //
      deleteLocalData(propId.toString());
      //   siteVisitService.submitProperty(finalReq).then((data) async {
      //     if (data['Status']) {
      //       deleteLocalData(propId.toString());
      //     } else {
      //       alertService.hideLoading();
      //       alertService.errorToast(Constants.apiErrorMessage);
      //     }
      //   });
    });
  }

  deleteLocalData(String propId) async {
    await alertService.showLoading();
    try {
      final db = await DatabaseServices.instance.database;
      await db.rawQuery(
          'DELETE FROM ${Constants.propertyList} WHERE PropId =$propId');
      await db.rawQuery(
          'DELETE FROM ${Constants.customerBankDetails} WHERE PropId =$propId');
      await db.rawQuery(
          'DELETE FROM ${Constants.propertyDetails} WHERE PropId =$propId');
      await db
          .rawQuery('DELETE FROM ${Constants.areaDetails} WHERE PropId =$propId');
      await db.rawQuery(
          'DELETE FROM ${Constants.occupancyDetails} WHERE PropId =$propId');
      await db.rawQuery(
          'DELETE FROM ${Constants.boundaryDetails} WHERE PropId =$propId');
      await db.rawQuery(
          'DELETE FROM ${Constants.measurementSheet} WHERE PropId =$propId');
      await db.rawQuery(
          'DELETE FROM ${Constants.stageCalculator} WHERE PropId =$propId');
      await db.rawQuery(
          'DELETE FROM ${Constants.criticalComment} WHERE PropId =$propId');
      await db
          .rawQuery('DELETE FROM ${Constants.locationMap} WHERE PropId =$propId');
      await db.rawQuery(
          'DELETE FROM ${Constants.propertyPlan} WHERE PropId =$propId');
      await db
          .rawQuery('DELETE FROM ${Constants.photograph} WHERE PropId =$propId');
      await alertService.hideLoading();
      await alertService.successToast(Constants.apiSuccessMessage);
      onUpload(true);
    } catch (e) {
      await alertService.hideLoading();
      await alertService.errorToast('Error deleting local data');
    }
  }

  removeNull(value) {
    if (value == null || value == 'null') {
      return '';
    }
    return value.toString().trim();
  }

  convertZero(value) {
    if (value == null || value == 'null' || value.toString().isEmpty) {
      return '0';
    }
    return value.toString().trim();
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
    // print("Deleted Photos: ${jsonEncode(request)}");
    svService.deleteImageNew(request).then((r1) {});
  }

  getBase64String(String path) {
    final bytes = File(path.toString()).readAsBytesSync();
    return base64Encode(bytes);
  }
}
