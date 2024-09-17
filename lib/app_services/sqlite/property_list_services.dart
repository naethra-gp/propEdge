import '../../app_config/index.dart';
import 'database_service.dart';

class PropertyListServices {

  insert(values) async {
    final db = await DatabaseServices.instance.database;
    // await db.rawQuery('DELETE FROM ${Constants.propertyList}');
    values.forEach((val) async {
      var propId = val['PropId'];
      var address = val['Address'];
      var applicationNumber = val['ApplicationNumber'];
      var contactPersonName = val['ContactPersonName'];
      var contactPersonNumber = val['ContactPersonNumber'];
      var customerName = val['CustomerName'];
      var dateOfVisit = val['DateOfVisit'];
      var instituteName = val['InstituteName'];
      var locationName = val['LocationName'];
      var colonyName = val['ColonyName'];
      var priority = val['Priority'];
      String status = Constants.status[0].toString();
      var specialInstruction = val['SpecialInstruction'];
      var syncStatus = "Y";
      await db.transaction((txn) async {
        await txn.rawInsert('INSERT INTO ${Constants.propertyList} ( PropId, Address, ApplicationNumber, ContactPersonName, ContactPersonNumber, CustomerName, DateOfVisit, InstituteName, LocationName, ColonyName, Priority, Status, SpecialInstruction, SyncStatus ) VALUES ( ?,?,?,?,?,?,?,?,?,?,?,?,?,? ) ', [propId, address,applicationNumber, contactPersonName, contactPersonNumber, customerName, dateOfVisit, instituteName, locationName,colonyName, priority,status, specialInstruction, syncStatus]);
      });
    });
  }
  updateLocalStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    // return await db.rawUpdate(
    //     "UPDATE ${Constants.propertyList} SET Status = ? WHERE PropId = ?", request);
    try {
      int count = await db.rawUpdate("UPDATE ${Constants.propertyList} SET Status = ?, SyncStatus = ? WHERE PropId = ?", request);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }

  read() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.propertyList}");
  }
  readBySync() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.propertyList} WHERE SyncStatus = 'N'");
  }
  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.propertyList} WHERE Status =? AND PropId = ?", request);
  }
  deleteByPropId(String table, List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM $table WHERE PropId = ?", request);
  }
}