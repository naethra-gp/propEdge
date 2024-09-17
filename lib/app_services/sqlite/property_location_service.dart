import '../../app_config/index.dart';
import 'database_service.dart';

class PropertyLocationServices {
  insert(id, val) async {
    final db = await DatabaseServices.instance.database;
    // print("propertyType --- $val");
    if (val.isNotEmpty) {
      // await db.rawQuery('DELETE FROM ${Constants.propertyLocation}');
      var propId = id;
      var city = val['City'];
      var colony = val['Colony'];
      var propertyAddressAsPerSite = val['PropertyAddressAsPerSite'];
      var addressMatching = val['AddressMatching'];
      var localMuniciapalBody = val['LocalMuniciapalBody'];
      var nameOfMunicipalBody = val['NameOfMunicipalBody'];
      var propertyType = val['PropertyType'];
      // print("propertyType --- $propertyType");
      var floor = val['TotalFloors'];
      var syncStatus = "Y";
      await db.transaction((txn) async {
        await txn.rawInsert("""
        INSERT INTO ${Constants.propertyLocation}
        ( PropId, City, Colony, PropertyAddressAsPerSite, AddressMatching, LocalMuniciapalBody, NameOfMunicipalBody, PropertyType, TotalFloors, SyncStatus )
        VALUES ( '$propId', '$city', '$colony', '$propertyAddressAsPerSite', '$addressMatching',
         '$localMuniciapalBody', '$nameOfMunicipalBody', '$propertyType', '$floor', '$syncStatus' )
        """);
      });
    }
  }
  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE ${Constants.propertyLocation} SET City = ?, Colony = ?, PropertyAddressAsPerSite = ?, AddressMatching = ?, LocalMuniciapalBody = ?, NameOfMunicipalBody = ?, PropertyType = ?, TotalFloors = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      // AlertService().successToast("error -> $e");
      return "error -> $e";
    }
  }

  getPropertyLocation(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.propertyLocation} WHERE PropId=$propId");
  }
  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.propertyLocation} WHERE PropId=$propId AND SyncStatus='N'");
  }

  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.propertyLocation} SET SyncStatus = ? WHERE PropId = ?", request);
  }

  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.propertyLocation} WHERE PropId = ?", request);
  }
  readById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.propertyLocation} WHERE PropId=$id");
  }
  deleteByPropId(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.propertyLocation} WHERE PropId = ?", request);
  }
}
