import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../../app_config/app_constants.dart';
import '../db/database_services.dart';

class LiveToLocalInsert {
  /// INSERT LIVE DATA TO LOCAL SQL DB
  insertAll(String id, data) async {
    final db = await DatabaseServices.instance.database;

    /// CustomerBankDetails - VARIABLES
    var customer = data['CustomerBankDetails'];
    var propId = id.toString();
    var bankName = customer['BankName'] ?? "";
    var branchName = customer['BranchName'] ?? "";
    var contactPersonName = customer['ContactPersonName'] ?? "";
    var contactPersonNumber = customer['ContactPersonNumber'] ?? "";
    var customerName = customer['CustomerName'] ?? "";
    var customerContactNumber = customer['CustomerContactNumber'] ?? "";
    var loanType = customer['LoanType'] ?? "";
    var propertyAddress = customer['PropertyAddress'] ?? "";
    var siteInspectionDate = customer['SiteInspectionDate'] ?? "";
    var syncStatus = "Y";

    /// PropertyDetails - VARIABLES
    var property = data['PropertyDetails'];
    var addressMatching = property['AddressMatching'] ?? "";
    var ageOfProperty = property['AgeOfProperty'] ?? "";
    var areaOfProperty = property['AreaOfProperty'] ?? "";
    var bHKConfiguration = property['BHKConfiguration'] ?? "";
    var city = property['City'] ?? "";
    var colony = property['Colony'] ?? "";
    var conditionOfProperty = property['ConditionOfProperty'] ?? "";
    var constructionOldNew = property['ConstructionOldNew'] ?? "";
    var developerName = property['DeveloperName'] ?? "";
    var floor = property['Floor'] ?? "";
    var floorOthers = property['FloorOthers'] ?? "";
    var kitchenAndCupboardsExisting =
        property['KitchenAndCupboardsExisting'] ?? "";
    var kitchenOrPantry = property['KitchenOrPantry'] ?? "";
    var kitchenType = property['KitchenType'] ?? "";
    var landArea = property['LandArea'] ?? "";
    // var localMuniciapalBody = property['LocalMuniciapalBody'] ?? "";
    var maintainanceLevel = property['MaintainanceLevel'] ?? "";
    var nameOfMunicipalBody = property['NameOfMunicipalBody'] ?? "";
    var noOfLifts = property['NoOfLifts'] ?? "";
    var noOfStaircases = property['NoOfStaircases'] ?? "";
    var pincode = property['Pincode'] ?? "";
    var plotAreaMtrs = property['PlotAreaMtrs'] ?? "";
    var plotAreaSqft = property['PlotAreaSqft'] ?? "";
    var plotAreaYards = property['PlotAreaYards'] ?? "";
    var plotUnitType = property['PlotUnitType'] ?? "";
    var projectName = property['ProjectName'] ?? "";
    var propertyAddressAsPerSite = property['PropertyAddressAsPerSite'] ?? "";
    var propertyArea = property['PropertyArea'] ?? "";
    var propertySubType = property['PropertySubType'] ?? "";
    var propertyType = property['PropertyType'] ?? "";
    var region = property['Region'] ?? "";
    var structure = property['Structure'] ?? "";
    var structureOthers = property['StructureOthers'] ?? "";

    /// AreaDetails - VARIABLES
    var area = data['AreaDetails'];
    var amenties = data['Amenities'] ?? "";
    var anyNegativeToTheLocality = area['AnyNegativeToTheLocality'] ?? "";
    var classOfLocality = area['ClassOfLocality'] ?? "";
    var conditionAndWidthOfApproachRoad =
        area['ConditionAndWidthOfApproachRoad'] ?? "";
    var infrastructureConditionOfNeighboringAreas =
        area['InfrastructureConditionOfNeighboringAreas'] ?? "";
    var infrastructureOfTheSurroundingArea =
        area['InfrastructureOfTheSurroundingArea'] ?? "";
    var landUseOfNeighboringAreas = area['LandUseOfNeighboringAreas'] ?? "";
    var latitude = area['Latitude'] ?? "";
    var longitude = area['Longitude'] ?? "";
    var natureOfLocality = area['NatureOfLocality'] ?? "";
    var nearbyLandmark = area['NearbyLandmark'] ?? "";
    var siteAccess = area['SiteAccess'] ?? "";

    /// OccupancyDetails - VARIABLES
    var occupancy = data['OccupancyDetails'];
    var occupantContactNo = occupancy['OccupantContactNo'] ?? "";
    var occupiedBy = occupancy['OccupiedBy'] ?? "";
    var occupiedSince = occupancy['OccupiedSince'] ?? "";
    var personMetAtSite = occupancy['PersonMetAtSite'] ?? "";
    var personMetAtSiteContNo = occupancy['PersonMetAtSiteContNo'] ?? "";
    var relationship = occupancy['RelationshipOfOccupantWithCustomer'] ?? "";
    var statusOfOccupancy = occupancy['StatusOfOccupancy'] ?? "";

    /// BoundaryDetails - VARIABLES
    var boundary = data['BoundaryDetails']['AsPerSite'];
    var type = "AsPerSite";
    var east = boundary['East'] ?? "";
    var west = boundary['West'] ?? "";
    var south = boundary['South'] ?? "";
    var north = boundary['North'] ?? "";

    // /// MeasurementSheet - VARIABLES
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
    //
    /// CriticalComment - VARIABLES
    var com = data['CriticalComment'];
    var comment = com['Comment'] ?? "";

    await db.transaction((txn) async {
      /// CustomerBankDetails - INSERT QUERY
      debugPrint("--- Insert ${Constants.customerBankDetails} Table ---");
      await txn.rawInsert(
          "INSERT INTO ${Constants.customerBankDetails} (PropId, BankName, BranchName, ContactPersonName, ContactPersonNumber, CustomerName, CustomerContactNumber, LoanType, PropertyAddress, SiteInspectionDate, SyncStatus) VALUES ( ?,?,?,?,?,?,?,?,?,?,?) ",
          [
            propId,
            bankName,
            branchName,
            contactPersonName,
            contactPersonNumber,
            customerName,
            customerContactNumber,
            loanType,
            propertyAddress,
            siteInspectionDate,
            syncStatus
          ]);

      /// PropertyDetails - INSERT QUERY
      debugPrint("--- Insert ${Constants.propertyDetails} Table ---");
      await txn.rawInsert(
          "INSERT INTO ${Constants.propertyDetails} (PropId, AddressMatching, AgeOfProperty, AreaOfProperty, BHKConfiguration, City, Colony, ConditionOfProperty, ConstructionOldNew, DeveloperName, Floor, FloorOthers, KitchenAndCupboardsExisting, KitchenOrPantry, KitchenType, LandArea, MaintainanceLevel, NameOfMunicipalBody, NoOfLifts, NoOfStaircases, Pincode, PlotAreaMtrs, PlotAreaSqft, PlotAreaYards, PlotUnitType, ProjectName, PropertyAddressAsPerSite, PropertyArea, PropertySubType, PropertyType, Region, Structure, StructureOthers, SyncStatus) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          [
            propId,
            addressMatching,
            ageOfProperty,
            areaOfProperty,
            bHKConfiguration,
            city,
            colony,
            conditionOfProperty,
            constructionOldNew,
            developerName,
            floor,
            floorOthers,
            kitchenAndCupboardsExisting,
            kitchenOrPantry,
            kitchenType,
            landArea,
            // localMuniciapalBody,
            maintainanceLevel,
            nameOfMunicipalBody,
            noOfLifts,
            noOfStaircases,
            pincode,
            plotAreaMtrs,
            plotAreaSqft,
            plotAreaYards,
            plotUnitType,
            projectName,
            propertyAddressAsPerSite,
            propertyArea,
            propertySubType,
            propertyType,
            region,
            structure,
            structureOthers,
            syncStatus
          ]);

      /// AreaDetails - INSERT QUERY
      debugPrint("--- Insert ${Constants.areaDetails} Table ---");
      var publicTransportJson = jsonEncode(area['PublicTransport']);
      await txn.rawInsert(
          "INSERT INTO ${Constants.areaDetails} (PropId, Amenities, AnyNegativeToTheLocality, ClassOfLocality, ConditionAndWidthOfApproachRoad, InfrastructureConditionOfNeighboringAreas, InfrastructureOfTheSurroundingArea, LandUseOfNeighboringAreas, Latitude, Longitude, NatureOfLocality, NearbyLandmark, PublicTransport, SiteAccess, SyncStatus )VALUES ( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,? )",
          [
            propId,
            amenties,
            anyNegativeToTheLocality,
            classOfLocality,
            conditionAndWidthOfApproachRoad,
            infrastructureConditionOfNeighboringAreas,
            infrastructureOfTheSurroundingArea,
            landUseOfNeighboringAreas,
            latitude,
            longitude,
            natureOfLocality,
            nearbyLandmark,
            publicTransportJson,
            siteAccess,
            syncStatus
          ]);

      /// OccupancyDetails - INSERT QUERY
      debugPrint("--- Insert ${Constants.occupancyDetails} Table ---");
      await txn.rawInsert(
          "INSERT INTO ${Constants.occupancyDetails} (PropId, OccupantContactNo, OccupiedBy, OccupiedSince, PersonMetAtSite, PersonMetAtSiteContNo, RelationshipOfOccupantWithCustomer, StatusOfOccupancy, SyncStatus) VALUES (?,?,?,?,?,?,?,?,?)",
          [
            propId,
            occupantContactNo,
            occupiedBy,
            occupiedSince,
            personMetAtSite,
            personMetAtSiteContNo,
            relationship,
            statusOfOccupancy,
            syncStatus
          ]);

      /// BoundaryDetails - INSERT QUERY
      debugPrint("--- Insert ${Constants.boundaryDetails} Table ---");
      await txn.rawInsert(
          "INSERT INTO ${Constants.boundaryDetails} (PropId, Type, East, West, South, North, SyncStatus) VALUES (?,?,?,?,?,?,? )",
          [propId, type, east, west, south, north, syncStatus]);

      //   /// MeasurementSheet - INSERT QUERY
      await txn.rawInsert(
          "INSERT INTO ${Constants.measurementSheet} (PropId, SizeType, SheetType, Sheet, SyncStatus ) VALUES ( ?,?,?,?,? )",
          [propId, sizeType, sheetType, sheet, syncStatus]);

      /// StageCalculator - INSERT QUERY
      debugPrint("--- Insert ${Constants.stageCalculator} Table ---");
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
      debugPrint("--- Insert ${Constants.criticalComment} Table ---");
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
          var isDeleted = locationMap[i]['IsDeleted'];
          var isActive = "Y";
          var syncStatus = "Y";
          debugPrint("--- Insert ${Constants.locationMap} Table ---");
          await txn.rawInsert("""INSERT INTO ${Constants.locationMap}
              (PropId, Id, ImagePath, ImageName, ImageDesc, IsDeleted, IsActive, SyncStatus)
              VALUES ('$propId', '$id', '$path', '$name', '$desc', '$isDeleted', '$isActive', '$syncStatus')""");
        }
      } // EOF LocationMap - INSERT QUERY

