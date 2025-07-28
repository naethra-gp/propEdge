import '../../../app_config/app_constants.dart';
import '../db/database_services.dart';

class CustomerServices {
  String table = Constants.customerBankDetails;
  read() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM $table");
  }

  readById(id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM $table WHERE PropId=$id");
  }
}
