import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/app/common_functions.dart';
import 'package:prop_edge/app_utils/app/logger.dart';
import 'package:prop_edge/location_service.dart';
import 'app_config/app_constants.dart';
import 'app_config/app_routes.dart';
import 'app_services/local_db/local_services/tracking_service.dart';
import 'app_storage/secure_storage.dart';
import 'app_theme/index.dart';

const MethodChannel _locationChannel =
    MethodChannel('com.propedge.app/location_service');
CommonFunctions commonFunctions = CommonFunctions();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LogService().init();
  await Hive.initFlutter();
  await Hive.openBox(Constants.boxStorage);

  await Firebase.initializeApp();

  // Enable Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.primary,
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  startListeningToLocation();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    FirebaseCrashlytics.instance.recordError(
      details.exception,
      details.stack,
      reason: 'APP CRASH',
      fatal: true,
    );
  };

  runApp(const MyApp());
}

void startListeningToLocation() {
  WidgetsFlutterBinding.ensureInitialized();

  _locationChannel.setMethodCallHandler((MethodCall call) async {
    try {
      if (call.method == 'insertLocation') {
        final Map args = call.arguments as Map;
        final double latitude = args['latitude'];
        final double longitude = args['longitude'];
        final String trackStatus = args['trackStatus'];

        debugPrint('Map foreground service: $args');
        commonFunctions.logToFile('Insert Location called...');
        // await getLocationFromGoogle();
        // await TrackingServices()
        //     .insertLocationToDb(latitude, longitude, trackStatus);
        await TrackingServices()
            .insertLocationFromRaw(latitude, longitude, trackStatus);
      } else if (call.method == "autoLogoutTriggered") {
        await androidLogoutCallback();
      }
    } catch (e, stackTrace) {
      commonFunctions.appLog(e, stackTrace,
          fatal: true, reason: 'LISTEN TRACKING');
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isPaused = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      if (state == AppLifecycleState.detached) {
        try {
          // LocationService().startTrackingFromCurrent();
        } catch (e) {
          debugPrint('Error stopping foreground service: $e');
          // Continue with logout even if service stop fails
        }
        print("==> APP IS PAUSED <==");
      } else if (state == AppLifecycleState.hidden) {
        print("==> APP IS RESUMED <==");
      }
    } catch (e) {
      print("==> APP LIFECYCLE ERROR: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return MaterialApp(
              title: 'PropEdge',
              debugShowCheckedModeBanner: false,
              initialRoute: 'splash',
              builder: EasyLoading.init(),
              onGenerateRoute: AppRoute.allRoutes,
              navigatorKey: AlertService.navigatorKey,
              themeMode: ThemeMode.system,
              theme: AppThemes.lightTheme,
            );
          },
        );
      },
    );
  }
}

Future<bool> isTripInTrackingState() async {
  BoxStorage boxStorage = BoxStorage();
  String todayDate = DateTime.now().toString().substring(0, 11);
  List<String> startTripList = await boxStorage.get('start_trip_date') ?? [];
  List<String> endTripList = await boxStorage.get('end_trip_date') ?? [];

  debugPrint('---> Checking Trip State:');
  debugPrint('---> Today: $todayDate');
  debugPrint('---> Start Trip List: $startTripList');
  debugPrint('---> End Trip List: $endTripList');

  if (endTripList.length < startTripList.length) {
    return true;
  }
  return false;
}

@pragma('vm:entry-point')
Future<void> androidLogoutCallback() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // ✅ Hive setup in background isolate
    final appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);

    var boxName = Constants.boxStorage;
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    // AlertService().successToast('Calling Auto-logout..');
    // LogService().i('Calling Auto-logout..');
    commonFunctions.logToFile('Calling Auto-logout..');
    final box = Hive.box(boxName);
    final userDetails = box.get('user');
    debugPrint('Fetched user details: $userDetails');

    if (userDetails != null) {
      final LocationService _locationService = LocationService();
      await _locationService.uploadLocationTrackingAuto();

      await box.delete('user');
      await box.delete('start_trip_date');
      await box.delete('end_trip_date');
      await box.put('logStatus', true);
      debugPrint('Auto-logout completed successfully at ${DateTime.now()}');
      // AlertService().successToast('uploaded successfully..');
      LogService().i('uploaded successfully..');
      commonFunctions.logToFile('uploaded successfully..');
    }
  } catch (e, stack) {
    debugPrint('Error during auto-logout: $e');
    debugPrint('Stack trace: $stack');
    AlertService().errorToast('Error during auto-logout: $e');
  }
}
