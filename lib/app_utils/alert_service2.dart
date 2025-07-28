// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:location/location.dart';
// import 'package:prop_edge/app_utils/app/common_functions.dart';
// import 'package:prop_edge/app_utils/app/logger.dart';
// import 'package:prop_edge/location_service.dart';

// import '../app_storage/secure_storage.dart';

// class AlertService {
//   static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//   final _secureStorage = BoxStorage();

//   showLoading([String? title]) async {
//     EasyLoading.instance
//       ..loadingStyle = EasyLoadingStyle.light
//       ..indicatorType = EasyLoadingIndicatorType.fadingCircle
//       ..toastPosition = EasyLoadingToastPosition.center
//       ..animationStyle = EasyLoadingAnimationStyle.scale
//       ..textStyle = TextStyle(fontWeight: FontWeight.w500);
//     return await EasyLoading.show(
//       status: title ?? 'Please wait...',
//       maskType: EasyLoadingMaskType.black,
//       dismissOnTap: false,
//     );
//   }

//   hideLoading() async {
//     return await EasyLoading.dismiss();
//   }

//   // TOAST
//   errorToast(String message) {
//     return Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 12.0,
//     );
//   }

//   successToast(String message) {
//     return Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//       fontSize: 12.0,
//     );
//   }

//   toast(String message) {
//     return Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       fontSize: 12.0,
//     );
//   }

//   /// GLOBAL CONFIRM ALERT
//   confirmAlert(BuildContext context, String? title, String content) {
//     ThemeData theme = Theme.of(context);
//     return showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//           child: AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//             title: Text(
//               title ?? "Confirm",
//               style: theme.textTheme.bodyLarge?.copyWith(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w700,
//                 decoration: TextDecoration.none,
//               ),
//             ),
//             content: Text(
//               content.toString(),
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 // fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 decoration: TextDecoration.none,
//               ),
//             ),
//             actions: [
//               TextButton(
//                 child: Text(
//                   "No",
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontSize: 16,
//                     color: Colors.redAccent,
//                     fontWeight: FontWeight.w600,
//                     decoration: TextDecoration.none,
//                   ),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: Text(
//                   "Yes",
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     decoration: TextDecoration.none,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   confirmAlertOK(BuildContext context, String? title, String content) {
//     ThemeData theme = Theme.of(context);
//     return showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return PopScope(
//           canPop: false, // Disables the back button
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//             child: AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               title: Text(
//                 title ?? "Alert",
//                 style: theme.textTheme.bodyLarge?.copyWith(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//               content: Text(
//                 content.toString(),
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   decoration: TextDecoration.none,
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                   },
//                   child: Text(
//                     "OK",
//                     style: theme.textTheme.bodyLarge?.copyWith(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       decoration: TextDecoration.none,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<void> showLocationEnableDialog() async {
//     final Location location = Location();

//     await showDialog(
//       context: navigatorKey.currentContext!,
//       barrierDismissible: false, // Cannot tap outside to dismiss
//       builder: (BuildContext context) {
//         ThemeData theme = Theme.of(context);

//         return PopScope(
//           // onWillPop: () async => false, // Disable back button
//           canPop: false,
//           onPopInvokedWithResult: (didPop, result) => false,
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//             child: AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               title: Text(
//                 "Location Required",
//                 style: theme.textTheme.bodyLarge?.copyWith(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               content: Text(
//                 "Please turn on the Location to continue the Process.",
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () async {
//                     bool enabled = await location.requestService();
//                     if (enabled) {
//                       Navigator.of(context).pop(); // Close dialog
//                       // Add a small delay to ensure location service is fully enabled
//                       // await Future.delayed(const Duration(milliseconds: 500));
//                       // Retry getting location
//                       LocationService().getCurrentLocation();
//                     }
//                   },
//                   child: Text(
//                     "Turn On",
//                     style: theme.textTheme.bodyLarge?.copyWith(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void loadData(BuildContext context) async {
//     int count = await LocationService().getDataforLogin();
//     print("count---> $count");
//     if (count == 0) {
//       Navigator.pushReplacementNamed(context, 'login');
//     }
//   }

//   Future<void> androidLogoutCallback(BuildContext context) async {
//     try {
//       // AlertService().successToast('Calling Auto-logout..');
//       CommonFunctions().logToFile('Calling Auto-logout..');
//       final userDetails = _secureStorage.get('user');
//       debugPrint('Fetched user details: $userDetails');
//       if (userDetails != null) {
//         AlertService().showLoading();
//         final LocationService locationService = LocationService();
//         await locationService.uploadLocationTrackingAuto();
//         await _secureStorage.deleteUserDetails();
//         await _secureStorage.deleteStartTripStatus();
//         await _secureStorage.deleteEndTripStatus();
//         await _secureStorage.save('logStatus', true);
//         debugPrint('Auto-logout completed successfully at ${DateTime.now()}');
//         // AlertService().successToast('uploaded successfully..');
//         LogService().i('uploaded successfully..');
//         CommonFunctions().logToFile('uploaded successfully..');
//         AlertService().hideLoading();
//         Navigator.pushReplacementNamed(context, 'login');
//       }
//     } catch (e, stack) {
//       debugPrint('Error during auto-logout: $e');
//       debugPrint('Stack trace: $stack');
//       AlertService().errorToast('Error during auto-logout: $e');
//       AlertService().showLoading();
//     }
//   }
// }
