import '../../app_config/index.dart';
import 'database_service.dart';

class FeedbackServices {
  insert(id, val) async {
    final db = await DatabaseServices.instance.database;
    if (val.isNotEmpty) {
      // await db.rawQuery('DELETE FROM ${Constants.feedback}');
      var propId = id;
      var amenities = val['Amenities'];
      var approxAgeOfProperty = val['ApproxAgeOfProperty'];
      var maintainanceLevel = val['MaintainanceLevel'];
      var syncStatus = "Y";

      await db.transaction((txn) async {
        await txn.rawInsert("""
        INSERT INTO ${Constants.feedback}
        ( PropId, Amenities, ApproxAgeOfProperty, MaintainanceLevel, SyncStatus )
        VALUES ( '$propId', '$amenities', '$approxAgeOfProperty', '$maintainanceLevel', '$syncStatus' )
        """);
      });
    }
  }

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db
        .rawQuery("SELECT * FROM ${Constants.feedback} WHERE PropId=$propId");
  }
  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.feedback} WHERE PropId=$propId AND SyncStatus='N'");
  }
  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.feedback} SET SyncStatus = ? WHERE PropId = ?", request);
  }
  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE ${Constants.feedback} SET Amenities = ?, ApproxAgeOfProperty = ?, MaintainanceLevel = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }
  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.feedback} WHERE PropId = ?", request);
  }
  readById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.feedback} WHERE PropId=$id");
  }
}
