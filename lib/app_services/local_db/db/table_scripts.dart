import '../../../app_config/app_constants.dart';

class TableScripts {
  static String get dropdownListScript => '''
    CREATE TABLE ${Constants.dropdownList} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      Id TEXT, 
      Name TEXT, 
      Type TEXT, 
      Options TEXT
    )''';

  static String get userCaseSummaryScript => '''
    CREATE TABLE ${Constants.getUserCaseSummary} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT,
      CaseForVisit int, 
      CaseSubmitted int, 
      CaseSubmittedToday int,
      SpillCase int, 
      TodayCase int, 
      TomorrowCase int, 
      TotalCase int,	
      SyncStatus TEXT
    )''';

  static String get reimbursementScript => '''
    CREATE TABLE ${Constants.reimbursement} (
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
    )''';

  static String get propertyListScript => '''
    CREATE TABLE ${Constants.propertyList} (
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
    )''';

  static String get customerBankDetailsScript => '''
    CREATE TABLE ${Constants.customerBankDetails} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      BankName TEXT, 
      BranchName TEXT, 
      ContactPersonName TEXT,
      ContactPersonNumber TEXT,
      CustomerName TEXT,
      CustomerContactNumber TEXT,
      LoanType TEXT,
      PropertyAddress TEXT,
      SiteInspectionDate TEXT,
      SyncStatus TEXT
    )''';

  static String get propertyDetailsScript => '''
    CREATE TABLE ${Constants.propertyDetails} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      AddressMatching TEXT, 
      AgeOfProperty TEXT, 
      AreaOfProperty TEXT,
      BHKConfiguration TEXT,
      City TEXT,
      Colony TEXT,
      ConditionOfProperty TEXT,
      ConstructionOldNew TEXT,
      DeveloperName TEXT,
      Floor TEXT,
      FloorOthers TEXT,
      KitchenAndCupboardsExisting TEXT,
      KitchenOrPantry TEXT,
      KitchenType TEXT,
      LandArea TEXT,
      MaintainanceLevel TEXT,
      NameOfMunicipalBody TEXT,
      NoOfLifts TEXT,
      NoOfStaircases TEXT,
      Pincode TEXT,
      PlotAreaMtrs TEXT,
      PlotAreaSqft TEXT,
      PlotAreaYards TEXT,
      PlotUnitType TEXT,
      ProjectName TEXT,
      PropertyAddressAsPerSite TEXT,
      PropertyArea TEXT,
      PropertySubType TEXT,
      PropertyType TEXT,
      Region TEXT,
      Structure TEXT,
      StructureOthers TEXT,
      SyncStatus TEXT
    )''';

  static String get areaDetailsScript => '''
    CREATE TABLE ${Constants.areaDetails} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      Amenities TEXT,
      AnyNegativeToTheLocality TEXT,
      ClassOfLocality TEXT,
      ConditionAndWidthOfApproachRoad TEXT,
      InfrastructureConditionOfNeighboringAreas TEXT,
      InfrastructureOfTheSurroundingArea TEXT,
      LandUseOfNeighboringAreas TEXT,
      Latitude TEXT,
      Longitude TEXT,
      NatureOfLocality TEXT,
      NearbyLandmark TEXT,
      PublicTransport TEXT,
      SiteAccess TEXT,
      SyncStatus TEXT
    )''';

  static String get occupancyDetailsScript => '''
    CREATE TABLE ${Constants.occupancyDetails} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      OccupantContactNo TEXT, 
      OccupiedBy TEXT, 
      OccupiedSince TEXT,
      PersonMetAtSite TEXT,
      PersonMetAtSiteContNo TEXT,
      RelationshipOfOccupantWithCustomer TEXT,
      StatusOfOccupancy TEXT,
      SyncStatus TEXT
    )''';

  static String get boundaryDetailsScript => '''
    CREATE TABLE ${Constants.boundaryDetails} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      Type TEXT, 
      East TEXT, 
      West TEXT,
      South TEXT,
      North TEXT,
      SyncStatus TEXT
    )''';

  static String get measurementSheetScript => '''
    CREATE TABLE ${Constants.measurementSheet} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      SizeType TEXT, 
      SheetType TEXT, 
      Sheet TEXT,
      SyncStatus TEXT
    )''';

  static String get calculatorDetailsScript => '''
    CREATE TABLE ${Constants.stageCalculator} (
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
    )''';

  static String get criticalCommentScript => '''
    CREATE TABLE ${Constants.criticalComment} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      Comment TEXT, 
      SyncStatus TEXT
    )''';

  static String get photographScript => '''
    CREATE TABLE ${Constants.photograph} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      Id TEXT, 
      ImagePath TEXT,
      ImageName	TEXT,
      ImageDesc TEXT,
      IsDeleted TEXT,
      IsActive TEXT,
      SyncStatus TEXT
    )''';

  static String get locationMapScript => '''
    CREATE TABLE ${Constants.locationMap} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      Id TEXT, 
      ImagePath TEXT,
      ImageName	TEXT,
      ImageDesc TEXT,
      IsDeleted TEXT,
      IsActive TEXT,
      SyncStatus TEXT
    )''';

  static String get propertyPlanScript => '''
    CREATE TABLE ${Constants.propertyPlan} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      PropId TEXT, 
      Id TEXT, 
      ImagePath TEXT,
      ImageName	TEXT,
      ImageDesc TEXT,
      IsDeleted TEXT,
      IsActive TEXT,
      SyncStatus TEXT
    )''';

  static String get locationTrackingScript => '''
    CREATE TABLE ${Constants.locationTracking} (
      primaryId INTEGER PRIMARY KEY AUTOINCREMENT,
      Latitude REAL,
      Longitude REAL,
      Timestamp INTEGER,
      TrackStatus TEXT,
      SyncStatus TEXT
    )''';
}
