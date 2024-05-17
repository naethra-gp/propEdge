import 'dart:convert';

import '../../app_config/index.dart';
import 'database_service.dart';

class CalculatorService {
  jsonStringify(value) {
    return json.encode(value);
  }

  insert(String pId, val) async {
    final db = await DatabaseServices.instance.database;
    // await db.rawQuery('DELETE FROM ${Constants.stageCalculator}');
    // values.forEach((val) async {
    var propId = pId;
    var id = jsonStringify(val['Id']);
    var masterId = jsonStringify(val['MasterId']);
    var heads = jsonStringify(val['Heads']);
    var progress = jsonStringify(val['Progress']);
    var recommended = jsonStringify(val['Recommended']);
    var totalFloor = jsonStringify(val['TotalFloor']);
    var completedFloor = jsonStringify(val['CompletedFloor']);
    var progressPer = jsonStringify(val['ProgressPer']);
    var recommendedPer = jsonStringify(val['RecommendedPer']);
    var progressPerAsPerPolicy = jsonStringify(val['ProgressPerAsPerPolicy']);
    var recommendedPerAsPerPolicy =
        jsonStringify(val['RecommendedPerAsPerPolicy']);
    var syncStatus = "Y";
    await db.transaction((txn) async {
      await txn.rawInsert('''
        INSERT INTO ${Constants.stageCalculator} ( PropId, Id, MasterId, Heads, Progress, Recommended,
         TotalFloor, CompletedFloor, ProgressPer, RecommendedPer, ProgressPerAsPerPolicy, 
         RecommendedPerAsPerPolicy, SyncStatus ) 
        VALUES ( '$propId', '$id', '$masterId', '$heads', '$progress',
        '$recommended', '$totalFloor', '$completedFloor', '$progressPer', '$recommendedPer', 
        '$progressPerAsPerPolicy','$recommendedPerAsPerPolicy', '$syncStatus' )
        ''');
    });
    // });
  }

  read(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.stageCalculator} WHERE PropId=$propId");
  }

  update(values) async {
    final db = await DatabaseServices.instance.database;
    try {
      int count = await db.rawUpdate(
          'UPDATE ${Constants.stageCalculator} SET Progress = ?, Recommended = ?, TotalFloor = ?, CompletedFloor = ?, ProgressPer = ?, RecommendedPer = ?, SyncStatus = ? WHERE PropId = ?',
          values);
      return count;
    } catch (e) {
      return "error -> $e";
    }
  }

  readSync(String propId) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.stageCalculator} WHERE PropId=$propId AND SyncStatus='N'");
  }
  updateSyncStatus(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawUpdate(
        "UPDATE ${Constants.stageCalculator} SET SyncStatus = ? WHERE PropId = ?", request);
  }
  deleteRecord(List request) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.stageCalculator} WHERE PropId = ?", request);
  }
}
