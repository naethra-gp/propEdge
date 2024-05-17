import 'package:flutter/material.dart';

import 'app_color.dart';
import 'hive_storage_services.dart';

class ThemeProvider with ChangeNotifier {
  final StorageService storageService;
  late Color selectedPrimaryColor;
  late ThemeMode selectedThemeMode;
  late String currentLanguage;

  ThemeProvider(this.storageService) {
    selectedPrimaryColor = storageService.get(StorageKeys.primaryColor) == null
        ? AppColors.primary
        : Color(storageService.get(StorageKeys.primaryColor));

    selectedThemeMode = storageService.get(StorageKeys.themeMode) == null
        ? ThemeMode.light
        : ThemeMode.values.byName(storageService.get(StorageKeys.themeMode));
    currentLanguage = storageService.get(StorageKeys.language) ?? 'en';
  }

  setSelectedPrimaryColor(Color color) {
    selectedPrimaryColor = color;
    storageService.set(StorageKeys.primaryColor, color.value);
    notifyListeners();
  }

  setSelectedThemeMode(ThemeMode mode) {
    selectedThemeMode = mode;
    storageService.set(StorageKeys.themeMode, mode.name);
    notifyListeners();
  }

  setCurrentLanguage(String lang) {
    currentLanguage = lang;
    storageService.set(StorageKeys.language, lang);
    notifyListeners();
  }
}
