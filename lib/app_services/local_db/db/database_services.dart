import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../../../app_config/app_constants.dart';
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
      password: "Naethra@1995",
      onCreate: _createDb,
    );
  }

  Future<void> get clearDatabase async {
    final databasesPath = await getDatabasesPath();
    final path =
        join(databasesPath, 'PropEdge_db.db'); // Replace with your DB name

    final dbFile = File(path);
    if (await dbFile.exists()) {
      final db = await openDatabase(path);
      await truncateAllTables(db);
      print('Database deleted at $path');
    }
  }

  Future<void> truncateAllTables(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DELETE FROM ${Constants.dropdownList}');
      await txn.execute('DELETE FROM ${Constants.getUserCaseSummary}');
      await txn.execute('DELETE FROM ${Constants.reimbursement}');
      await txn.execute('DELETE FROM ${Constants.propertyList}');
      await txn.execute('DELETE FROM ${Constants.customerBankDetails}');
      await txn.execute('DELETE FROM ${Constants.propertyDetails} ');
      await txn.execute('DELETE FROM ${Constants.areaDetails}');
      await txn.execute('DELETE FROM ${Constants.occupancyDetails}');
      await txn.execute('DELETE FROM ${Constants.boundaryDetails}');
      await txn.execute('DELETE FROM ${Constants.measurementSheet}');
      await txn.execute('DELETE FROM ${Constants.stageCalculator}');
      await txn.execute('DELETE FROM ${Constants.criticalComment}');
      await txn.execute('DELETE FROM ${Constants.photograph}');
      await txn.execute('DELETE FROM ${Constants.locationMap}');
      await txn.execute('DELETE FROM ${Constants.propertyPlan}');
      await txn.execute('DELETE FROM ${Constants.locationTracking}');
    });
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
