import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../app_services/sqlite/dropdown_services.dart';
import '../../../../app_theme/custom_theme.dart';
import 'list_view_widget.dart';

class MeasurementViewWidget extends StatefulWidget {
  final List details;

  const MeasurementViewWidget({super.key, required this.details});

  @override
  State<MeasurementViewWidget> createState() => _MeasurementViewWidgetState();
}

class _MeasurementViewWidgetState extends State<MeasurementViewWidget> {
  List details = [];
  List sheetSizeList = [];
  List sizeTypeList = [];
  DropdownServices ddService = DropdownServices();
  String selectedSizeType = "";
  String selectedSheetType = "";
  List sheetArray = [];

  @override
  void initState() {
    getDropdownValues();
    setState(() {
      details = widget.details;
    });
    super.initState();
  }

  getDropdownValues() async {
    List list = await ddService.read();
    String size = "MeasurementSheetSizeType";
    String type = "MeasurementSheetType";
    sheetSizeList = list.where((e) => e['Type'] == size).toList();
    sizeTypeList = list.where((e) => e['Type'] == type).toList();
    sheetArray = jsonDecode(details[0]['Sheet']);

    var a = sheetSizeList
        .where((e) => e['Id'].toString() == details[0]['SizeType'].toString())
        .toList();
    var b = sizeTypeList
        .where((e) => e['Id'].toString() == details[0]['SheetType'].toString())
        .toList();
    selectedSizeType = a[0]['Name'];
    selectedSheetType = b[0]['Name'];
    List mArray = jsonDecode(b[0]['Options']);

    for (int i = 0; i < sheetArray.length; i++) {
      //-------------- Description ------------------
      var dd = mArray
          .where((e) =>
              e['Id'].toString() == sheetArray[i]['Description'].toString())
          .toList();

      //-------------- Particulars ------------------
      List pArray = dd[0]['Options'];
      var pp = pArray
          .where((e) =>
              e['Id'].toString() == sheetArray[i]['Particulars'].toString())
          .toList();

      //-------------- SET VALUES ------------------
      setState(() {
        sheetArray[i]['Description'] = dd[0]['Name'];
        sheetArray[i]['Particulars'] = pp[0]['Name'];
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTheme.defaultSize,
        ListViewWidget(
          label: "SizeType",
          value: selectedSizeType,
          // value: removeNull(details[0]['SizeType'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "SheetType",
          value: selectedSheetType,
          // value: removeNull(details[0]['SheetType'].toString()),
        ),
        CustomTheme.defaultHeight10,
        if (sheetArray.isNotEmpty) ...[
          for (int i = 0; i < sheetArray.length; i++) ...[
            CustomTheme.defaultHeight10,
            ListViewWidget(
              label: "Description",
              value: removeNull(sheetArray[i]['Description'].toString()),
            ),
            CustomTheme.defaultHeight10,
            ListViewWidget(
              label: "Particulars",
              value: removeNull(sheetArray[i]['Particulars'].toString()),
            ),
            CustomTheme.defaultHeight10,
            ListViewWidget(
                label: "Length",
                value: removeNull(sheetArray[i]['Length'].toString())),
            CustomTheme.defaultHeight10,
            ListViewWidget(
                label: "Width",
                value: removeNull(sheetArray[i]['Width'].toString())),
            CustomTheme.defaultHeight10,
            ListViewWidget(
              label: "Total",
              value: removeNull(sheetArray[i]['Total'].toString()),
            ),
            CustomTheme.defaultHeight10,
          ],
        ],
        // Text(jsonDecode(details[0]['Sheet']).length.toString()),
      ],
    );
  }

  removeNull(String field) {
    return field == "null" ? "-" : field;
  }
}
