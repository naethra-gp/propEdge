import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../app_theme/custom_theme.dart';

// Global Drop Down
class CustomDropdown extends StatelessWidget {
  // LOCAL VARIABLE DECLARATION
  final String title;
  final bool required;
  final IconData? prefixIcon;
  final List itemList;
  final bool enabled;
  final FormFieldValidator? validator;
  final FormFieldSetter? onSaved;
  final ValueChanged? onChanged;
  final String? selectedItem;
  final DropdownSearchOnFind? asyncItems;
  final DropdownSearchItemAsString? itemAsString;
  final DropdownSearchFilterFn? filterFn;
  final DropdownSearchCompareFn? compareFn;
  final AutovalidateMode? autoValidateMode;

  const CustomDropdown({
    super.key,
    required this.title,
    this.required = false,
    required this.itemList,
    this.prefixIcon,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.selectedItem,
    this.asyncItems,
    this.itemAsString,
    this.filterFn,
    this.compareFn,
    this.autoValidateMode,
    this.enabled = true,
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
        DropdownSearch(
          items: itemList,
          onChanged: onChanged,
          onSaved: onSaved,
          selectedItem: selectedItem,
          validator: validator,
          enabled: enabled,
          asyncItems: asyncItems,
          itemAsString: itemAsString,
          compareFn: compareFn,
          filterFn: filterFn,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            menuProps: MenuProps(elevation: 25),
          ),
          dropdownBuilder: (context, selectedItem) {
            // return Text(
            //   selectedItem ?? "Select $title",
            //   overflow: TextOverflow.ellipsis,
            //   style: CustomTheme.formFieldStyle,
            // );
            return Text(
              selectedItem.toString() == ""  ? "Select $title" : selectedItem,
              overflow: TextOverflow.ellipsis,
              style: selectedItem.toString() == "" ? CustomTheme.formHintStyle
              : CustomTheme.formFieldStyle,
            );
          },
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              // labelText: title,
              hintText: title,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color(0xff1980e3),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                borderSide: BorderSide(
                  color: Color(0xff1980e3),
                  width: 2,
                ),
              ),
            ),

          ),

          // dropdownDecoratorProps: CustomTheme.dropdownDecoratorProps,
        ),
      ],
    );
  }
}
