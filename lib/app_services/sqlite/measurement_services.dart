import 'dart:convert';

import '../../app_config/index.dart';
import 'database_service.dart';

class MeasurementServices {
  insert(id, val) async {
    final db = await DatabaseServices.instance.database;
    if (val.isNotEmpty) {
      // await db.rawQuery('DELETE FROM ${Constants.measurementSheet}');
      var propId = id;
      var sizeType = val['SizeType'];
      var sheetType = val['SheetType'];
      var sheet = json.encode(val['Sheet']);
      var syncStatus = "Y";

      await db.transaction((txn) async {
        await txn.rawInsert("""
        INSERT INTO ${Constants.measurementSheet}
        ( PropId, SizeType, SheetType, Sheet, SyncStatus )
        VALUES ( '$propId', '$sizeType', '$sheetType', '$sheet', '$syncStatus' )
        """);
      });
    }
  }

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db
        .rawQuery("SELECT * FROM ${Constants.measurementSheet} WHERE PropId=$propId");
  }
  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.measurementSheet} WHERE PropId=$propId AND SyncStatus='N'");
  }

  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.measurementSheet} SET SyncStatus = ? WHERE PropId = ?",
        request);
  }
  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE ${Constants.measurementSheet} SET SizeType = ?, SheetType = ?, Sheet = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }
  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.measurementSheet} WHERE PropId = ?", request);
  }
  readById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.measurementSheet} WHERE PropId=$id");
  }
}