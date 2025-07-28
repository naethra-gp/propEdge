import 'package:flutter/material.dart';

import '../../../../app_theme/custom_theme.dart';

class RadioButtonWidget extends StatelessWidget {
  final List radioList;
  final String selectedValue;
  final String label;
  final Function(dynamic) onValueChanged;

  const RadioButtonWidget({
    super.key,
    required this.radioList,
    required this.selectedValue,
    required this.onValueChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label.toString(),
            style: CustomTheme.formLabelStyle,
          ),
        ),
        if (radioList.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: radioList
                .map(
                  (e) => Expanded(
                    child: RadioListTile(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(horizontal: -4.0),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(e['Name'],
                          style: TextStyle(color: Colors.black)),
                      value: e['Id'].toString(),
                      groupValue: selectedValue,
                      onChanged: onValueChanged,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
