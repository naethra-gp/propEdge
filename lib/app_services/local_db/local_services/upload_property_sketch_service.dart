import '../../../app_config/app_constants.dart';
import '../db/database_services.dart';

class PlanService {
  String table = Constants.propertyPlan;
  // INSERT DATA FROM RESPONSE
  insert(propId1, values) async {
    final db = await DatabaseServices.instance.database;
    if (values.isNotEmpty) {
      values.forEach((val) async {
        var propId = propId1.toString();
        var id = val['Id'];
        var path = val['Path'];
        var name = val['Name'];
        var desc = val['Desc'];
        var imageOrder = val['ImageOrder'];
        var isDeleted = val['IsDeleted'];
        var isActive = "Y";
        var syncStatus = "Y";
        await db.transaction((txn) async {
          await txn.rawInsert("""
        INSERT INTO $table
        (PropId, Id, ImagePath, ImageName, ImageDesc, ImageOrder, IsDeleted, IsActive, SyncStatus)
        VALUES ( '$propId', '$id', '$path', '$name', '$desc', '$imageOrder', '$isDeleted', '$isActive', '$syncStatus' )
        """);
        });
      });
    }
  }

  insertViaApp(val) async {
    final db = await DatabaseServices.instance.database;
    if (val.isNotEmpty) {
      try {
        var propId = val['propId'];
        var id = val['id'];
        var imagePath = val['imagePath'];
        var imageName = val['imageName'];
        var imageDesc = val['imageDesc'];
        var isDeleted = val['isDeleted'];
        var isActive = val['isActive'];
        var syncStatus = "N";
        await db.transaction((txn) async {
          await txn.rawInsert("""
        INSERT INTO $table
        (PropId, Id, ImagePath, ImageName, ImageDesc, IsDeleted, IsActive, SyncStatus)
        VALUES ( '$propId', '$id','$imagePath','$imageName', '$imageDesc', '$isDeleted', '$isActive', '$syncStatus' )
        """);
        });
        return true;
      } catch (e) {
        return "error -> $e";
      }
    }
  }

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db
        .rawQuery("SELECT * FROM $table WHERE PropId=$propId AND IsActive='Y'");
  }

  deleteLocalDb(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("DELETE FROM $table WHERE PropId=$propId");
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM $table WHERE PropId=$propId AND SyncStatus='N'");
  }

  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE $table SET SyncStatus = ? WHERE PropId = ?", request);
  }

  updateIsActive(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE $table SET IsActive = ?, IsDeleted = ?, SyncStatus = ? WHERE primaryId = ?",
        request);
  }

  deleteById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("DELETE FROM $table WHERE primaryId='$id'");
  }

  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete("DELETE FROM $table WHERE PropId = ?", request);
  }
}
