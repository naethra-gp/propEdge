import '../../app_config/index.dart';
import 'database_service.dart';

class UserCaseSummaryServices {
  insert(val) async {
    final db = await DatabaseServices.instance.database;
    await db.rawQuery('DELETE FROM ${Constants.getUserCaseSummary}');
    int count = 0;
    var caseForVisit = val['CaseForVisit'];
    var caseSubmitted = val['CaseSubmitted'];
    var caseSubmittedToday = val['CaseSubmittedToday'];
    var spillCase = val['SpillCase'];
    var todayCase = val['TodayCase'];
    var tomorrowCase = val['TomorrowCase'];
    var totalCase = val['TotalCase'];
    var syncStatus = "Y";
    await db.transaction((txn) async {
      int c = await txn.rawInsert('''
        INSERT INTO ${Constants.getUserCaseSummary} (CaseForVisit, CaseSubmitted, CaseSubmittedToday, SpillCase, TodayCase, TomorrowCase,
         TotalCase, SyncStatus)
        VALUES ('$caseForVisit', '$caseSubmitted', '$caseSubmittedToday', '$spillCase',
        '$todayCase', '$tomorrowCase', '$totalCase', '$syncStatus')
        ''');
      count = c;
    });
    return count;
  }

  read() async {
    final db = await DatabaseServices.instance.database;
    return await db.rawQuery("SELECT * FROM ${Constants.getUserCaseSummary}");
  }
}
