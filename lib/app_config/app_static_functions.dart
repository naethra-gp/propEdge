import 'package:flutter/material.dart';

import '../app_theme/custom_theme.dart';
extension DarkMode on BuildContext {
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}
class AppStaticFunctions {

  static calculatorStyle(String hint) {
    return InputDecoration(
      // hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Colors.green,
        fontWeight: FontWeight.normal,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
  }

  static dropdownMenuItem(String value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        value,
        style: CustomTheme.formFieldStyle,
      ),
    );
  }

  // static isConnectedToInternet() async {
  //   final hasInternet = await InternetConnectivity().hasInternetConnection;
  //   return hasInternet;
  // }
}
