import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proequity/app_services/sqlite/sqlite_services.dart';
import 'package:proequity/app_widgets/alert_widget.dart';
import '../../../app_config/app_constants.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_widgets/custom_dropdown_form.dart';
import '../../../app_widgets/index.dart';

class PropertyLocationForm extends StatefulWidget {
  final VoidCallback buttonClicked;
  final String propId;

  const PropertyLocationForm(
      {super.key, required this.buttonClicked, required this.propId});

  @override
  State<PropertyLocationForm> createState() => _PropertyLocationFormState();
}

class _PropertyLocationFormState extends State<PropertyLocationForm> {
  List cityList = [];
  List propertyType = [];
  List locationDetails = [];
  String addressMatching = "Yes";
  String municipalBody = "Yes";
  String selectedCity = "";
  String selectedProperty = "";

  PropertyLocationServices propertyLocationServices =
      PropertyLocationServices();

  DropdownServices dropdownServices = DropdownServices();

  TextEditingController cityControl = TextEditingController();
  TextEditingController colonyControl = TextEditingController();
  TextEditingController addressControl = TextEditingController();
  TextEditingController matchingControl = TextEditingController();
  TextEditingController municipalControl = TextEditingController();
  TextEditingController municipalNameControl = TextEditingController();
  TextEditingController propertyTypeCtrl = TextEditingController();
  TextEditingController floorCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    debugPrint("----> Property Location <----");
    getCity();
    Future.delayed(const Duration(seconds: 0), () {
      getPropertyLocationDetails(widget.propId);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Fluttertoast.cancel();
    cityControl.dispose();
    colonyControl.dispose();
    addressControl.dispose();
    matchingControl.dispose();
    municipalControl.dispose();
    propertyTypeCtrl.dispose();
    floorCtrl.dispose();
    municipalNameControl.dispose();
  }

  Future<void> getCity() async {
    List list = await dropdownServices.read();
    cityList = list.where((element) => element['Type'] == 'City').toList();
    propertyType = list.where((element) => element['Type'] == 'PropertyType').toList();
    setState(() {});
  }

  getPropertyLocationDetails(id) async {
    locationDetails = await propertyLocationServices.getPropertyLocation(id);
    if (locationDetails.isNotEmpty) {
      colonyControl.text = locationDetails[0]['Colony'];
      addressControl.text = locationDetails[0]['PropertyAddressAsPerSite'];
      addressMatching = locationDetails[0]['AddressMatching'] ?? "";
      municipalBody = locationDetails[0]['LocalMuniciapalBody'] ?? "";
      municipalNameControl.text = locationDetails[0]['NameOfMunicipalBody'];
      List cl = cityList
          .where((e) => e['Id'] == locationDetails[0]['City'])
          .toList();
      if (cl.isNotEmpty) {
        selectedCity = cl[0]['Name'].toString();
      }
      List pt = propertyType
          .where((e) => e['Id'] == locationDetails[0]['PropertyType'])
          .toList();
      if (pt.isNotEmpty) {
        selectedProperty = pt[0]['Name'].toString();
      }
      floorCtrl.text = locationDetails[0]['TotalFloors'];
      cityControl.text = locationDetails[0]['City'];
      setState(() {});
    } else {
      AlertService().errorToast("No data found! Sync again...");
      Navigator.pushReplacementNamed(context, "mainPage", arguments: 2);
      return false;

    }

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              CustomDropdown(
                title: 'City',
                itemList: cityList.map((e) => e['Name']).toList(),
                selectedItem: selectedCity,
                onChanged: (value) {
                  List selectedCountry = cityList
                      .where((element) => element['Name'] == value.toString())
                      .toList();
                  String id = selectedCountry[0]['Id'].toString();
                  setState(() {
                    cityControl.text = id;
                  });
                },
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                title: 'Colony',
                controller: colonyControl,
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                controller: addressControl,
                required: true,
                title: 'Property Address as per site',
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Property Address is Mandatory!';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              CustomTheme.defaultSize,

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Address Matching",
                  style: CustomTheme.formLabelStyle,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text('Yes'),
                      style: ListTileStyle.list,
                      leading: Radio(
                        value: "Yes",
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        groupValue: addressMatching,
                        onChanged: (value) {
                          addressMatching = value.toString();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('No'),
                      style: ListTileStyle.list,
                      leading: Radio(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        value: "No",
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        groupValue: addressMatching,
                        onChanged: (value) {
                          addressMatching = value.toString();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              CustomTheme.defaultSize,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Jurisdiction/Local Municipal Body",
                  style: CustomTheme.formLabelStyle,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: const Text('Yes'),
                      leading: Radio(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        value: "Yes",
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        groupValue: municipalBody,
                        onChanged: (value) {
                          municipalBody = value.toString();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('No'),
                      leading: Radio(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        value: "No",
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        groupValue: municipalBody,
                        onChanged: (value) {
                          municipalBody = value.toString();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                title: 'Name of Municipal Body',
                textInputAction: TextInputAction.done,
                controller: municipalNameControl,
              ),
              CustomTheme.defaultSize,
              CustomDropdown(
                title: 'Property Type',
                itemList: propertyType.map((e) => e['Name']).toList(),
                selectedItem: selectedProperty,
                onChanged: (value) {
                  List selectedCountry = propertyType
                      .where((element) => element['Name'] == value.toString())
                      .toList();
                  String id = selectedCountry[0]['Id'].toString();
                  setState(() {
                    propertyTypeCtrl.text = id;
                  });
                },
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                title: 'Floor/Structure',
                controller: floorCtrl,
              ),
              CustomTheme.defaultSize,
              AppButton(
                title: "Save & Next",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    List<String> r = [
                      cityControl.text,
                      colonyControl.text.toString(),
                      addressControl.text.toString(),
                      addressMatching.toString(),
                      municipalBody.toString(),
                      municipalNameControl.text.toString(),
                      propertyTypeCtrl.text.toString(),
                      floorCtrl.text.toString(),
                      'N',
                      widget.propId.toString()
                    ];
                    var result = await propertyLocationServices.update(r);
                    // AlertService().alert(context, result.toString());
                    if (result == 1) {
                      PropertyListServices service = PropertyListServices();
                      List request = [
                        Constants.status[1],
                        "N",
                        widget.propId.toString()
                      ];
                      await service.updateLocalStatus(request);
                      AlertService().successToast("Property Saved");
                      widget.buttonClicked();
                    } else {
                      AlertService().errorToast("Property Failure!");
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
