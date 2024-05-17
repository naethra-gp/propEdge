import '../../app_config/index.dart';
import 'database_service.dart';

class CustomerService {
  insert(String id, val) async {
    final db = await DatabaseServices.instance.database;
    if (val.isNotEmpty) {
      // await db.rawQuery('DELETE FROM ${Constants.customerBankDetails}');
      var propId = id.toString();
      var bankName = val['BankName'].toString().trim();
      var contactPersonName = val['ContactPersonName'].toString().trim();
      var contactPersonNumber = val['ContactPersonNumber'].toString().trim();
      var customerName = val['CustomerName'].toString().trim();
      var loanType = val['LoanType'].toString().trim();
      var propertyAddress = val['PropertyAddress'].toString().trim();
      var siteInspectionDate = val['SiteInspectionDate'].toString().trim();
      var syncStatus = "Y";
      await db.transaction((txn) async {
        await txn.rawInsert("""
        INSERT INTO ${Constants.customerBankDetails}
        (PropId, BankName, ContactPersonName, ContactPersonNumber, CustomerName, LoanType, PropertyAddress, SiteInspectionDate, SyncStatus)
        VALUES ( '$propId', '$bankName', '$contactPersonName', '$contactPersonNumber', '$customerName', '$loanType', '$propertyAddress',
         '$siteInspectionDate', '$syncStatus' )
        """);
      });
    }
  }

  read() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.customerBankDetails}");
  }
  readById(String id) async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.customerBankDetails} WHERE PropId=$id");
  }
}
