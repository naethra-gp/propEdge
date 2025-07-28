import 'package:prop_edge/app_config/app_constants.dart';

import '../db/database_services.dart';

class AreaServices {
  String table = Constants.areaDetails;

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM $table WHERE PropId=$propId");
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM $table WHERE PropId=$propId AND SyncStatus='N'");
  }

  updateLocalSync(List request) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          "UPDATE ${Constants.areaDetails} SET Latitude = ?, Longitude = ?, NearbyLandmark = ?, LandUseOfNeighboringAreas = ?, InfrastructureConditionOfNeighboringAreas = ?, InfrastructureOfTheSurroundingArea = ?, NatureOfLocality = ?, ClassOfLocality = ?, Amenities = ?, PublicTransport = ?, SiteAccess = ?, ConditionAndWidthOfApproachRoad = ?, AnyNegativeToTheLocality = ?, SyncStatus = ? WHERE PropId = ?",
          request);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }
}
