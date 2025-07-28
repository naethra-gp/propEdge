import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../app_services/local_db/local_services/dropdown_services.dart';
import '../../../app_services/local_db/local_services/measurement_service.dart';
import '../../../app_utils/alert_service.dart';
import '../../../app_utils/app/app_button_widget.dart';
import '../widget/measurement_widget/add_measurement.dart';
import '../widget/measurement_widget/radio_button_widget.dart';

class MeasurementForm extends StatefulWidget {
  final VoidCallback buttonClicked;
  final String propId;

  const MeasurementForm({
    super.key,
    required this.buttonClicked,
    required this.propId,
  });

  @override
  State<MeasurementForm> createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementForm> {
  /// GLOBAL DECLARATION
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DropdownServices _dropdownServices = DropdownServices();
  final MeasurementServices _measurementServices = MeasurementServices();

  List<Map<String, dynamic>> _measurements = [];
  List<Map<String, dynamic>> _sheetSizeList = [];
  List<Map<String, dynamic>> _sizeTypeList = [];

  String _selectedSheetSize = '';
  String _selectedSheetType = 'R';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchDropdownData();
    await _fetchMeasurementData();
  }

  /// Initial fetch of Dropdown data
  Future<void> _fetchDropdownData() async {
    final dropdownData = await _dropdownServices.read();
    _sheetSizeList = dropdownData
        .where((e) => e['Type'] == "MeasurementSheetSizeType")
        .toList();
    _sizeTypeList =
        dropdownData.where((e) => e['Type'] == "MeasurementSheetType").toList();
    setState(() {});
  }

  /// Initial fetch of Measurement data
  Future<void> _fetchMeasurementData() async {
    final measurementData = await _measurementServices.read(widget.propId);
    if (measurementData.isNotEmpty) {
      final measurement = measurementData.first;
      _selectedSheetSize = measurement['SizeType'];
      _selectedSheetType = measurement['SheetType'].toString().isEmpty
          ? "R"
          : measurement['SheetType'];
      _measurements =
          List<Map<String, dynamic>>.from(jsonDecode(measurement['Sheet']));
    }
    setState(() {});
  }

  void _addMeasurement() {
    setState(() {
      _measurements.add({
        "Id": "0",
        "IsDeleted": false,
        "Description": "",
        "Particulars": "",
        "Length": '0',
        "Width": "0",
        "Total": "0",
      });
    });
  }

  void _updateMeasurement(int index, Map<String, dynamic> updatedMeasurement) {
    setState(() {
      _measurements[index] = updatedMeasurement;
    });
  }

  Future<void> _saveAndNext() async {
    if (_formKey.currentState!.validate()) {
      final requestData = [
        _selectedSheetSize,
        _selectedSheetType,
        jsonEncode(_measurements),
        "N",
        widget.propId,
      ];

      final result = await _measurementServices.update(requestData);
      if (result == 1) {
        AlertService().successToast("Measurement Saved");
        widget.buttonClicked();
      } else {
        AlertService().errorToast("Failed to save measurement!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              /// Measurement Sheet Type - Radio btn
              RadioButtonWidget(
                label: 'Measurement Sheet Type',
                radioList: _sizeTypeList,
                selectedValue: _selectedSheetType,
                onValueChanged: (value) {
                  setState(() {
                    _selectedSheetType = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              /// Measurement Sheet Size Type - Radio
              RadioButtonWidget(
                label: 'Measurement Sheet Size Type',
                radioList: _sheetSizeList,
                selectedValue: _selectedSheetSize,
                onValueChanged: (value) {
                  setState(() {
                    _selectedSheetSize = value;
                  });
                },
              ),
              Row(
                children: [
                  const Spacer(),

                  /// Add Measurement - Button
                  TextButton(
                    onPressed: _addMeasurement,
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
              const SizedBox(height: 10),
              ..._measurements.asMap().entries.map((entry) {
                final index = entry.key;
                final measurement = entry.value;
                return measurement['IsDeleted'] == false
                    ? AddMeasurementWidget(
                        index: index,
                        value: measurement,
                        sheetType: _selectedSheetType,
                        remove: (int index) {
                          setState(() {
                            _measurements[index]['IsDeleted'] = true;
                          });
                        },
                        onValueChanged: (result) {
                          _updateMeasurement(index, result);
                        },
                      )
                    : const SizedBox.shrink();
              }),
              const SizedBox(height: 10),
              AppButton(
                title: "Save & Next",
                onPressed: _saveAndNext,
              ),
              const SizedBox(height: 20),
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
