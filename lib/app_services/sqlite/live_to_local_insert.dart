import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'database_service.dart';
import '../../app_config/app_constants.dart';

class LiveToLocalInsert {
  /// INSERT LIVE DATA TO LOCAL SQL DB
  insertAll(String id, data) async {
    final db = await DatabaseServices.instance.database;

    /// CustomerBankDetails - VARIABLES
    var customer = data['CustomerBankDetails'];
    var propId = id.toString();
    var bankName = customer['BankName'] ?? "";
    var contactPersonName = customer['ContactPersonName'] ?? "";
    var contactPersonNumber = customer['ContactPersonNumber'] ?? "";
    var customerName = customer['CustomerName'] ?? "";
    var loanType = customer['LoanType'] ?? "";
    var propertyAddress = customer['PropertyAddress'] ?? "";
    var siteInspectionDate = customer['SiteInspectionDate'] ?? "";
    var syncStatus = "Y";

    /// PropertyLocationDetails - VARIABLES
    var property = data['PropertyLocationDetails'];
    var city = property['City'] ?? "";
    var colony = property['Colony'] ?? "";
    var propertyAddressAsPerSite = property['PropertyAddressAsPerSite'] ?? "";
    var addressMatching = property['AddressMatching'] ?? "";
    var localMunicipalBody = property['LocalMuniciapalBody'] ?? "";
    var propertyType = property['PropertyType'] ?? "";
    var totalFloors = property['TotalFloors'] ?? "";
    var nameOfMunicipalBody = property['NameOfMunicipalBody'] ?? "";

    /// LocationDetails - VARIABLES
    var location = data['LocationDetails'];
    var anyNegativeToTheLocality = location['AnyNegativeToTheLocality'] ?? "";
    var classOfLocality = location['ClassOfLocality'] ?? "";
    var conditionAndWidthOfApproachRoad =
        location['ConditionAndWidthOfApproachRoad'] ?? "";
    var infrastructureOfTheSurroundingArea =
        location['InfrastructureOfTheSurroundingArea'] ?? "";
    var latitude = location['Latitude'] ?? "";
    var longitude = location['Longitude'] ?? "";
    var microMarket = location['Micromarket'] ?? "";
    var natureOfLocality = location['NatureOfLocality'] ?? "";
    var nearbyLandmark = location['NearbyLandmark'] ?? "";
    var nearestBusStop = location['NearestBusStop'] ?? "";
    var nearestHospital = location['NearestHospital'] ?? "";
    var nearestMetroStation = location['NearestMetroStation'] ?? "";
    var nearestRailwayStation = location['NearestRailwayStation'] ?? "";
    var neighborhoodType = location['NeighborhoodType'] ?? "";
    var proximityFromCivicsAmenities =
        location['ProximityFromCivicsAmenities'] ?? "";
    var siteAccess = location['SiteAccess'] ?? "";

    /// OccupancyDetails - VARIABLES
    var occupancy = data['OccupancyDetails'];
    var occupiedBy = occupancy['OccupiedBy'] ?? "";
    var occupiedSince = occupancy['OccupiedSince'] ?? "";
    var relationship = occupancy['RelationshipOfOccupantWithCustomer'] ?? "";
    var statusOfOccupancy = occupancy['StatusOfOccupancy'] ?? "";
    var personMetAtSite = occupancy['PersonMetAtSite'] ?? "";
    var personMetAtSiteContNo = occupancy['PersonMetAtSiteContNo'] ?? "";

    /// Feedback - VARIABLES
    var feedback = data['Feedback'];
    var amenities = feedback['Amenities'] ?? "";
    var approxAgeOfProperty = feedback['ApproxAgeOfProperty'] ?? "";
    var maintenanceLevel = feedback['MaintainanceLevel'] ?? "";

    /// BoundaryDetails - VARIABLES
    var boundary = data['BoundaryDetails']['AsPerSite'];
    var type = "AsPerSite";
    var east = boundary['East'] ?? "";
    var west = boundary['West'] ?? "";
    var south = boundary['South'] ?? "";
    var north = boundary['North'] ?? "";

    /// MeasurementSheet - VARIABLES
    var measurement = data['MeasurementSheet'];
    var sizeType = measurement['SizeType'] ?? "";
    var sheetType = measurement['SheetType'] ?? "";
    var sheet = json.encode(measurement['Sheet']);

    /// StageCalculator - VARIABLES
    var calculator = data['StageCalculator']['CalculatorDetails'];
    var ids = jsonEncode(calculator['Id']);
    var masterId = jsonEncode(calculator['MasterId']);
    var heads = jsonEncode(calculator['Heads']);
    var progress = jsonEncode(calculator['Progress']);
    var recommended = jsonEncode(calculator['Recommended']);
    var totalFloor = jsonEncode(calculator['TotalFloor']);
    var completedFloor = jsonEncode(calculator['CompletedFloor']);
    var progressPer = jsonEncode(calculator['ProgressPer']);
    var recommendedPer = jsonEncode(calculator['RecommendedPer']);
    var progressPerAsPerPolicy =
        jsonEncode(calculator['ProgressPerAsPerPolicy']);
    var recommendedPerAsPerPolicy =
        jsonEncode(calculator['RecommendedPerAsPerPolicy']);

    /// CriticalComment - VARIABLES
    var com = data['CriticalComment'];
    var comment = com['Comment'] ?? "";

    await db.transaction((txn) async {
      /// CustomerBankDetails - INSERT QUERY
      debugPrint("--- Insert CustomerBankDetails Table ---");
      await txn.rawInsert(
          "INSERT INTO ${Constants.customerBankDetails} (PropId, BankName, ContactPersonName, ContactPersonNumber, CustomerName, LoanType, PropertyAddress, SiteInspectionDate, SyncStatus) VALUES ( ?,?,?,?,?,?,?,?,?) ",
          [
            propId,
            bankName,
            contactPersonName,
            contactPersonNumber,
            customerName,
            loanType,
            propertyAddress,
            siteInspectionDate,
            syncStatus
          ]);

      /// PropertyLocationDetails - INSERT QUERY
      await txn.rawInsert(
          "INSERT INTO ${Constants.propertyLocation} (PropId, City, Colony, PropertyAddressAsPerSite, AddressMatching, LocalMuniciapalBody, NameOfMunicipalBody, PropertyType, TotalFloors, SyncStatus) VALUES (?,?,?,?,?,?,?,?,?,?)",
          [
            propId,
            city,
            colony,
            propertyAddressAsPerSite,
            addressMatching,
            localMunicipalBody,
            nameOfMunicipalBody,
            propertyType,
            totalFloors,
            syncStatus
          ]);

      /// LocationDetails - INSERT QUERY
      await txn.rawInsert(
          "INSERT INTO ${Constants.locationDetails} (PropId, AnyNegativeToTheLocality, ClassOfLocality, ConditionAndWidthOfApproachRoad, InfrastructureOfTheSurroundingArea, Latitude, Longitude, Micromarket, NatureOfLocality, NearbyLandmark, NearestBusStop, NearestHospital, NearestMetroStation, NearestRailwayStation, NeighborhoodType, ProximityFromCivicsAmenities, SiteAccess, SyncStatus )VALUES ( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? )",
          [
            propId,
            anyNegativeToTheLocality,
            classOfLocality,
            conditionAndWidthOfApproachRoad,
            infrastructureOfTheSurroundingArea,
            latitude,
            longitude,
            microMarket,
            natureOfLocality,
            nearbyLandmark,
            nearestBusStop,
            nearestHospital,
            nearestMetroStation,
            nearestRailwayStation,
            neighborhoodType,
            proximityFromCivicsAmenities,
            siteAccess,
            syncStatus
          ]);

      /// OccupancyDetails - INSERT QUERY
      await txn.rawInsert(
          "INSERT INTO ${Constants.occupancyDetails} (PropId, OccupiedBy, OccupiedSince, RelationshipOfOccupantWithCustomer, StatusOfOccupancy, PersonMetAtSite, PersonMetAtSiteContNo, SyncStatus ) VALUES (?,?,?,?,?,?,?,?)",
          [
            propId,
            occupiedBy,
            occupiedSince,
            relationship,
            statusOfOccupancy,
            personMetAtSite,
            personMetAtSiteContNo,
            syncStatus
          ]);

      /// Feedback - INSERT QUERY
      await txn.rawInsert(
          "INSERT INTO ${Constants.feedback} (PropId, Amenities, ApproxAgeOfProperty, MaintainanceLevel, SyncStatus ) VALUES (?,?,?,?,? )",
          [
            propId,
            amenities,
            approxAgeOfProperty,
            maintenanceLevel,
            syncStatus
          ]);

      /// BoundaryDetails - INSERT QUERY
      await txn.rawInsert(
          "INSERT INTO ${Constants.boundaryDetails} (PropId, Type, East, West, South, North, SyncStatus) VALUES (?,?,?,?,?,?,? )",
          [propId, type, east, west, south, north, syncStatus]);

      /// MeasurementSheet - INSERT QUERY
      await txn.rawInsert(
          "INSERT INTO ${Constants.measurementSheet} (PropId, SizeType, SheetType, Sheet, SyncStatus ) VALUES ( ?,?,?,?,? )",
          [propId, sizeType, sheetType, sheet, syncStatus]);

      /// StageCalculator - INSERT QUERY
      await txn.rawInsert(
          "INSERT INTO ${Constants.stageCalculator} (PropId, Id, MasterId, Heads, Progress, Recommended, TotalFloor, CompletedFloor, ProgressPer, RecommendedPer, ProgressPerAsPerPolicy, RecommendedPerAsPerPolicy, SyncStatus ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)",
          [
            propId,
            ids,
            masterId,
            heads,
            progress,
            recommended,
            totalFloor,
            completedFloor,
            progressPer,
            recommendedPer,
            progressPerAsPerPolicy,
            recommendedPerAsPerPolicy,
            syncStatus
          ]);

      /// CriticalComment - INSERT QUERY
      await txn.rawInsert(
          "INSERT INTO ${Constants.criticalComment} (PropId, Comment, SyncStatus) VALUES (?,?,?)",
          [propId, comment, syncStatus]);

      /// LocationMap - INSERT QUERY
      List locationMap = data['LocationMap'];
      if (locationMap.isNotEmpty) {
        for (int i = 0; i < locationMap.length; i++) {
          var id = locationMap[i]['Id'];
          var path = locationMap[i]['Path'];
          var name = locationMap[i]['Name'];
          var desc = locationMap[i]['Desc'];
          var imageOrder = locationMap[i]['ImageOrder'];
          var isDeleted = locationMap[i]['IsDeleted'];
          var isActive = "Y";
          var syncStatus = "Y";
          await txn.rawInsert("""INSERT INTO ${Constants.locationMap}
            (PropId, Id, ImagePath, ImageName, ImageDesc, ImageOrder, IsDeleted, IsActive, SyncStatus)
            VALUES ('$propId', '$id', '$path', '$name', '$desc', '$imageOrder', '$isDeleted', '$isActive', '$syncStatus')""");
        }
      } // EOF LocationMap - INSERT QUERY

      /// PropertySketch - INSERT QUERY
      List psList = data['PropertySketch'];
      // print("propertySketch ---> $psList");
      if (psList.isNotEmpty) {
        for (int i = 0; i < psList.length; i++) {
          var id = psList[i]['Id'];
          var path = psList[i]['Path'];
          var name = psList[i]['Name'];
          var desc = psList[i]['Desc'];
          var imageOrder = psList[i]['ImageOrder'];
          var isDeleted = psList[i]['IsDeleted'];
          var isActive = "Y";
          var syncStatus = "Y";
          await txn.rawInsert("""INSERT INTO ${Constants.propertySketch}
            (PropId, Id, ImagePath, ImageName, ImageDesc, ImageOrder, IsDeleted, IsActive, SyncStatus)
            VALUES ('$propId', '$id', '$path', '$name', '$desc', '$imageOrder', '$isDeleted', '$isActive', '$syncStatus')""");
        }
      } // EOF PropertySketch - INSERT QUERY

      /// Photographs - INSERT QUERY
      List photoList = data['Photographs'];
      if (photoList.isNotEmpty) {
        for (int i = 0; i < photoList.length; i++) {
          var id = photoList[i]['Id'];
          var path = photoList[i]['Path'];
          var name = photoList[i]['Name'];
          var desc = photoList[i]['Desc'];
          var imageOrder = photoList[i]['ImageOrder'];
          var isDeleted = photoList[i]['IsDeleted'];
          var isActive = "Y";
          var syncStatus = "Y";
          await txn.rawInsert("""INSERT INTO ${Constants.photograph}
            (PropId, Id, ImagePath, ImageName, ImageDesc, ImageOrder, IsDeleted, IsActive, SyncStatus)
            VALUES ('$propId', '$id', '$path', '$name', '$desc', '$imageOrder', '$isDeleted', '$isActive', '$syncStatus')""");
        }
      } // EOF Photographs - INSERT QUERY
    });
  }
}
