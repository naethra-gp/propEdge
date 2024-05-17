import '../../app_config/index.dart';
import 'database_service.dart';

class PropertyLocationServices {
  insert(id, val) async {
    final db = await DatabaseServices.instance.database;
    if (val.isNotEmpty) {
      // await db.rawQuery('DELETE FROM ${Constants.propertyLocation}');
      var propId = id;
      var city = val['City'];
      var colony = val['Colony'];
      var propertyAddressAsPerSite = val['PropertyAddressAsPerSite'];
      var addressMatching = val['AddressMatching'];
      var localMuniciapalBody = val['LocalMuniciapalBody'];
      var nameOfMunicipalBody = val['NameOfMunicipalBody'];
      var syncStatus = "Y";
      await db.transaction((txn) async {
        await txn.rawInsert("""
        INSERT INTO ${Constants.propertyLocation}
        ( PropId, City, Colony, PropertyAddressAsPerSite, AddressMatching, LocalMuniciapalBody, NameOfMunicipalBody, SyncStatus )
        VALUES ( '$propId', '$city', '$colony', '$propertyAddressAsPerSite', '$addressMatching',
         '$localMuniciapalBody', '$nameOfMunicipalBody', '$syncStatus' )
        """);
      });
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

  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE ${Constants.propertyLocation} SET City = ?, Colony = ?, PropertyAddressAsPerSite = ?, AddressMatching = ?, LocalMuniciapalBody = ?, NameOfMunicipalBody = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    }
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
}
