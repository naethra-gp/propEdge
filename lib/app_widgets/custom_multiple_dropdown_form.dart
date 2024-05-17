import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../app_theme/custom_theme.dart';

// Global Drop Down
class CustomMultipleDropdown extends StatelessWidget {
  // LOCAL VARIABLE DECLARATION
  final String title;
  final bool required;
  final IconData? prefixIcon;
  final List itemList;
  final bool enabled;
  final FormFieldValidator? validator;
  final FormFieldSetter? onSaved;
  final ValueChanged? onChanged;
  final List selectedItems;
  final DropdownSearchOnFind? asyncItems;
  final DropdownSearchItemAsString? itemAsString;
  final DropdownSearchFilterFn? filterFn;
  final DropdownSearchCompareFn? compareFn;
  final AutovalidateMode? autoValidateMode;
  final Key? key1;

  const CustomMultipleDropdown({
    super.key,
    required this.title,
    this.required = false,
    required this.itemList,
    this.prefixIcon,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.asyncItems,
    this.itemAsString,
    this.filterFn,
    this.compareFn,
    this.autoValidateMode,
    this.enabled = true,
    required this.selectedItems, this.key1,
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
        DropdownSearch.multiSelection(
          items: itemList,
          onChanged: onChanged,
          key: key1,
          onSaved: onSaved,
          selectedItems: selectedItems,
          validator: validator,
          enabled: enabled,
          asyncItems: asyncItems,
          itemAsString: itemAsString,
          compareFn: compareFn,
          filterFn: filterFn,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          dropdownDecoratorProps: CustomTheme.dropdownDecoratorProps,
        ),
      ],
    );
  }
}
