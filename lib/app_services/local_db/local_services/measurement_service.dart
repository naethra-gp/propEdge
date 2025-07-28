import '../../../app_config/app_constants.dart';
import '../db/database_services.dart';

class MeasurementServices {
  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.measurementSheet} WHERE PropId=$propId");
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
      // print(count);
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
    return await db.rawQuery(
        "SELECT * FROM ${Constants.measurementSheet} WHERE PropId=$id");
  }
}
