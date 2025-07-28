// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
//
// import '../../app_theme/custom_theme.dart';
//
//
// // Global Drop Down
// class CustomDropdown extends StatelessWidget {
//   // LOCAL VARIABLE DECLARATION
//   final String title;
//   final bool required;
//   final IconData? prefixIcon;
//   final DropdownSearchOnFind<String>? itemList;
//   final bool enabled;
//   final FormFieldValidator? validator;
//   final FormFieldSetter? onSaved;
//   final ValueChanged? onChanged;
//   final String? selectedItem;
//   final DropdownSearchItemAsString? itemAsString;
//   final DropdownSearchFilterFn? filterFn;
//   final DropdownSearchCompareFn? compareFn;
//   final AutovalidateMode? autoValidateMode;
//   final bool showSearchBox;
//
//   const CustomDropdown({
//     super.key,
//     required this.title,
//     this.required = false,
//     required this.itemList,
//     this.prefixIcon,
//     this.validator,
//     this.onSaved,
//     this.onChanged,
//     this.selectedItem,
//     this.itemAsString,
//     this.filterFn,
//     this.compareFn,
//     this.autoValidateMode,
//     this.enabled = true,
//     required this.showSearchBox,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         required
//             ? RichText(
//                 text: TextSpan(
//                     text: title,
//                     style: CustomTheme.formLabelStyle,
//                     children: const [
//                       TextSpan(text: ' *', style: TextStyle(color: Colors.red))
//                     ]),
//               )
//             : RichText(
//                 text: TextSpan(
//                   text: title,
//                   style: CustomTheme.formLabelStyle,
//                 ),
//               ),
//         const SizedBox(height: 5),
//
//         //Global Drop Down
//         SizedBox(
//           height: 40,
//           child: DropdownSearch<String>(
//             items: itemList,
//             onChanged: onChanged,
//             onSaved: onSaved,
//             selectedItem: selectedItem,
//             validator: validator,
//             enabled: enabled,
//             itemAsString: itemAsString,
//             compareFn: compareFn,
//             filterFn: filterFn,
//             autoValidateMode: AutovalidateMode.onUserInteraction,
//             popupProps: PopupProps.menu(
//               showSearchBox: showSearchBox,
//               fit: FlexFit.loose,
//               menuProps: const MenuProps(elevation: 15),
//               itemBuilder: (context, item, isDisabled, isSelected) => Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Text(
//                   item,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//             dropdownBuilder: (context, selectedItem) {
//               return Text(
//                 selectedItem!.toString() == "" ? "Select $title" : selectedItem,
//                 overflow: TextOverflow.ellipsis,
//                 style: selectedItem.toString() == ""
//                     ? CustomTheme.formHintStyle
//                     : CustomTheme.formFieldStyle,
//               );
//             },
//             decoratorProps: CustomTheme.dropdownDecoratorProps,
//           ),
//         ),
//       ],
//     );
//   }
// }
