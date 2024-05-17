import 'package:flutter/material.dart';

import '../../app_theme/custom_theme.dart';

class CustomSingleDropdown extends StatelessWidget {
  final ValueChanged? onChanged;
  final String? dropdownValue;
  final String title;
  final bool required;
  final List<DropdownMenuItem<String>> items;
  final FormFieldValidator? validator;
  const CustomSingleDropdown({
    super.key,
    this.onChanged,
    this.dropdownValue,
    required this.items,
    required this.title,
    this.required = false, this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    ]),
              )
            : Text(
                title,
                style: CustomTheme.formLabelStyle,
              ),
        //Global Drop Down
        DropdownButtonFormField<String>(
          hint: Text(
            title,
            style: CustomTheme.formHintStyle,
          ),
          value: dropdownValue,
          elevation: 16,
          isExpanded: true,
          validator: validator,
          onChanged: onChanged,
          items: items,
          decoration: CustomTheme.customDropdownStyle,
        ),
      ],
    );
  }
}
