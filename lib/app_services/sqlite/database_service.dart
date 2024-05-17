import 'dart:io';

import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proequity/app_config/index.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  static final DatabaseServices instance = DatabaseServices._init();
  DatabaseServices._init();
  static Database? _database;
  final Directory dbFolder = Directory('/storage/emulated/0/PropEdge/DB/');
  static const dbName = 'PropEdge_db.db';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path1 = '';
    String dbPath;
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted || await Permission.storage.request().isGranted) {
        if (!await Directory(dbFolder.path).exists()) {
          await dbFolder.create(recursive: true);
        }
        path1 = join(dbFolder.path, dbName);
      }
    } else if (Platform.isIOS) {
      dbPath = await getDatabasesPath();
      path1 = join(dbPath, filePath);
    }
    return await openDatabase(path1, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      /// CREATE metaDataTbl - DropdownList TABLE
      await txn.execute('''CREATE TABLE ${Constants.dropdownList} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          Id TEXT, 
          Name TEXT, 
          Type TEXT, 
          Options TEXT
        )''');

      /// CREATE userCaseTbl - GetUserCaseSummary TABLE
      await txn.execute('''CREATE TABLE ${Constants.getUserCaseSummary} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT,
          CaseForVisit int, 
          CaseSubmitted int, 
          CaseSubmittedToday int,
          SpillCase int, 
          TodayCase int, 
          TomorrowCase int, 
          TotalCase int,	
          SyncStatus TEXT
          )''');

      /// CREATE propertyTbl - PropertyList TABLE
      await txn.execute('''CREATE TABLE ${Constants.propertyList} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT,	
          Address TEXT,	
          ApplicationNumber TEXT,	
          ContactPersonName TEXT,	
          ContactPersonNumber TEXT,	
          CustomerName TEXT,	
          DateOfVisit TEXT,	
          InstituteName TEXT,	
          LocationName TEXT, 
          ColonyName TEXT, 
          Priority TEXT, 
          Status TEXT, 
          SpecialInstruction TEXT, 
          SyncStatus TEXT
        )''');

      /// CREATE reimbursementTbl - Reimbursement TABLE
      await txn.execute('''CREATE TABLE ${Constants.reimbursement} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          Id TEXT,
          ExpenseDate TEXT,	
          NatureOfExpense TEXT, 
          NoOfDays INTEGER,	
          TravelAllowance INTEGER,	
          TotalAmount INTEGER, 
          ExpenseComment TEXT,	
          BillPath TEXT,	
          BillName TEXT, 
          BillBase64String TEXT, 
          IsActive TEXT, 
          SyncStatus TEXT
        )''');

      /// CREATE propertyLocation - PropertyLocation TABLE
      await txn.execute('''CREATE TABLE ${Constants.propertyLocation} (
            primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
            PropId TEXT, 
            City TEXT, 
            Colony TEXT,
            PropertyAddressAsPerSite TEXT,
            AddressMatching TEXT,
            LocalMuniciapalBody TEXT,
            NameOfMunicipalBody TEXT,
            SyncStatus TEXT
        )''');

      /// CREATE _ld - LocationDetails TABLE
      await txn.execute('''CREATE TABLE ${Constants.locationDetails} (
            primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
            PropId TEXT, 
            AnyNegativeToTheLocality TEXT, 
            ClassOfLocality TEXT,
            ConditionAndWidthOfApproachRoad TEXT,
            InfrastructureOfTheSurroundingArea TEXT,
            Latitude TEXT,
            Longitude TEXT,
            Micromarket TEXT,
            NatureOfLocality TEXT,
            NearbyLandmark TEXT,
            NearestBusStop TEXT,
            NearestHospital TEXT,
            NearestMetroStation TEXT,
            NearestRailwayStation TEXT,
            NeighborhoodType TEXT,
            ProximityFromCivicsAmenities TEXT,
            SiteAccess TEXT,
            SyncStatus TEXT
        )''');

      /// CREATE occupancyDetails - OccupancyDetails TABLE
      await txn.execute('''CREATE TABLE ${Constants.occupancyDetails} (
        primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
        PropId TEXT, 
        OccupiedBy TEXT, 
        OccupiedSince TEXT,
        RelationshipOfOccupantWithCustomer TEXT,
        StatusOfOccupancy TEXT,
        SyncStatus TEXT
        )''');

      /// CREATE feedback - Feedback TABLE
      await txn.execute('''CREATE TABLE ${Constants.feedback} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT, 
          Amenities TEXT, 
          ApproxAgeOfProperty TEXT,
          MaintainanceLevel TEXT,
          SyncStatus TEXT
        )''');

      /// CREATE boundaryDetails - BoundaryDetails TABLE
      await txn.execute('''CREATE TABLE ${Constants.boundaryDetails} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT, 
          Type TEXT, 
          East TEXT, 
          West TEXT,
          South TEXT,
          North TEXT,
          SyncStatus TEXT
        )''');

      /// CREATE measurementSheet - MeasurementSheet TABLE
      await txn.execute('''CREATE TABLE ${Constants.measurementSheet} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT, 
          SizeType TEXT, 
          SheetType TEXT, 
          Sheet TEXT,
          SyncStatus TEXT
        )''');

      /// CREATE stageCalculator - StageCalculator TABLE
      await txn.execute('''CREATE TABLE ${Constants.stageCalculator} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT, 
          Id TEXT, 
          MasterId TEXT,
          Heads	TEXT,
          Progress TEXT,
          Recommended TEXT,
          TotalFloor TEXT,
          CompletedFloor TEXT,
          ProgressPer TEXT,
          RecommendedPer TEXT,
          ProgressPerAsPerPolicy TEXT,
          RecommendedPerAsPerPolicy TEXT,
          SyncStatus TEXT
        )''');

      /// CREATE photograph - Photograph TABLE
      await txn.execute('''CREATE TABLE ${Constants.photograph} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT, 
          Id TEXT, 
          ImagePath TEXT,
          ImageName	TEXT,
          ImageDesc TEXT,
          ImageOrder TEXT,
          IsDeleted TEXT,
          IsActive TEXT,
          SyncStatus TEXT
        )''');

      /// CREATE locationMap - LocationMap TABLE
      await txn.execute('''CREATE TABLE ${Constants.locationMap} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT, 
          Id TEXT, 
          ImagePath TEXT,
          ImageName	TEXT,
          ImageDesc TEXT,
          ImageOrder TEXT,
          IsDeleted TEXT,
          IsActive TEXT,
          SyncStatus TEXT
        )''');

      /// CREATE propertySketch - PropertySketch TABLE
      await txn.execute('''CREATE TABLE ${Constants.propertySketch} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT, 
          Id TEXT, 
          ImagePath TEXT,
          ImageName	TEXT,
          ImageDesc TEXT,
          ImageOrder TEXT,
          IsDeleted TEXT,
          IsActive TEXT,
          SyncStatus TEXT
      )''');

      /// CREATE propertySketch - PropertySketch TABLE
      await txn.execute('''CREATE TABLE ${Constants.customerBankDetails} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT, 
          BankName TEXT, 
          ContactPersonName TEXT,
          ContactPersonNumber TEXT,
          CustomerName TEXT,
          LoanType TEXT,
          PropertyAddress TEXT,
          SiteInspectionDate TEXT,
          SyncStatus TEXT
        )''');

      /// CREATE criticalComment - CriticalComment TABLE
      await txn.execute('''CREATE TABLE ${Constants.criticalComment} (
          primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
          PropId TEXT, 
          Comment TEXT, 
          SyncStatus TEXT
        )''');
    });
  }
}
