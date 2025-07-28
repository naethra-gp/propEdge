import 'dart:convert';

import '../../../app_config/app_constants.dart';
import '../db/database_services.dart';

class LocalReimbursementServices {
  String table = Constants.reimbursement;
  read() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM $table WHERE IsActive='Y'");
  }

  insertFromApp(val) async {
    final db = await DatabaseServices.instance.database;
    int response = 0;
    val = jsonDecode(val);
    String id = val['Id'].toString();
    var expenseDate = val['ExpenseDate'];
    var natureOfExpense = val['NatureOfExpense'];
    var noOfDays = val['NoOfDays'];
    var travelAllowance = val['TravelAllowance'];
    var totalAmount = val['TotalAmount'];
    var expenseComment = val['ExpenseComment'];
    var billPath = val['BillPath'];
    var billName = val['BillName'];
    var billBase64String = val['BillBase64String'];
    var isActive = val['IsActive'];
    var syncStatus = val['SyncStatus'];
    await db.transaction((txn) async {
      int res = await txn.rawInsert("""
    INSERT INTO ${Constants.reimbursement}
    (Id, ExpenseDate, NatureOfExpense, NoOfDays, TravelAllowance, TotalAmount, ExpenseComment, BillPath, BillName, BillBase64String, IsActive, SyncStatus)
    VALUES ( '$id', '$expenseDate', '$natureOfExpense', '$noOfDays', '$travelAllowance', '$totalAmount', '$expenseComment',
     '$billPath','$billName', '$billBase64String', '$isActive', '$syncStatus' )
    """);
      response = res;
    });
    return response;
  }

  removeBill(List<String> updateList) async {
    final db = await DatabaseServices.instance.database;
    int count = await db.rawUpdate(
        'UPDATE ${Constants.reimbursement} SET IsActive = ?, SyncStatus = ? WHERE primaryId = ?',
        updateList);
    return count;
  }

  updateFromApp(updateList) async {
    final db = await DatabaseServices.instance.database;
    int count = await db.rawUpdate(
        'UPDATE ${Constants.reimbursement} SET Id = ?, ExpenseDate = ?, NatureOfExpense = ?, NoOfDays = ?, TravelAllowance = ?, TotalAmount = ?, ExpenseComment = ?, BillPath = ?, BillName = ?, BillBase64String = ?, IsActive = ?, SyncStatus = ? WHERE primaryId = ?',
        updateList);
    return count;
  }

  /// FOR DATA SYNC
  readBasedOnSync() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.reimbursement} WHERE SyncStatus='N'");
  }

  deleteById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "DELETE FROM ${Constants.reimbursement} WHERE primaryId='$id'");
  }

  deleteByIdLocal(
    String id,
  ) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawDelete(
        "DELETE FROM ${Constants.reimbursement} WHERE primaryId=? AND SyncStatus='N'",
        [id]);
  }
}
