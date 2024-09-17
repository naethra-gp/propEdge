import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proequity/app_config/app_validators.dart';
import 'package:proequity/app_widgets/alert_widget.dart';

import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_widgets/custom_dropdown_form.dart';
import '../../../app_widgets/custom_multiple_dropdown_form.dart';
import '../../../app_widgets/index.dart';

class LocationDetailForm extends StatefulWidget {
  final VoidCallback buttonSubmitted;
  final String propId;

  const LocationDetailForm(
      {super.key, required this.buttonSubmitted, required this.propId});

  @override
  State<LocationDetailForm> createState() => _LocationDetailFormState();
}

class _LocationDetailFormState extends State<LocationDetailForm> {
  DropdownServices dropdownServices = DropdownServices();
  LocationDetailServices locationDetailServices = LocationDetailServices();

  List surroundingArea = [];
  List natureOfLocality = [];
  List classOfLocality = [];
  List proximityFromCivicsAmenities = [];
  List siteAccess = [];
  List _ld = [];

  /// CONTROLLER NAMES
  TextEditingController nearByLocationCtrl = TextEditingController();
  TextEditingController microMarketCtrl = TextEditingController();
  TextEditingController latCtrl = TextEditingController();
  TextEditingController lonCtrl = TextEditingController();
  TextEditingController surroundingAreaCtrl = TextEditingController();
  TextEditingController natureOfLocalityCtrl = TextEditingController();
  TextEditingController classOfLocalityCtrl = TextEditingController();
  TextEditingController civicsAmenitiesCtrl = TextEditingController();
  TextEditingController railwayCtrl = TextEditingController();
  TextEditingController metroCtrl = TextEditingController();
  TextEditingController busStopCtrl = TextEditingController();
  TextEditingController roadCtrl = TextEditingController();
  TextEditingController siteAccessCtrl = TextEditingController();
  TextEditingController neighborhoodCtrl = TextEditingController();
  TextEditingController nearestHospitalCtrl = TextEditingController();
  TextEditingController localityCtrl = TextEditingController();

  /// DROPDOWN SELECTED VALUE ---
  String selectedSurroundingArea = '';
  String selectedNatureOfLocality = '';
  String selectedClassOfLocality = '';
  List selectedCivicsAmenities = [];
  String selectedSiteAccess = '';

  String coordinates = "No Location found";
  String address = 'No Address found';
  bool scanning = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // checkPermission();
    debugPrint("---> Location Details Form <--- ");
    getSiteAccess();
    getInfrastructureOfTheSurroundingArea();
    getNatureOfLocality();
    getClassOfLocality();
    getProximityFromCivicsAmenities();

