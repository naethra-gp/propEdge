import 'dart:convert';

import '../../app_config/index.dart';
import 'database_service.dart';

class ReimbursementServices {
  insert(values) async {
    final db = await DatabaseServices.instance.database;
    if (values.isNotEmpty) {
      await db.rawQuery('DELETE FROM ${Constants.reimbursement}');
      values.forEach((val) async {
        var id = val['Id'];
        var expenseDate = val['ExpenseDate'];
        var natureOfExpense = val['NatureOfExpense'];
        var noOfDays = val['NoOfDays'];
        var travelAllowance = val['TravelAllowance'];
        var totalAmount = val['TotalAmount'];
        var expenseComment = val['ExpenseComment'];
        var billPath = val['BillPath'];
        var billName = val['BillName'];
        var billBase64String = val['BillBase64String'];
        var isActive = "Y";
        var syncStatus = "Y";
        await db.transaction((txn) async {
          await txn.rawInsert("""
        INSERT INTO ${Constants.reimbursement}
        (Id, ExpenseDate, NatureOfExpense, NoOfDays, TravelAllowance, TotalAmount, ExpenseComment, BillPath, BillName, BillBase64String, IsActive, SyncStatus)
        VALUES ( '$id', '$expenseDate', '$natureOfExpense', '$noOfDays', '$travelAllowance', '$totalAmount', '$expenseComment',
         '$billPath','$billName', '$billBase64String', '$isActive', '$syncStatus' )
        """);
        });
      });
    }
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

  updateFromApp(updateList) async {
    final db = await DatabaseServices.instance.database;
    int count = await db.rawUpdate(
        'UPDATE ${Constants.reimbursement} SET Id = ?, ExpenseDate = ?, NatureOfExpense = ?, NoOfDays = ?, TravelAllowance = ?, TotalAmount = ?, ExpenseComment = ?, BillPath = ?, BillName = ?, BillBase64String = ?, IsActive = ?, SyncStatus = ? WHERE primaryId = ?',
        updateList);
    return count;
  }
  read() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.reimbursement} WHERE IsActive='Y'");
  }

  readById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery(
        "SELECT * FROM ${Constants.reimbursement} WHERE primaryId='$id'");
  }

  removeBill(List<String> updateList) async {
    final db = await DatabaseServices.instance.database;
    int count = await db.rawUpdate(
        'UPDATE ${Constants.reimbursement} SET IsActive = ?, SyncStatus = ? WHERE primaryId = ?',
        updateList);
    return count;
  }

  updateSyncStatus(List<String> updateList) async {
    final db = await DatabaseServices.instance.database;
    int count = await db.rawUpdate(
        'UPDATE ${Constants.reimbursement} SET SyncStatus = ? WHERE primaryId = ?',
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
}
