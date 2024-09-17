import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_widgets/alert_widget.dart';
import '../../../app_widgets/custom_dropdown_form.dart';
import '../../../app_widgets/index.dart';

class OccupancyForm extends StatefulWidget {
  final VoidCallback buttonSubmitted;
  final String propId;
  const OccupancyForm(
      {super.key, required this.buttonSubmitted, required this.propId});

  @override
  State<OccupancyForm> createState() => _OccupancyFormState();
}

class _OccupancyFormState extends State<OccupancyForm> {
  DropdownServices dropdownServices = DropdownServices();
  OccupancyServices occupancyServices = OccupancyServices();

  List statusOfOccupancy = [];
  List relationship = [];
  List _od = [];

  TextEditingController statusOfOccupancyCtrl = TextEditingController();
  TextEditingController occupiedCtrl = TextEditingController();
  TextEditingController relationshipCtrl = TextEditingController();
  TextEditingController occupiedSinceCtrl = TextEditingController();
  TextEditingController personMetAtSiteCtrl = TextEditingController();
  TextEditingController personMetAtSiteContNoCtrl = TextEditingController();
  String selectedStatusOfOccupancy = '';
  String selectedRelationship = '';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    getStatusOfOccupancy();
    getRelationshipOfOccupantWithCustomer();
    Future.delayed(const Duration(seconds: 0), () {
      getOccupancy(widget.propId);
    });
    super.initState();
  }

  getOccupancy(id) async {
    _od = await occupancyServices.read(id);
    statusOfOccupancyCtrl.text = _od[0]['StatusOfOccupancy'];
    occupiedCtrl.text = _od[0]['OccupiedBy'];
    relationshipCtrl.text = _od[0]['RelationshipOfOccupantWithCustomer'];
    occupiedSinceCtrl.text = _od[0]['OccupiedSince'];
    personMetAtSiteCtrl.text = _od[0]['PersonMetAtSite'];
    personMetAtSiteContNoCtrl.text = _od[0]['PersonMetAtSiteContNo'];
    List sList = statusOfOccupancy
        .where((e) => e['Id'] == statusOfOccupancyCtrl.text.toString())
        .toList();
    if (sList.isNotEmpty) {
      selectedStatusOfOccupancy = sList[0]['Name'].toString();
    }

    List rList = relationship
        .where((e) => e['Id'] == relationshipCtrl.text.toString())
        .toList();
    if (rList.isNotEmpty) {
      selectedRelationship = rList[0]['Name'].toString();
    }

    setState(() {});
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    super.dispose();
  }

  Future<void> getStatusOfOccupancy() async {
    List list = await dropdownServices.read();
    statusOfOccupancy = list
        .where((element) => element['Type'] == 'StatusOfOccupancy')
        .toList();
    setState(() {});
  }

  Future<void> getRelationshipOfOccupantWithCustomer() async {
    List list = await dropdownServices.read();
    relationship = list
        .where((element) =>
            element['Type'] == 'RelationshipOfOccupantWithCustomer')
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomTheme.defaultSize,
            CustomDropdown(
              title: 'Status of Occupancy',
              itemList: statusOfOccupancy.map((e) => e['Name']).toList(),
              selectedItem: selectedStatusOfOccupancy,
              onChanged: (value) {
                List select = statusOfOccupancy
                    .where((element) => element['Name'] == value.toString())
                    .toList();
                String id = select[0]['Id'].toString();
                setState(() {
                  statusOfOccupancyCtrl.text = id;
                });
              },
            ),
            CustomTheme.defaultSize,
            CustomTextFormField(
              title: 'Occupied by',
              controller: occupiedCtrl,
            ),
            CustomTheme.defaultSize,
            CustomDropdown(
              title: 'Relationship of occupant with customer',
              itemList: relationship.map((e) => e['Name']).toList(),
              selectedItem: selectedRelationship,
              onChanged: (value) {
                selectedRelationship = value;

                List select = relationship
                    .where((element) => element['Name'] == value.toString())
                    .toList();
                String id = select[0]['Id'].toString();
                relationshipCtrl.text = id;
                setState(() {});
              },
            ),
            CustomTheme.defaultSize,
            CustomTextFormField(
              title: 'Occupied Since',
              controller: occupiedSinceCtrl,
              textInputAction: TextInputAction.done,
            ),
            CustomTheme.defaultSize,
            CustomTextFormField(
              title: 'Person Met at Site',
              controller: personMetAtSiteCtrl,
              textInputAction: TextInputAction.done,
            ),
            CustomTheme.defaultSize,
            CustomTextFormField(
              title: 'Person Met Contact No',
              controller: personMetAtSiteContNoCtrl,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
            ),
            CustomTheme.defaultSize,
            AppButton(
                title: "Save & Next",
                onPressed: () async {
                  List<String> request = [
                    occupiedCtrl.text.isEmpty?"0":occupiedCtrl.text,
                    occupiedSinceCtrl.text.isEmpty?"0":occupiedSinceCtrl.text,
                    relationshipCtrl.text.isEmpty?"0":relationshipCtrl.text,
                    statusOfOccupancyCtrl.text.isEmpty?"0":statusOfOccupancyCtrl.text,
                    personMetAtSiteCtrl.text.toString(),
                    personMetAtSiteContNoCtrl.text.toString(),
                    'N',
                    widget.propId.toString()
                  ];
                  // print(request);
                  var result = await occupancyServices.update(request);
                  if (result == 1) {
                    AlertService().successToast("Occupancy Saved");
                    widget.buttonSubmitted();
                  } else {
                    AlertService().errorToast("Failure!");
                  }
                }),
            CustomTheme.defaultSize,
          ],
        ),
      ),
    );
  }
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
