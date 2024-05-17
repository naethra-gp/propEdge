import '../../app_config/index.dart';
import 'database_service.dart';

class LocationDetailServices {
  insert(id, val) async {
    final db = await DatabaseServices.instance.database;
    if (val.isNotEmpty) {
      // await db.rawQuery('DELETE FROM ${Constants.locationDetails}');
      var propId = id;
      var anyNegativeToTheLocality = val['AnyNegativeToTheLocality'];
      var classOfLocality = val['ClassOfLocality'];
      var conditionAndWidthOfApproachRoad =
          val['ConditionAndWidthOfApproachRoad'];
      var infrastructureOfTheSurroundingArea =
          val['InfrastructureOfTheSurroundingArea'];
      var latitude = val['Latitude'];
      var longitude = val['Longitude'];
      var micromarket = val['Micromarket'];
      var natureOfLocality = val['NatureOfLocality'];
      var nearbyLandmark = val['NearbyLandmark'];
      var nearestBusStop = val['NearestBusStop'];
      var nearestHospital = val['NearestHospital'];
      var nearestMetroStation = val['NearestMetroStation'];
      var nearestRailwayStation = val['NearestRailwayStation'];
      var neighborhoodType = val['NeighborhoodType'];
      var proximityFromCivicsAmenities = val['ProximityFromCivicsAmenities'];
      var siteAccess = val['SiteAccess'];
      var syncStatus = "Y";
      await db.transaction((txn) async {
        await txn.rawInsert("""
        INSERT INTO ${Constants.locationDetails}
        ( PropId, AnyNegativeToTheLocality, ClassOfLocality, ConditionAndWidthOfApproachRoad, InfrastructureOfTheSurroundingArea,
        Latitude, Longitude, Micromarket, NatureOfLocality, NearbyLandmark, 
        NearestBusStop, NearestHospital, NearestMetroStation, NearestRailwayStation, NeighborhoodType, ProximityFromCivicsAmenities,
        SiteAccess, SyncStatus )
        VALUES ( '$propId', '$anyNegativeToTheLocality', '$classOfLocality', '$conditionAndWidthOfApproachRoad', '$infrastructureOfTheSurroundingArea',
         '$latitude', '$longitude', '$micromarket','$natureOfLocality', '$nearbyLandmark',
         '$nearestBusStop', '$nearestHospital','$nearestMetroStation','$nearestRailwayStation', '$neighborhoodType', '$proximityFromCivicsAmenities', 
         '$siteAccess', '$syncStatus' )
        """);
      });
    }
  }

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.locationDetails} WHERE PropId=$propId ");
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.locationDetails} WHERE PropId=$propId AND SyncStatus='N'");
  }
  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.locationDetails} SET SyncStatus = ? WHERE PropId = ?", request);
  }
  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE ${Constants.locationDetails} SET NearbyLandmark = ?, Micromarket = ?, Latitude = ?, Longitude = ?, InfrastructureOfTheSurroundingArea = ?, NatureOfLocality = ?, ClassOfLocality = ?, ProximityFromCivicsAmenities = ?, NearestRailwayStation = ?, NearestMetroStation = ?, NearestBusStop = ?, ConditionAndWidthOfApproachRoad = ?, SiteAccess = ?, NeighborhoodType = ?, NearestHospital = ?, AnyNegativeToTheLocality = ?,  SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }
  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.locationDetails} WHERE PropId = ?", request);
  }
  readById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.locationDetails} WHERE PropId=$id");
  }
}
