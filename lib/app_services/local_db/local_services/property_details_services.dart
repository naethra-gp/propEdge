import 'package:flutter/material.dart';

import '../../../app_config/app_constants.dart';
import '../db/database_services.dart';

class PropertyDetailsServices {
  String table = Constants.propertyDetails;
  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE $table SET '
          'AddressMatching = ?, AgeOfProperty = ?, AreaOfProperty = ?, '
          'BHKConfiguration = ?, City = ?, Colony = ?, '
          'ConditionOfProperty = ?, ConstructionOldNew = ?, DeveloperName = ?, '
          'Floor = ?, FloorOthers = ?, KitchenAndCupboardsExisting = ?, '
          'KitchenOrPantry = ?, KitchenType = ?, LandArea = ?, '
          'MaintainanceLevel = ?, NameOfMunicipalBody = ?, '
          'NoOfLifts = ?, NoOfStaircases = ?, Pincode = ?, '
          'PlotAreaMtrs = ?, PlotAreaSqft = ?, PlotAreaYards = ?, '
          'PlotUnitType = ?, ProjectName = ?, PropertyAddressAsPerSite = ?, '
          'PropertyArea = ?, PropertySubType = ?, PropertyType = ?, '
          'Region = ?, Structure = ?, StructureOthers = ?, '
          'SyncStatus = ? '
          'WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    } finally {
      debugPrint("--- Updated Done ---");
    }
  }

  getPropertyLocation(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM $table WHERE PropId=$propId");
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM $table WHERE PropId=$propId AND SyncStatus='N'");
  }

  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE $table SET SyncStatus = ? WHERE PropId = ?", request);
  }

  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete("DELETE FROM $table WHERE PropId = ?", request);
  }

  readById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM $table WHERE PropId=$id");
  }

  deleteByPropId(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete("DELETE FROM $table WHERE PropId = ?", request);
  }
}
