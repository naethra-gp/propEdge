import '../../../app_config/app_constants.dart';
import '../db/database_services.dart';

class OccupancyServices {
  String table = Constants.occupancyDetails;

  update(dynamic values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE $table SET OccupantContactNo = ?, OccupiedBy = ?, OccupiedSince = ?, PersonMetAtSite = ?, PersonMetAtSiteContNo = ?, RelationshipOfOccupantWithCustomer = ?, StatusOfOccupancy = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM $table WHERE PropId=$propId");
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
      "SELECT * FROM $table WHERE PropId=$propId AND SyncStatus='N'",
    );
  }

  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
      "UPDATE $table SET SyncStatus = ? WHERE PropId = ?",
      request,
    );
  }

  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete("DELETE FROM $table WHERE PropId = ?", request);
  }
}
