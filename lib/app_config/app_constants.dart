import 'dart:ui';

class Constants {
  /// ------------------ HEADER INFORMATION'S ----------------------------------
  // static const clientName = 'PAP_MobileApp';
  // static const clientPassword = 'F6281B39-0B3E-47C8-A4A2-2ACC435E0B03';
  // static const basicAuthUsername = 'mobile-auth';
  // static const basicAuthPassword = '6728F023-FF26-429F-9AF2-5E071C9A6D16';

  static const clientName = 'PAP_MobileApp';
  static const clientPassword = '39E8ED6D-6C02-4FE4-9586-FA6A70F76CC1';
  static const basicAuthUsername = 'mobile-auth-live';
  static const basicAuthPassword = 'EC84F9B6-100B-448D-A256-0AA6675D39CD';

  /// ------------------ HEADER INFORMATION'S ----------------------------------

  static String appLogo = 'assets/images/logo.png';
  static String loginBg = 'assets/images/login-bg-1.png';
  static String boxStorage = 'PROP_EQUITY_CONTROLS';

  // TAB TITLES
  static const dashboard = 'Dashboard';
  static const svFormTitle = 'Assigned Properties';
  static const caseTitle = 'Submitted Case\'s';
  static const reimbursementTitle = 'Reimbursement';
  static const dataSyncTitle = 'Data Sync';
  static List status = ["Pending", "Process", "Completed"];

  /// DATABASE TABLE NAMES - SQLITE3 TABLE NAMES
  static const dropdownList = 'DropdownList'; // 1
  static const getUserCaseSummary = 'GetUserCaseSummary'; // 2
  static const propertyList = 'PropertyList'; // 3
  static const reimbursement = 'Reimbursement'; // 4
  static const propertyDetails = 'PropertyDetails'; // 5
  static const areaDetails = 'AreaDetails'; // 6
  static const occupancyDetails = 'OccupancyDetails'; // 7
  // static const feedback = 'Feedback'; // 8
  static const boundaryDetails = 'BoundaryDetails'; // 9
  static const measurementSheet = 'MeasurementSheet'; // 10
  static const stageCalculator = 'StageCalculator'; // 11
  static const photograph = 'Photograph'; //12
  static const locationMap = 'LocationMap'; //13
  static const propertyPlan = 'PropertyPlan'; //13
  // static const propertySketch = 'PropertySketch'; // 14
  static const customerBankDetails = 'CustomerBankDetails'; // 15
  static const criticalComment = 'CriticalComment'; // 15
  static const locationTracking = 'LocationTracking'; // 15

  static const locationMapTitle = "Location Map";
  static const propertyPlanTitle = "Property Plan";
  static const photographTitle = "Photographs";

  /// APP STRINGS
  static String loadingMessage = "Please wait...";
  static String successMessage = "Success";
  static String errorMessage = "Try again!";
  static String maxUploadMessage = "You upload maximum photos!";
  static String internetErrorMessage =
      "Please check your Internet Connection and try again!";
  static String apiErrorMessage =
      "Error in Data sync! Please contact PropEdge administrator!";
  static String apiSuccessMessage = "Data synced Successfully.";
  static String apiSuccessMessageVisit =
      "Site Visit and Location tracking data synced successfully.";
  static String noDataSyncErrorMessage = "No data found to sync!";
  static String checkInternetMsg =
      "No internet connection detected. Please check your network.";
  static String downloadMsg = "Download Live data to Local?";
  static String limitExistsErrorMessage =
      "Please delete old image before upload new location map";
  static String finalFormAlertText =
      "Please review your forms before final submission because once you submit, you won't be able to edit the form.";

  /// APP Dashboard Colors
  static Color dashCaseColor = const Color(0xff1880e2);
  static Color dashTotalColor = const Color(0xffe21880);
  static Color dashSubmitColor = const Color(0xfffe9601);
  static Color statusPending = const Color(0xffe1010a);
  static Color statusProcess = const Color(0xfffe9601);
  static Color statusCompleted = const Color(0xff0bbf53);
}
