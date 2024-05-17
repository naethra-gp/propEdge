import '../../app_config/index.dart';
import 'database_service.dart';

class CommentsServices {
  insert(id, val) async {
    final db = await DatabaseServices.instance.database;
    if (val.isNotEmpty) {
      // await db.rawQuery('DELETE FROM ${Constants.criticalComment}');
      var propId = id;
      var comment = val['Comment'].toString();
      var syncStatus = "Y";

      await db.transaction((txn) async {
        await txn.rawInsert("""
        INSERT INTO ${Constants.criticalComment}
        ( PropId, Comment, SyncStatus )
        VALUES ( '$propId', '$comment', '$syncStatus' )
        """);
      });
    }
  }

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.criticalComment} WHERE PropId=$propId");
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.criticalComment} WHERE PropId=$propId AND SyncStatus='N'");
  }

  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.criticalComment} SET SyncStatus = ? WHERE PropId = ?",
        request);
  }

  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE ${Constants.criticalComment} SET Comment = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }
  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.criticalComment} WHERE PropId = ?", request);
  }
}