    Future.delayed(const Duration(seconds: 1), () {
      getLocationDetails(widget.propId);
    });
    super.initState();
  }

  checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // AlertService().hideLoading();
      await Geolocator.openLocationSettings();
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // AlertService().hideLoading();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Request Denied !');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Denied Forever !');
      return;
    }
    getLocation();
  }

  getLocationDetails(id) async {
    _ld = await locationDetailServices.read(id);
    if (_ld.isNotEmpty) {
      nearByLocationCtrl.text = _ld[0]['NearbyLandmark'] ?? "";
      microMarketCtrl.text = _ld[0]['Micromarket'];
      surroundingAreaCtrl.text = _ld[0]['InfrastructureOfTheSurroundingArea'];
      List sArea = surroundingArea
          .where((e) => e['Id'] == surroundingAreaCtrl.text.toString())
          .toList();
      if (sArea.isNotEmpty) {
        selectedSurroundingArea = sArea[0]['Name'].toString();
      }

      natureOfLocalityCtrl.text = _ld[0]['NatureOfLocality'];
      List nList = natureOfLocality
          .where((e) => e['Id'] == natureOfLocalityCtrl.text.toString())
          .toList();
      if (nList.isNotEmpty) {
        selectedNatureOfLocality = nList[0]['Name'].toString();
      }

      classOfLocalityCtrl.text = _ld[0]['ClassOfLocality'];
      List cList = classOfLocality
          .where((e) => e['Id'] == classOfLocalityCtrl.text.toString())
          .toList();
      if (cList.isNotEmpty) {
        selectedClassOfLocality = cList[0]['Name'].toString();
      }

      civicsAmenitiesCtrl.text = _ld[0]['ProximityFromCivicsAmenities'] ?? "";
      if (civicsAmenitiesCtrl.text.split(",").isNotEmpty) {
        selectedCivicsAmenities =
            civicsAmenitiesCtrl.text.toString().trim().split(",");
      }
      if (selectedCivicsAmenities.toString() == "[]") {
        selectedCivicsAmenities = [];
      }

      print(_ld[0]['Latitude']);
      latCtrl.text = _ld[0]['Latitude'];
      lonCtrl.text = _ld[0]['Longitude'];
      railwayCtrl.text = _ld[0]['NearestRailwayStation'];
      metroCtrl.text = _ld[0]['NearestMetroStation'];
      busStopCtrl.text = _ld[0]['NearestBusStop'];
      roadCtrl.text = _ld[0]['ConditionAndWidthOfApproachRoad'];

      siteAccessCtrl.text = _ld[0]['SiteAccess'];
      List sList = siteAccess
          .where((e) => e['Id'] == siteAccessCtrl.text.toString())
          .toList();
      if (sList.isNotEmpty) {
        selectedSiteAccess = sList[0]['Name'].toString();
      }

      neighborhoodCtrl.text = _ld[0]['NeighborhoodType'] ?? "";
      nearestHospitalCtrl.text = _ld[0]['NearestHospital'];
      localityCtrl.text = _ld[0]['AnyNegativeToTheLocality'];
      setState(() {});
    } else {
      AlertService().errorToast("No data found! Sync again...");
      Navigator.pushReplacementNamed(context, "mainPage", arguments: 2);
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomTheme.defaultSize,
              CustomTextFormField(
                title: 'Near By Landmark',
                maxLines: 1,
                controller: nearByLocationCtrl,
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                title: 'MicroMarket/Locality',
                maxLines: 1,
                controller: microMarketCtrl,
              ),
              CustomTheme.defaultSize,
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomTextFormField(
                      title: 'Latitude',
                      controller: latCtrl,
                      required: true,
                      readOnly: true,
                      validator: (value) => Validators.isEmpty(value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextFormField(
                      title: 'Longitude',
                      controller: lonCtrl,
                      suffixIconTrue: true,
                      suffixIcon: Icons.gps_fixed,
                      validator: (value) => Validators.isEmpty(value),
                      suffixIconOnPressed: checkPermission,
                      readOnly: true,
                      required: true,
                    ),
                  ),
                ],
              ),
              CustomTheme.defaultSize,
              CustomDropdown(
                title: 'Infrastructure of the surrounding area',
                itemList: surroundingArea.map((e) => e['Name']).toList(),
                selectedItem: selectedSurroundingArea,
                onChanged: (value) {
                  List select = surroundingArea
                      .where((element) => element['Name'] == value.toString())
                      .toList();
                  String id = select[0]['Id'].toString();
                  setState(() {
                    surroundingAreaCtrl.text = id;
                  });
                },
              ),
              CustomTheme.defaultSize,
              CustomDropdown(
                title: 'Nature of Locality',
                itemList: natureOfLocality.map((e) => e['Name']).toList(),
                selectedItem: selectedNatureOfLocality,
                onChanged: (value) {
                  List select = natureOfLocality
                      .where((element) => element['Name'] == value.toString())
                      .toList();
                  String id = select[0]['Id'].toString();
                  setState(() {
                    natureOfLocalityCtrl.text = id;
                  });
                },
              ),
              CustomTheme.defaultSize,
              CustomDropdown(
                title: 'Class of Locality',
                itemList: classOfLocality.map((e) => e['Name']).toList(),
                selectedItem: selectedClassOfLocality,
                onChanged: (value) {
                  List select = classOfLocality
                      .where((element) => element['Name'] == value.toString())
                      .toList();
                  String id = select[0]['Id'].toString();
                  setState(() {
                    classOfLocalityCtrl.text = id;
                  });
                },
              ),
              CustomTheme.defaultSize,
              CustomMultipleDropdown(
                title: 'Proximity from civics amenities /public transport',
                itemList:
                    proximityFromCivicsAmenities.map((e) => e['Name']).toList(),
                selectedItems: selectedCivicsAmenities,
                onChanged: (value) {
                  selectedCivicsAmenities = value;
                  setState(() {});
                },
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                title: 'Nearest Railway Station',
                controller: railwayCtrl,
                maxLines: 1,
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                title: 'Nearest Metro Station',
                controller: metroCtrl,
                maxLines: 1,
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                title: 'Nearest Bus Stop',
                controller: busStopCtrl,
                maxLines: 1,
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                title: 'Condition & Width of approach Road',
                controller: roadCtrl,
                maxLines: 1,
              ),
              CustomTheme.defaultSize,
              CustomDropdown(
                title: 'Site Access',
                itemList: siteAccess.map((e) => e['Name']).toList(),
                selectedItem: selectedSiteAccess,
                onChanged: (value) {
                  List select = siteAccess
                      .where((element) => element['Name'] == value.toString())
                      .toList();
                  String id = select[0]['Id'].toString();
                  setState(() {
                    siteAccessCtrl.text = id;
                  });
                },
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                controller: neighborhoodCtrl,
                title: 'Neighborhood Type',
                maxLines: 1,
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                controller: nearestHospitalCtrl,
                title: 'Nearest Hospital',
                maxLines: 1,
              ),
              CustomTheme.defaultSize,
              CustomTextFormField(
                controller: localityCtrl,
                title: 'Any negative to the locality',
                textInputAction: TextInputAction.done,
              ),
              CustomTheme.defaultSize,
              AppButton(
                title: "Save & Next",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    List<String> request = [
                      nearByLocationCtrl.text.toString().trim(),
                      microMarketCtrl.text.toString().trim(),
                      latCtrl.text.toString(),
                      lonCtrl.text.toString(),
                      surroundingAreaCtrl.text.toString().trim(),
                      natureOfLocalityCtrl.text.toString().trim(),
                      classOfLocalityCtrl.text.toString().trim(),
                      selectedCivicsAmenities
                          .toString()
                          .replaceAll('[', '')
                          .replaceAll(']', '')
                          .trim(),
                      railwayCtrl.text.toString().trim(),
                      metroCtrl.text.toString().trim(),
                      busStopCtrl.text.toString().trim(),
                      roadCtrl.text.toString().trim(),
                      siteAccessCtrl.text.toString().trim(),
                      neighborhoodCtrl.text.toString().trim(),
                      nearestHospitalCtrl.text.toString().trim(),
                      localityCtrl.text.toString().trim(),
                      'N',
                      widget.propId.toString()
                    ];
                    var result = await locationDetailServices.update(request);
                    if (result == 1) {
                      AlertService().successToast("Location Saved");
                      widget.buttonSubmitted();
                    } else {
                      AlertService().errorToast("Location Failure!");
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

  @override
  void dispose() {
    Fluttertoast.cancel();
    nearByLocationCtrl.dispose();
    microMarketCtrl.dispose();
    latCtrl.dispose();
    lonCtrl.dispose();
    surroundingAreaCtrl.dispose();
    natureOfLocalityCtrl.dispose();
    classOfLocalityCtrl.dispose();
    civicsAmenitiesCtrl.dispose();
    railwayCtrl.dispose();
    metroCtrl.dispose();
    busStopCtrl.dispose();
    roadCtrl.dispose();
    siteAccessCtrl.dispose();
    neighborhoodCtrl.dispose();
    nearestHospitalCtrl.dispose();
    localityCtrl.dispose();
    super.dispose();
  }

  Future<void> getSiteAccess() async {
    List list = await dropdownServices.read();
    siteAccess =
        list.where((element) => element['Type'] == 'SiteAccess').toList();
    setState(() {});
  }

  Future<void> getInfrastructureOfTheSurroundingArea() async {
    List list = await dropdownServices.read();
    surroundingArea = list
        .where((element) =>
            element['Type'] == 'InfrastructureOfTheSurroundingArea')
        .toList();
    setState(() {});
  }

  Future<void> getNatureOfLocality() async {
    List list = await dropdownServices.read();
    natureOfLocality =
        list.where((element) => element['Type'] == 'NatureOfLocality').toList();
    setState(() {});
  }

  Future<void> getClassOfLocality() async {
    List list = await dropdownServices.read();
    classOfLocality =
        list.where((element) => element['Type'] == 'ClassOfLocality').toList();
    setState(() {});
  }

  Future<void> getProximityFromCivicsAmenities() async {
    List list = await dropdownServices.read();
    proximityFromCivicsAmenities = list
        .where((element) => element['Type'] == 'ProximityFromCivicsAmenities')
        .toList();
    setState(() {});
  }

  void getLocation() async {
    AlertService().showLoading();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.reduced);
    latCtrl.text = position.latitude.toString();
    lonCtrl.text = position.longitude.toString();
    AlertService().hideLoading();
    setState(() {});
  }
}
