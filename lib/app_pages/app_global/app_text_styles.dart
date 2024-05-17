import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle buttonWhite =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14);
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    // disabledBackgroundColor: AppColors.borderGrey,
    // disabledForegroundColor: AppColors.subTitle,
    padding: const EdgeInsets.symmetric(vertical: 12),
    backgroundColor: const Color(0xff1980e3),
    textStyle: AppStyles.buttonWhite,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
  );
}
