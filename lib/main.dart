import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_config/app_constants.dart';
import 'app_config/app_routes.dart';
import 'app_theme/index.dart';
import 'app_utils/alert_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(Constants.boxStorage);
  await Firebase.initializeApp();

  // Enable Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Enable Performance Monitoring
  FirebasePerformance performance = FirebasePerformance.instance;
  performance.setPerformanceCollectionEnabled(true);
  // performance.setPerformanceCollectionEnabled(!kDebugMode);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.primary,
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}

