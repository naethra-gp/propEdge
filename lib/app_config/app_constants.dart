import 'package:flutter/material.dart';

class Constants {
  // IMAGE STATIC PATH
  static const appLogo = 'assets/images/logo.png';
  // static const Color appThemeColor = Color(0xff1980e3);
  static Color dashCaseColor = const Color(0xff1880e2);
  static Color dashTotalColor = const Color(0xffe21880);
  static Color dashSubmitColor = const Color(0xfffe9601);
  static Color material1 = const Color(0xFF3775FD);
  static Color material2 = const Color(0xFF9C27B0);
  static Color material3 = const Color(0xFF8D7AEE);
  static Color material4 = const Color(0xFFF369B7);
  static Color material5 = const Color(0xFFFFC85B);
  static Color material6 = const Color(0xFF5DD1D3);
  static Color material7 = const Color(0xFFC4C5C9);
  static Color material8 = const Color(0xFF075BB5);
  static Color material9 = const Color(0xff3c67e0);
  static Color statusPending = const Color(0xffe1010a);
  static Color statusProcess = const Color(0xfffe9601);
  static Color statusCompleted = const Color(0xff0bbf53);
  static List materialColorArray = [
    material1,
    material2,
    material3,
    material4,
    material5,
    material6,
    material7,
    material8,
    material9,
  ];
  // LOGIN PURPOSE
  // static const clientName = 'PAP_MobileApp';
  // static const clientPassword = 'F6281B39-0B3E-47C8-A4A2-2ACC435E0B03';
  // static const basicAuthUsername = 'mobile-auth';
  // static const basicAuthPassword = '6728F023-FF26-429F-9AF2-5E071C9A6D16';

  static const clientName = 'PAP_MobileApp';
  static const clientPassword = '39E8ED6D-6C02-4FE4-9586-FA6A70F76CC1';
  static const basicAuthUsername = 'mobile-auth-live';
  static const basicAuthPassword = 'EC84F9B6-100B-448D-A256-0AA6675D39CD';

  // TAB TITLES
  static const dashboard = 'Dashboard';
  static const svFormTitle = 'Assigned Properties';
  static const caseTitle = 'Submitted Case\'s';
  static const reimbursementTitle = 'Reimbursement';
  static const dataSyncTitle = 'Data Sync';
  static List status = ["Pending", "Process", "Completed"];

  // SQLITE3 TABLE NAMES
  static const dropdownList = 'DropdownList'; // 1
  static const getUserCaseSummary = 'GetUserCaseSummary'; // 2
  static const propertyList = 'PropertyList'; // 3
  static const reimbursement = 'Reimbursement'; // 4
  static const propertyLocation = 'PropertyLocationDetails'; // 5
  static const locationDetails = 'LocationDetails'; // 6
  static const occupancyDetails = 'OccupancyDetails'; // 7
  static const feedback = 'Feedback'; // 8
  static const boundaryDetails = 'BoundaryDetails'; // 9
  static const measurementSheet = 'MeasurementSheet'; // 10
  static const stageCalculator = 'StageCalculator'; // 11
  static const photograph = 'Photograph'; //12
  static const locationMap = 'LocationMap'; //13
  static const propertySketch = 'PropertySketch'; // 14
  static const customerBankDetails = 'CustomerBankDetails'; // 15
  static const criticalComment = 'CriticalComment'; // 15

  static const locationMapTitle = "Location Map";
  static const propertySketchTitle = "Property Sketch";
  static const photographTitle = "Photographs";

  static const loadingMessage = "Please wait...";
  static const successMessage = "Success";
  static const errorMessage = "Try again!";
  static const maxUploadMessage = "You upload maximum photos!";
  static const internetErrorMessage = "Please check your Internet Connection and try again!";
  static const apiErrorMessage = "Error in Data sync, Please contact PropEdge administrator!";
  static const apiSuccessMessage = "Data synced Successfully.";
  static const noDataSyncErrorMessage = "No data found to sync!";
  static const limitExistsErrorMessage = "Limit Exists. Please contact PropEdge administrator!";

}
