import '../../app_config/app_constants.dart';
import 'database_service.dart';

class SketchService {
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
        INSERT INTO ${Constants.propertySketch}
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
        var imageOrder = val['imageOrder'];
        var isDeleted = val['isDeleted'];
        var isActive = val['isActive'];
        var syncStatus = "N";
        await db.transaction((txn) async {
          await txn.rawInsert("""
        INSERT INTO ${Constants.propertySketch}
        (PropId, Id, ImagePath, ImageName, ImageDesc, ImageOrder, IsDeleted, IsActive, SyncStatus)
        VALUES ( '$propId', '$id','$imagePath','$imageName', '$imageDesc', '$imageOrder', '$isDeleted', '$isActive', '$syncStatus' )
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
    return await db.rawQuery(
        "SELECT * FROM ${Constants.propertySketch} WHERE PropId=$propId AND IsActive='Y'");
  }

  deleteLocalDb(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "DELETE FROM ${Constants.propertySketch} WHERE PropId=$propId");
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.propertySketch} WHERE PropId=$propId AND SyncStatus='N'");
  }

  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.propertySketch} SET SyncStatus = ? WHERE PropId = ?",
        request);
  }

  updateIsActive(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.propertySketch} SET IsActive = ?, IsDeleted = ?, SyncStatus = ? WHERE primaryId = ?",
        request);
  }

  deleteById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "DELETE FROM ${Constants.propertySketch} WHERE primaryId='$id'");
  }
  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.propertySketch} WHERE PropId = ?", request);
  }
}