      /// PropertySketch - INSERT QUERY
      List psList = data['PropertySketch'];
      if (psList.isNotEmpty) {
        for (int i = 0; i < psList.length; i++) {
          var id = psList[i]['Id'];
          var path = psList[i]['Path'];
          var name = psList[i]['Name'];
          var desc = psList[i]['Desc'];
          var isDeleted = psList[i]['IsDeleted'];
          var isActive = "Y";
          var syncStatus = "Y";
          debugPrint("--- Insert ${Constants.propertyPlan} Table ---");
          await txn.rawInsert("""INSERT INTO ${Constants.propertyPlan}
              (PropId, Id, ImagePath, ImageName, ImageDesc, IsDeleted, IsActive, SyncStatus)
              VALUES ('$propId', '$id', '$path', '$name', '$desc', '$isDeleted', '$isActive', '$syncStatus')""");
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
          var isDeleted = photoList[i]['IsDeleted'];
          var isActive = "Y";
          var syncStatus = "Y";
          debugPrint("--- Insert ${Constants.photograph} Table ---");
          await txn.rawInsert("""INSERT INTO ${Constants.photograph}
              (PropId, Id, ImagePath, ImageName, ImageDesc, IsDeleted, IsActive, SyncStatus)
              VALUES ('$propId', '$id', '$path', '$name', '$desc', '$isDeleted', '$isActive', '$syncStatus')""");
        }
      } // EOF Photographs - INSERT QUERY
    });
  }
}
