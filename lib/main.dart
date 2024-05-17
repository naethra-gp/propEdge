import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'app_config/index.dart';
import 'app_theme/app_theme.dart';
import 'app_theme/theme_files/app_color.dart';
import 'app_theme/theme_files/hive_storage_services.dart';
import 'app_theme/theme_files/theme_provider.dart';
import 'app_widgets/alert_widget.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(() async {
    setUpServiceLocator();
    final StorageService storageService = getIt<StorageService>();
    await storageService.init();
    await Hive.initFlutter();
    await Hive.openBox('PROP_EQUITY_CONTROLS');

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.primary,
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    runApp(MyApp(storageService: storageService));
  }, (e, _) => throw e);
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   // theme: AppThemes.mainTheme,
    //   themeMode: ThemeMode.system,
    //   builder: EasyLoading.init(),
    //   initialRoute: 'splash',
    //   onGenerateRoute: AppRoute.allRoutes,
    //   navigatorKey: navigatorKey,
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(storageService),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (c, themeProvider, home) => MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'splash',
          builder: EasyLoading.init(),
          onGenerateRoute: AppRoute.allRoutes,
          navigatorKey: AlertService.navigatorKey,
          locale: Locale(themeProvider.currentLanguage),
          theme: AppThemes.main(
            primaryColor: themeProvider.selectedPrimaryColor,
          ),
          darkTheme: AppThemes.main(
            isDark: true,
            primaryColor: themeProvider.selectedPrimaryColor,
          ),
          themeMode: themeProvider.selectedThemeMode,
        ),
      ),
    );

  }
}
