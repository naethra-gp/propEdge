import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_sqlcipher/sqflite.dart';
import 'table_scripts.dart';

class DatabaseServices {
  static final DatabaseServices instance = DatabaseServices._init();
  DatabaseServices._init();
  static Database? _database;
  static String dbName = 'PropEdge_db.db';
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    return await openDatabase(
      path,
      version: 1,
      // password: "Naethra@1995",
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute(TableScripts.dropdownListScript);
      await txn.execute(TableScripts.userCaseSummaryScript);
      await txn.execute(TableScripts.reimbursementScript);
      await txn.execute(TableScripts.propertyListScript);
      await txn.execute(TableScripts.customerBankDetailsScript);
      await txn.execute(TableScripts.propertyDetailsScript);
      await txn.execute(TableScripts.areaDetailsScript);
      await txn.execute(TableScripts.occupancyDetailsScript);
      await txn.execute(TableScripts.boundaryDetailsScript);
      await txn.execute(TableScripts.measurementSheetScript);
      await txn.execute(TableScripts.calculatorDetailsScript);
      await txn.execute(TableScripts.criticalCommentScript);
      await txn.execute(TableScripts.photographScript);
      await txn.execute(TableScripts.locationMapScript);
      await txn.execute(TableScripts.propertyPlanScript);
      await txn.execute(TableScripts.locationTrackingScript);
    });
  }
}
