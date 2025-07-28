import 'package:flutter/material.dart';

import 'app_color.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: "appFont",
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      primary: AppColors.primary,
      secondary: Colors.white60,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.primary.withAlpha(150),
      selectionHandleColor: AppColors.primary,
    ),
    appBarTheme: AppBarTheme(
      elevation: 5,
      shadowColor: AppColors.primary,
      backgroundColor: AppColors.primary,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 5,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.gray,
        disabledBackgroundColor: AppColors.primary.withAlpha(130),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      headerBackgroundColor: AppColors.primary,
      headerForegroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 5,
      dayStyle: TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      todayBorder: BorderSide(color: AppColors.primary),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primary),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            decoration: TextDecoration.none,
          ),
        ),
      ),
      cancelButtonStyle: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            decoration: TextDecoration.none,
          ),
        ),
      ),
      dayOverlayColor: WidgetStatePropertyAll(AppColors.primary),
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey;
        }
        return Colors.black;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (!states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return AppColors.primary;
      }),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (!states.contains(WidgetState.selected)) {
          return Colors.black;
        }
        return Colors.white;
      }),
    ),
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white60,
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(AppColors.primaryOption2),
      trackOutlineColor: WidgetStatePropertyAll(AppColors.primaryOption2),
      // trackColor: WidgetStatePropertyAll(AppColors.primaryOption2),
    ),
    brightness: Brightness.dark,
    // scaffoldBackgroundColor: AppColors.blackLight,
    fontFamily: "appFont",
    primaryColor: AppColors.primaryOption2,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: AppColors.primaryOption2,
      secondary: Colors.grey.shade700,
    ),
    useMaterial3: true,
    textSelectionTheme:
        TextSelectionThemeData(cursorColor: AppColors.primaryOption2),
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(
        fontFamily: "appFont",
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white70,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: "appFont",
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white60,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          fontFamily: "appFont",
        ),
        elevation: 5,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryOption2,
        disabledForegroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.primaryOption2.withAlpha(230),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        disabledForegroundColor: AppColors.gray,
        disabledBackgroundColor: AppColors.primary.withAlpha(130),
        side: const BorderSide(color: AppColors.primary, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        // fontSize: 20,
        color: Colors.white70,
      ),
      bodySmall: TextStyle(
        // fontSize: 20,
        color: Colors.white60,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(AppColors.primary),
      overlayColor: WidgetStatePropertyAll(AppColors.primary),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  );
}
