import 'package:flutter/material.dart';

import 'theme_files/app_color.dart';
import 'theme_files/app_theme_model.dart';

class AppThemes {
  // static ThemeData mainTheme = ThemeData(
  //   scaffoldBackgroundColor: Colors.white,
  //   fontFamily: GoogleFonts.poppins().fontFamily,
  //   primaryColor: AppColors.primary,
  //   splashColor: Colors.transparent,
  //   highlightColor: Colors.transparent,
  //   hoverColor: Colors.transparent,
  //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
  //   useMaterial3: true,
  //   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  //     type: BottomNavigationBarType.fixed,
  //     // selectedItemColor: AppColors.title,
  //     // unselectedItemColor: AppColors.title,
  //     // selectedLabelStyle: AppStyles.caption,
  //     // unselectedLabelStyle: AppStyles.caption,
  //     selectedIconTheme: IconThemeData(size: 24),
  //     backgroundColor: Colors.white,
  //     unselectedIconTheme: IconThemeData(size: 24),
  //   ),
  //   floatingActionButtonTheme: FloatingActionButtonThemeData(
  //     backgroundColor: AppColors.primary,
  //     foregroundColor: Colors.white,
  //     elevation: 12,
  //     hoverColor: Colors.transparent,
  //     splashColor: Colors.transparent,
  //   ),
  // );
  static ThemeData main({
    bool isDark = false,
    Color primaryColor = AppColors.primary,
  }) {
    return ThemeData(
      fontFamily: "Poppins",
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.primary,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(size: 24),
        backgroundColor: Colors.white,
        unselectedIconTheme: IconThemeData(size: 24),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 12,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
        surface: isDark ? AppColors.blackLight : AppColors.white,
      ),
      appBarTheme: AppBarTheme(
        shadowColor:
            isDark ? AppColors.primary.withOpacity(0.8) : AppColors.primary,
        backgroundColor:
            isDark ? AppColors.primary.withOpacity(0.8) : AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(
          // color: isDark ? Colors.grey : Colors.black54,
          ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.black87,
      ),
      textTheme: TextTheme(
        bodySmall: TextStyle(
          color: isDark ? Colors.grey : Colors.black54,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        bodyMedium:
            const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(
          color: isDark ? Colors.grey : Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        titleMedium: const TextStyle(
          fontSize: 13.0,
          color: Colors.black,
          fontWeight: FontWeight.w800,
        ),
      ),
      expansionTileTheme: const ExpansionTileThemeData(),
      cardTheme: CardTheme(
        color: isDark ? AppColors.blackLight : AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: isDark ? Colors.grey : AppColors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      ),
      dividerColor: isDark
          ? AppColors.white.withOpacity(0.2)
          : AppColors.black.withOpacity(0.1),
      shadowColor: isDark ? AppColors.text : AppColors.grayDark,

      /// OLD THEME DATA
      // brightness: isDark ? Brightness.dark : Brightness.light,
      // primaryColor: primaryColor,
      // textTheme: TextTheme(
      //     bodySmall: TextStyle(
      //         color: isDark ? Colors.grey.shade50 : Colors.black54,
      //         fontWeight: FontWeight.w700),
      //     bodyMedium: TextStyle(
      //       color: primaryColor,
      //     ),
      //     bodyLarge: TextStyle(
      //       color: isDark ? Colors.white70 : primaryColor,
      //     ),
      //     titleLarge: TextStyle(
      //       color: isDark ? Colors.white70 : primaryColor,
      //     ),
      //     titleSmall: TextStyle(
      //       color: isDark ? AppColors.white50 : AppColors.blackLight,
      //     ),
      //     titleMedium: TextStyle(
      //       color: isDark ? AppColors.white50 : AppColors.blackLight,
      //     ),
      //     displayMedium: TextStyle(
      //       color: isDark ? AppColors.white50 : AppColors.blackLight,
      //       // fontSize:
      //     ),
      //     displaySmall: TextStyle(
      //         color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
      //         fontSize: 14)),
      // cupertinoOverrideTheme: const CupertinoThemeData(
      //   textTheme: CupertinoTextThemeData(), // This is required
      // ),
      // buttonTheme: ButtonThemeData(
      //   buttonColor: primaryColor,
      //   shape: const RoundedRectangleBorder(),
      //   textTheme: ButtonTextTheme.accent,
      // ),
      // // floatingActionButtonTheme: FloatingActionButtonThemeData(
      // //     elevation: 10,
      // //     foregroundColor: Colors.white,
      // //     backgroundColor: primaryColor),
      // backgroundColor: isDark ? AppColors.blackLight : AppColors.gray,
      // // scaffoldBackgroundColor: isDark ? AppColors.blackLight : AppColors.gray,
      // scaffoldBackgroundColor: Colors.white,
      // // cardColor: isDark ? AppColors.white.withOpacity(0) : AppColors.white,
      // cardTheme: CardTheme(
      //   color: isDark ? AppColors.blackLight : AppColors.white,
      //   elevation: 5,
      //   shape: RoundedRectangleBorder(
      //     side: BorderSide(
      //         color: isDark ? Colors.grey : AppColors.white, width: 1),
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      // ),
      // dividerColor: isDark
      //     ? AppColors.white.withOpacity(0.2)
      //     : AppColors.black.withOpacity(0.1),
      // shadowColor: isDark ? AppColors.text : AppColors.grayDark,
      // iconTheme: const IconThemeData(
      //   color: Colors.white,
      // ),
      // primarySwatch: AppColors.getMaterialColorFromColor(primaryColor),
      // appBarTheme: AppBarTheme(
      //   elevation: 3,
      //   backgroundColor: primaryColor,
      //   systemOverlayStyle: SystemUiOverlayStyle.light,
      // ),
      // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      //   type: BottomNavigationBarType.fixed,
      //   // selectedItemColor: AppColors.title,
      //   // unselectedItemColor: AppColors.title,
      //   // selectedLabelStyle: AppStyles.caption,
      //   // unselectedLabelStyle: AppStyles.caption,
      //   selectedIconTheme: IconThemeData(size: 24),
      //   backgroundColor: Colors.white,
      //   unselectedIconTheme: IconThemeData(size: 24),
      // ),
      // floatingActionButtonTheme: FloatingActionButtonThemeData(
      //   backgroundColor: AppColors.primary,
      //   foregroundColor: Colors.white,
      //   elevation: 12,
      //   hoverColor: Colors.transparent,
      //   splashColor: Colors.transparent,
      // ),
    );
  }

  static List<AppTheme> appThemeOptions = [
    AppTheme(
      mode: ThemeMode.light,
      title: 'Light',
      icon: Icons.brightness_5_rounded,
    ),
    AppTheme(
      mode: ThemeMode.dark,
      title: 'Dark',
      icon: Icons.brightness_2_rounded,
    ),
    AppTheme(
      mode: ThemeMode.system,
      title: 'System',
      icon: Icons.brightness_4_rounded,
    ),
  ];
}
