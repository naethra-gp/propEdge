import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../app_services/sqlite/dropdown_services.dart';
import 'dropdown_widget.dart';

class Measurements {
  int id = 0;
  String description = '';
  String particulars = '';
  String length = '0';
  String width = '0';
  String total = '0';
}

class AddMeasurementWidget extends StatefulWidget {
  final int index;
  final String sheetType;
  final dynamic value;
  final void Function(int) remove;
  final Function(dynamic) onValueChanged;

  const AddMeasurementWidget({
    super.key,
    required this.index,
    required this.sheetType,
    required this.remove,
    required this.onValueChanged,
    this.value,
  });

  @override
  State<AddMeasurementWidget> createState() => _AddMeasurementWidgetState();
}

class _AddMeasurementWidgetState extends State<AddMeasurementWidget> {
  List descList = [];
  List particularsList = [];

  List sizeTypeList = [];
  List descriptionMaster = [];

  String selectDescription = '';
  String selectParticular = '';
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController particularsCtrl = TextEditingController();
  TextEditingController lengthCtrl = TextEditingController();
  TextEditingController widthCtrl = TextEditingController();
  TextEditingController totalCtrl = TextEditingController();
  Map<String, dynamic> rowDetail = {};

  @override
  Widget build(BuildContext context) {
    List desc = sizeTypeList.where((e) => e['Id'] == widget.sheetType).toList();
    if (desc.isNotEmpty) {
      descriptionMaster = jsonDecode(desc[0]['Options']);
    }
    return Column(
      children: [
        if (widget.index != 0) ...[
          Row(
            children: [
              const Spacer(),
              TextButton(
                  onPressed: () {
                    // widget.remove(widget.index);
                    rowDetail['IsDeleted'] = true;
                    rowValue();
                    setState(() {});
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.comfortable,
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                  ),
                  child: const Text(
                    "Remove",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                    ),
                  ))
            ],
          ),
        ],
        Row(
          children: <Widget>[
            DropdownWidget(
              list: descriptionMaster,
              selectedValue: selectDescription,
              label: 'Select Description',
              onValueChanged: (value) {
                selectDescription = value.toString();
                List desc =
                    descriptionMaster.where((e) => e['Name'] == value).toList();
                particularsList = desc[0]['Options'];
                List select = descriptionMaster
                    .where((element) => element['Name'] == value.toString())
                    .toList();
                String id = select[0]['Id'].toString();
                descriptionCtrl.text = id;
                rowValue();
                setState(() {});
              },
            ),
            const SizedBox(width: 10),
            DropdownWidget(
              list: particularsList,
              selectedValue: selectParticular,
              label: 'Select Particulars',
              onValueChanged: (value) {
                selectParticular = value.toString();
                List select = particularsList
                    .where((element) => element['Name'] == value.toString())
                    .toList();
                String id = select[0]['Id'].toString();
                particularsCtrl.text = id;
                rowValue();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              child: TextFormField(
                controller: lengthCtrl,
                onChanged: (value) {
                  calculateTotalValue(value, widthCtrl.text);
                  setState(() {});
                },
                keyboardType: TextInputType.number,
                decoration: styleWidget("Length"),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: TextFormField(
                controller: widthCtrl,
                onChanged: (value) {
                  calculateTotalValue(lengthCtrl.text, value);
                  setState(() {});
                },
                keyboardType: TextInputType.number,
                decoration: styleWidget('Width'),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: TextFormField(
                controller: totalCtrl,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Total",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 5),
      ],
    );
  }

  @override
  void initState() {
    getDescription();
    setState(() {
      lengthCtrl.text = '0';
      widthCtrl.text = '0';
      totalCtrl.text = '0';
    });

    Future.delayed(const Duration(seconds: 1), () {
      print("desc -> ${rowDetail['Description']}");
      rowDetail = widget.value;
      print("rowDetail -> $rowDetail");
      List desc = descriptionMaster
          .where((e) => e['Id'] == rowDetail['Description'].toString())
          .toList();
      if (desc.isNotEmpty) {
        selectDescription = desc[0]['Name'];
        particularsList = desc[0]['Options'];
      }

      List desc1 = particularsList
          .where((e) => e['Id'] == rowDetail['Particulars'].toString())
          .toList();
      if (desc1.isNotEmpty) {
        selectParticular = desc1[0]['Name'];
      }
      lengthCtrl.text = rowDetail['Length'].toString();
      widthCtrl.text = rowDetail['Width'].toString();
      totalCtrl.text = rowDetail['Total'].toString();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getDescription() async {
    DropdownServices ddService = DropdownServices();
    List list = await ddService.read();
    setState(() {
      sizeTypeList = list
          .where((e) => e['Type'].toString() == "MeasurementSheetType")
          .toList();
      List desc =
          sizeTypeList.where((e) => e['Id'] == widget.sheetType).toList();
      if (desc.isNotEmpty) {
        descriptionMaster = jsonDecode(desc[0]['Options']);
      }
    });
  }

  calculateTotalValue(length, width) {
    length = length == '' ? '0' : length;
    width = width == '' ? '0' : width;
    totalCtrl.text = (double.parse(length) * double.parse(width)).toString();
    rowValue();
  }

  styleWidget(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
  }

  rowValue() {
    Map<String, Object> controller = {
      "Description": descriptionCtrl.text,
      "Id": rowDetail['Id'].toString() == "" ? "0" : rowDetail['Id'].toString(),
      "IsDeleted": rowDetail['IsDeleted'],
      "Length": lengthCtrl.text,
      "Particulars": particularsCtrl.text,
      "SheetType": "measurement",
      "Total": totalCtrl.text,
      "Width": widthCtrl.text,
    };
    widget.onValueChanged(controller);
  }
}
