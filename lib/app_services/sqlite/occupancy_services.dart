import '../../app_config/index.dart';
import 'database_service.dart';

class OccupancyServices {
  insert(id, val) async {
    final db = await DatabaseServices.instance.database;
    if (val.isNotEmpty) {
      var propId = id;
      var occupiedBy = val['OccupiedBy'] ?? "";
      var occupiedSince = val['OccupiedSince'] ?? "";
      var relationship = val['RelationshipOfOccupantWithCustomer'] ?? "";
      var statusOfOccupancy = val['StatusOfOccupancy'] ?? "";
      var personMetAtSite = val['PersonMetAtSite'] ?? "";
      var personMetContactNo = val['PersonMetContactNo'] ?? "";
      var syncStatus = "Y";

      await db.transaction((txn) async {
        await txn.rawInsert("""
        INSERT INTO ${Constants.occupancyDetails}
        ( PropId, OccupiedBy, OccupiedSince, RelationshipOfOccupantWithCustomer, StatusOfOccupancy, PersonMetAtSite, PersonMetContactNo, SyncStatus )
        VALUES ( '$propId', '$occupiedBy', '$occupiedSince', '$relationship', '$statusOfOccupancy', '$personMetAtSite', '$personMetContactNo', '$syncStatus' )
        """);
      });
    }
  }
  update(dynamic values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE ${Constants.occupancyDetails} SET OccupiedBy = ?, OccupiedSince = ?, RelationshipOfOccupantWithCustomer = ?, StatusOfOccupancy = ?, PersonMetAtSite = ?, PersonMetAtSiteContNo = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      print("count $count");
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.occupancyDetails} WHERE PropId=$propId");
  }
  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.occupancyDetails} WHERE PropId=$propId AND SyncStatus='N'");
  }
  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.occupancyDetails} SET SyncStatus = ? WHERE PropId = ?", request);
  }
  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.occupancyDetails} WHERE PropId = ?", request);
  }
  readById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.occupancyDetails} WHERE PropId=$id");
  }
}
