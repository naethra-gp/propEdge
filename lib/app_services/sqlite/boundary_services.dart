import '../../app_config/index.dart';
import 'database_service.dart';

class BoundaryServices {
  insert(id, val) async {
    final db = await DatabaseServices.instance.database;
    val = val['AsPerSite'];
    if (val.isNotEmpty) {
      // await db.rawQuery('DELETE FROM ${Constants.boundaryDetails}');
      var propId = id;
      var type = "AsPerSite";
      var east = val['East'] ?? "";
      var west = val['West'] ?? "";
      var south = val['South'] ?? "";
      var north = val['North'] ?? "";
      var syncStatus = "Y";
      await db.transaction((txn) async {
        await txn.rawInsert("""
        INSERT INTO ${Constants.boundaryDetails}
        ( PropId, Type, East, West, South, North, SyncStatus )
        VALUES ( '$propId', '$type', '$east', '$west', '$south', '$north', '$syncStatus' )
        """);
      });
    }
  }

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.boundaryDetails} WHERE PropId=$propId");
  }

  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE ${Constants.boundaryDetails} SET Type = ?, East = ?, West = ?, South = ?, North = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.boundaryDetails} WHERE PropId=$propId AND SyncStatus='N'");
  }
  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.boundaryDetails} SET SyncStatus = ? WHERE PropId = ?", request);
  }
  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.boundaryDetails} WHERE PropId = ?", request);
  }
  readById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.boundaryDetails} WHERE PropId=$id");
  }

  deleteByPropId(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.boundaryDetails} WHERE PropId = ?", request);
  }
}
