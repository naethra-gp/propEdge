import 'dart:convert';

import '../../app_config/index.dart';
import 'database_service.dart';

class DropdownServices {

  insert(key, values) async {
    final db = await DatabaseServices.instance.database;
    await db.rawQuery('DELETE FROM ${Constants.dropdownList}');
    if (values.runtimeType != String) {
      values.forEach((val) async {
        Object options = json.encode(val['Options']);
        var id = val['Id'];
        var name = val['Name'];
        await db.transaction((txn) async {
          await txn.rawInsert(
              "INSERT INTO ${Constants.dropdownList} (Id, Name, Type, Options) VALUES ( '$id', '$name', '$key', '$options' )");
        });
      });
    }
  }

  read() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.dropdownList}");
  }
}