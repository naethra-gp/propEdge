import '../../../app_config/app_constants.dart';
import '../db/database_services.dart';

class CalculatorService {
  String table = Constants.stageCalculator;
  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM $table WHERE PropId=$propId");
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM $table WHERE PropId=$propId AND SyncStatus='N'");
  }

  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE $table SET Progress = ?, Recommended = ?, TotalFloor = ?, CompletedFloor = ?, ProgressPer = ?, RecommendedPer = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }
}
