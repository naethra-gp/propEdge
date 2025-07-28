import 'package:flutter/material.dart';

import '../../app_theme/custom_theme.dart';

class CustomSingleDropdown extends StatelessWidget {
  final ValueChanged? onChanged;
  final String? dropdownValue;
  final String title;
  final bool required;
  // final List items;
  final List<DropdownMenuItem<String>> items;
  final FormFieldValidator? validator;
  const CustomSingleDropdown({
    super.key,
    this.onChanged,
    this.dropdownValue,
    required this.items,
    required this.title,
    this.required = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        required
            ? RichText(
                text: TextSpan(
                  text: title,
                  style: CustomTheme.formLabelStyle,
                  children: const [
                    TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                  ],
                ),
              )
            : RichText(
                text: TextSpan(
                  text: title,
                  style: CustomTheme.formLabelStyle,
                ),
              ),
        const SizedBox(height: 5),
        //Global Drop Down
        DropdownButtonFormField(
          isDense: true,
          hint: Text(title, style: CustomTheme.formHintStyle),
          value: dropdownValue,
          elevation: 16,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          isExpanded: true,
          validator: validator,
          onChanged: onChanged,
          items: items,
          // decoration: CustomTheme.customDropdownStyle,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            hintText: "Select",
            hintStyle: CustomTheme.formHintStyle,
            labelStyle: CustomTheme.formLabelStyle,
            errorStyle: CustomTheme.errorStyle,
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
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Color(0xff1980e3)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
