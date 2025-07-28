import 'package:location/location.dart';
import 'package:prop_edge/app_config/app_constants.dart';

import '../db/database_services.dart';

class TrackingServices {
  Future<void> insertLocation(LocationData locationData) async {
    final db = await DatabaseServices.instance.database;
    await db.insert(Constants.locationTracking, {
      'Latitude': locationData.latitude,
      'Longitude': locationData.longitude,
      'Timestamp': DateTime.now().millisecondsSinceEpoch,
      'SyncStatus': 'N'
    });
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    final db = await DatabaseServices.instance.database;
    return await db.query('locations');
  }

  Future<void> deleteLocations(List<int> ids) async {
    final db = await DatabaseServices.instance.database;
    await db.delete('locations', where: 'primaryId IN (${ids.join(',')})');
  }
}
