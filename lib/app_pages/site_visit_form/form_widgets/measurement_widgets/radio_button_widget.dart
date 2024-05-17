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
                      title: Text(e['Name'], style: CustomTheme.radioStyle),
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

// class SheetSizeWidget extends StatefulWidget {
//   final void Function(String) callback;
//
//   const SheetSizeWidget({super.key, required this.callback});
//
//   @override
//   State<SheetSizeWidget> createState() => _SheetSizeWidgetState();
// }
//
// class _SheetSizeWidgetState extends State<SheetSizeWidget> {
//   DropdownServices ddService = DropdownServices();
//   List sheetSizeList = [];
//   String groupValue = '';
//
//   @override
//   void initState() {
//     getRadioList();
//     super.initState();
//   }
//
//   getRadioList() async {
//     List list = await ddService.read();
//     sheetSizeList =
//         list.where((e) => e['Type'] == "MeasurementSheetSizeType").toList();
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             "Measurement Sheet Size",
//             style: CustomTheme.formLabelStyle,
//           ),
//         ),
//         if (sheetSizeList.isNotEmpty) ...[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: sheetSizeList
//                 .map(
//                   (e) => Expanded(
//                     child: RadioListTile(
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       contentPadding: EdgeInsets.zero,
//                       title: Text(e['Name'], style: CustomTheme.radioStyle),
//                       value: e['Id'].toString(),
//                       groupValue: groupValue.toString(),
//                       onChanged: (String? value) {
//                         groupValue = value.toString();
//                         widgets.callback(groupValue.toString());
//                         setState(() {});
//                       },
//                     ),
//                   ),
//                 )
//                 .toList(),
//           ),
//         ],
//       ],
//     );
//   }
// }
