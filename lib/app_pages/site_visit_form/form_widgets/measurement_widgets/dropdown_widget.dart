import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../../app_theme/custom_theme.dart';

class DropdownWidget extends StatelessWidget {
  final List list;
  final String selectedValue;
  final String label;
  final Function(dynamic) onValueChanged;
  const DropdownWidget({
    super.key,
    required this.list,
    required this.selectedValue,
    required this.label,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DropdownSearch(
        selectedItem: selectedValue,
        items: list.map((e) => e['Name']).toList(),
        dropdownDecoratorProps: CustomTheme.dropdownDecoratorProps,
        onChanged: onValueChanged,
      ),
    );
  }
}
