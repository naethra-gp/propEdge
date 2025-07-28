import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'index.dart';

class CustomTheme {
  CustomTheme._();

  static TextStyle formLabelStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );
  static TextStyle errorStyle = TextStyle(
    color: Colors.redAccent,
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );
  static TextStyle formFieldStyle = const TextStyle(
    fontSize: 13,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );
  static TextStyle formHintStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
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
  static BoxDecoration decoration = BoxDecoration(
    boxShadow: CustomTheme.boxShadow,
    color: Colors.white,
    borderRadius: BorderRadius.circular(5.0),
  );
  static DropDownDecoratorProps dropdownDecoratorProps = DropDownDecoratorProps(
    // decoration: customDropdownStyle,
    dropdownSearchDecoration: customDropdownStyle,
  );

  static SizedBox defaultSize = const SizedBox(height: 16);
  static SizedBox defaultHeight10 = const SizedBox(height: 10);

  static InputDecoration customDropdownStyle = InputDecoration(
    // isDense: true,
    // contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    hintText: "Select",
    hintStyle: formHintStyle,
    labelStyle: formLabelStyle,
    errorStyle: const TextStyle(
      color: Colors.redAccent,
      fontSize: 10,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(color: Color(0xff1980e3)),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Color(0xff1980e3)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.redAccent),
    ),
  );
}
