import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_widgets/alert_widget.dart';
import '../../../app_widgets/index.dart';
import 'measurement_widgets/add_measurement.dart';
import 'measurement_widgets/radio_button_widget.dart';

class MeasurementForm extends StatefulWidget {
  final VoidCallback buttonSubmitted;
  final String propId;
  const MeasurementForm(
      {super.key, required this.buttonSubmitted, required this.propId});

  @override
  State<MeasurementForm> createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List dynamicArray = [];
  List sheetSizeList = [];
  List sizeTypeList = [];
  List dbMeasurement = [];
  List sheets = [];
  var measurementValue = {
    "Id": "0",
    "IsDeleted": false,
    "Description": "",
    "Particulars": "",
    "Length": '0',
    "Width": "0",
    "Total": "0",
  };
  List measurements = [];
  DropdownServices ddService = DropdownServices();
  MeasurementServices mmServices = MeasurementServices();

  /// MEASUREMENT SHEET SIZE
  String _selectSheetSize = '';
  String _selectSheetType = 'R';

  /// FORM CONTROLS

  @override
  void initState() {
    getRadioList();
    getMeasurement();
    super.initState();
  }

  getRadioList() async {
    List list = await ddService.read();
    String size = "MeasurementSheetSizeType";
    String type = "MeasurementSheetType";
    sheetSizeList = list.where((e) => e['Type'] == size).toList();
    sizeTypeList = list.where((e) => e['Type'] == type).toList();
    setState(() {});
  }

  getMeasurement() async {
    dbMeasurement = await mmServices.read(widget.propId);
    var val = dbMeasurement[0];
    _selectSheetSize = val['SizeType'];
    sheets = jsonDecode(val['Sheet']);
    _selectSheetType =
        val['SheetType'].toString() == "" ? "R" : val['SheetType'];
    for (int i = 0; i < sheets.length; i++) {
      measurements.add(measurementValue);
      measurements[i] = sheets[i];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomTheme.defaultHeight10,
              RadioButtonWidget(
                label: 'Measurement Sheet Size Type',
                radioList: sheetSizeList,
                selectedValue: _selectSheetSize,
                onValueChanged: (value) {
                  _selectSheetSize = value;
                  setState(() {});
                },
              ),
              RadioButtonWidget(
                label: 'Measurement Sheet Type',
                radioList: sizeTypeList,
                selectedValue: _selectSheetType,
                onValueChanged: (value) {
                  _selectSheetType = value;
                  setState(() {});
                },
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      measurements.add(measurementValue);
                      print(measurements);
                      setState(() {});
                    },
                    child: const Text(
                      "Add Measurement",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              CustomTheme.defaultHeight10,
              for (int i = 0; i < measurements.length; i++) ...[
                if (measurements[i]['IsDeleted'] == false) ...[
                  AddMeasurementWidget(
                    index: i,
                    // key: ObjectKey(measurements[i]),
                    value: measurements[i],
                    sheetType: _selectSheetType,
                    remove: (int index) {
                      // measurements.removeAt(index);
                      setState(() {});
                    },
                    onValueChanged: (result) {
                      measurements[i] = result;
                      setState(() {});
                    },
                  ),
                ],
              ],
              CustomTheme.defaultHeight10,
              AppButton(
                title: "Save & Next",
                onPressed: () async {
                  // for (int i = 0; i < measurements.length; i++) {
                  List req = [
                    _selectSheetSize.toString(),
                    _selectSheetType.toString(),
                    jsonEncode(measurements),
                    "N",
                    widget.propId.toString()
                  ];
                  print("measurement -> $measurements");
                  var result = await mmServices.update(req);
                  if (result == 1) {
                    AlertService().successToast("Measurement Saved");
                    widget.buttonSubmitted();
                  } else {
                    AlertService().errorToast("Measurement Failure!");
                  }
                  // }
                },
              ),
              CustomTheme.defaultSize,
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    super.dispose();
  }
}
