import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'theme_files/app_color.dart';

class CustomTheme {
  CustomTheme._();

  static TextStyle formLabelStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
  static TextStyle formFieldStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );
  static TextStyle formHintStyle = const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );
  static TextStyle datatableHeadStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle radioStyle =
      const TextStyle(fontSize: 11, fontWeight: FontWeight.bold);

  static List<BoxShadow>? boxShadow = [
    const BoxShadow(
      color: AppColors.primary,
      blurRadius: 0.1,
      spreadRadius: 0.1,
    ),
  ];
  static  BoxDecoration decoration = BoxDecoration(
    boxShadow: CustomTheme.boxShadow,
    color: Colors.white,
    borderRadius: BorderRadius.circular(5.0),
  );
  static DropDownDecoratorProps dropdownDecoratorProps = DropDownDecoratorProps(
    dropdownSearchDecoration: InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      hintText: "Select",
      // label: const Text("Select"),
      // labelStyle: const TextStyle(overflow: TextOverflow.clip),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
    ),
  );

  static SizedBox defaultSize = const SizedBox(height: 16);
  static SizedBox defaultHeight10 = const SizedBox(height: 10);

  static InputDecoration customDropdownStyle = InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.all(10.0),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(
        color: AppColors.primary,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(
        color: Colors.redAccent,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(
        color: AppColors.primary,
      ),
    ),
  );
}
