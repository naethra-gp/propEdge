import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:proequity/app_widgets/custom_multiple_dropdown_form.dart';

import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_widgets/alert_widget.dart';
import '../../../app_widgets/custom_dropdown_form.dart';
import '../../../app_widgets/index.dart';

class FeedbackForm extends StatefulWidget {
  final VoidCallback buttonSubmitted;
  final String propId;
  const FeedbackForm(
      {super.key, required this.buttonSubmitted, required this.propId});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  DropdownServices dropdownServices = DropdownServices();
  FeedbackServices feedbackServices = FeedbackServices();

  List amenities = [];
  List maintenance = [];
  List selectedAmenities = [];
  List _fd = [];
  String selectedMaintenance = '';

  TextEditingController amenitiesCtrl = TextEditingController();
  TextEditingController maintenanceCtrl = TextEditingController();
  TextEditingController ageOfPropertyCtrl = TextEditingController();
  final dropDownKey = GlobalKey<DropdownSearchState>();

  @override
  void initState() {
    getAmenities();
    Future.delayed(const Duration(seconds: 0), () {
      getFeedback(widget.propId);
    });
    super.initState();
  }

  getFeedback(id) async {
    _fd = await feedbackServices.read(id);
    print(_fd);
    selectedAmenities = _fd[0]['Amenities'].toString().trim().split(",");
    if (selectedAmenities.toString() == "[]") {
      selectedAmenities = [];
    }
    amenitiesCtrl.text = _fd[0]['Amenities'];
    maintenanceCtrl.text = _fd[0]['MaintainanceLevel'];
    ageOfPropertyCtrl.text = _fd[0]['ApproxAgeOfProperty'];
    List mList = maintenance
        .where((e) => e['Id'] == maintenanceCtrl.text.toString())
        .toList();
    if (mList.isNotEmpty) {
      selectedMaintenance = mList[0]['Name'].toString();
    }
    setState(() {});
  }

  Future<void> getAmenities() async {
    List list = await dropdownServices.read();
    amenities =
        list.where((element) => element['Type'] == 'Amenities').toList();
    maintenance =
        list.where((element) => element['Type'] == 'MaintenanceLevel').toList();
    setState(() {});
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    super.dispose();
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
            CustomMultipleDropdown(
              key: dropDownKey,
              title: 'Amenities',
              itemList: amenities.map((e) => e['Name']).toList(),
              selectedItems: selectedAmenities,
              onChanged: (value) {
                print(value);
                selectedAmenities = value;
                // if (value.isEmpty) {
                //   amenitiesCtrl.text = "[]";
                // } else {
                //   amenitiesCtrl.text = value.toString().trim();
                // }
                setState(() {});
              },
            ),
            CustomTheme.defaultSize,
            CustomDropdown(
              title: 'Maintenance Level',
              itemList: maintenance.map((e) => e['Name']).toList(),
              selectedItem: selectedMaintenance,
              onChanged: (value) {
                List select = maintenance
                    .where((element) => element['Name'] == value.toString())
                    .toList();
                String id = select[0]['Id'].toString();
                setState(() {
                  maintenanceCtrl.text = id;
                });
              },
            ),
            CustomTheme.defaultSize,
            CustomTextFormField(
              title: 'Approx. Age of Property',
              textInputAction: TextInputAction.done,
              controller: ageOfPropertyCtrl,
            ),
            CustomTheme.defaultSize,
            AppButton(
                title: "Save & Next",
                onPressed: () async {
                  List<String> request = [
                    selectedAmenities
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', ''),
                    ageOfPropertyCtrl.text,
                    maintenanceCtrl.text,
                    'N',
                    widget.propId.toString()
                  ];
                  var result = await feedbackServices.update(request);
                  if (result == 1) {
                    AlertService().successToast("Feedback Saved");
                    widget.buttonSubmitted();
                  } else {
                    AlertService().errorToast("Feedback Failure!");
                  }
                }),
            CustomTheme.defaultSize,
          ],
        ),
      ),
    );
  }
}
