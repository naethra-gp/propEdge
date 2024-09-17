import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/critical_comments_form.dart';
import 'package:proequity/app_pages/site_visit_form/view_site_visit_form/widget/boundary_view_widget.dart';
import 'package:proequity/app_pages/site_visit_form/view_site_visit_form/widget/calculator_view_widget.dart';
import 'package:proequity/app_pages/site_visit_form/view_site_visit_form/widget/feedback_view_widget.dart';
import 'package:proequity/app_pages/site_visit_form/view_site_visit_form/widget/Uploads_view_widget.dart';
import 'package:proequity/app_pages/site_visit_form/view_site_visit_form/widget/measurement_view_widget.dart';

import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_widgets/index.dart';
import 'widget/customer_view_widget.dart';
import 'widget/location_view_widget.dart';
import 'widget/occupancy_view_widget.dart';
import 'widget/property_view_widget.dart';
import 'widget/stage_calculator_view_widget.dart';

class ViewSiteVisitForm extends StatefulWidget {
  final String propId;

  const ViewSiteVisitForm({super.key, required this.propId});

  @override
  State<ViewSiteVisitForm> createState() => _ViewSiteVisitFormState();
}

class _ViewSiteVisitFormState extends State<ViewSiteVisitForm> {
  CustomerService customerService = CustomerService();
  PropertyLocationServices plService = PropertyLocationServices();
  LocationDetailServices ldService = LocationDetailServices();
  OccupancyServices occupancyServices = OccupancyServices();
  FeedbackServices feedbackServices = FeedbackServices();
  BoundaryServices boundaryServices = BoundaryServices();
  MeasurementServices measurementServices = MeasurementServices();
  CalculatorService calculatorService = CalculatorService();
  UploadLocationMapService locationMapService = UploadLocationMapService();
  SketchService sketchService = SketchService();
  CommentsServices commentsServices = CommentsServices();
  PhotographService photographService = PhotographService();
  DropdownServices dropdownServices = DropdownServices();

  List customerDetails = [];
  List propertyDetails = [];
  List locationDetails = [];
  List occupancyDetails = [];
  List feedbackDetails = [];
  List boundaryDetails = [];
  List measurementDetails = [];
  List calculatorDetails = [];
  List criticalCommentsDetails = [];
  List locationMapDetails = [];
  List sketchDetails = [];
  List photographDetails = [];

  String selectedCity = "";
  String propertyType = "";
  String selectedSurroundingArea = "";
  String selectedNatureOfLocality = "";
  String selectedClassOfLocality = "";
  String selectedStatusOfOccupancy = "";
  String selectedRelationship = "";
  @override
  void initState() {
    getPropIdBaseDetails(widget.propId);
    super.initState();
  }

  getPropIdBaseDetails(String propId) async {
    customerDetails = await customerService.readById(propId);
    propertyDetails = await plService.readById(propId);
    locationDetails = await ldService.readById(propId);
    occupancyDetails = await occupancyServices.readById(propId);
    feedbackDetails = await feedbackServices.readById(propId);
    boundaryDetails = await boundaryServices.readById(propId);
    measurementDetails = await measurementServices.readById(propId);
    calculatorDetails = await calculatorService.read(propId);
    locationMapDetails = await locationMapService.read(propId);
    sketchDetails = await sketchService.read(propId);
    photographDetails = await photographService.read(propId);
    criticalCommentsDetails = await commentsServices.read(propId);

    setState(() {});
    getCity();
    getInfrastructureOfTheSurroundingArea();
    getNatureOfLocality();
    getClassOfLocality();
    getStatusOfOccupancy();
    getRelationshipOfOccupantWithCustomer();
  }

  Future<void> getCity() async {
    List list = await dropdownServices.read();
    List cityList = list.where((element) => element['Type'] == 'City').toList();
    List propertyTypeList = list.where((element) => element['Type'] == 'PropertyType').toList();
    selectedCity = cityList
        .where((e) => e['Id'] == propertyDetails[0]['City'])
        .toList()[0]['Name']
        .toString();
    propertyType = propertyTypeList
        .where((e) => e['Id'] == propertyDetails[0]['PropertyType'])
        .toList()[0]['Name']
        .toString();
    setState(() {});
  }

  Future<void> getInfrastructureOfTheSurroundingArea() async {
    List list = await dropdownServices.read();
    List surroundingArea = list
        .where((element) =>
            element['Type'] == 'InfrastructureOfTheSurroundingArea')
        .toList();
    List sArea = surroundingArea
        .where((e) =>
            e['Id'] ==
            locationDetails[0]['InfrastructureOfTheSurroundingArea'].toString())
        .toList();
    if (sArea.isNotEmpty) {
      selectedSurroundingArea = sArea[0]['Name'].toString();
    }
    setState(() {});
  }

  Future<void> getNatureOfLocality() async {
    List list = await dropdownServices.read();
    List natureOfLocality =
        list.where((element) => element['Type'] == 'NatureOfLocality').toList();

    List nList = natureOfLocality
        .where(
            (e) => e['Id'] == locationDetails[0]['NatureOfLocality'].toString())
        .toList();
    if (nList.isNotEmpty) {
      selectedNatureOfLocality = nList[0]['Name'].toString();
    }
    setState(() {});
  }

  Future<void> getClassOfLocality() async {
    List list = await dropdownServices.read();
    List classOfLocality =
        list.where((element) => element['Type'] == 'ClassOfLocality').toList();
    List cList = classOfLocality
        .where(
            (e) => e['Id'] == locationDetails[0]['ClassOfLocality'].toString())
        .toList();
    if (cList.isNotEmpty) {
      selectedClassOfLocality = cList[0]['Name'].toString();
    }

    setState(() {});
  }

  Future<void> getStatusOfOccupancy() async {
    List list = await dropdownServices.read();
    List statusOfOccupancy = list
        .where((element) => element['Type'] == 'StatusOfOccupancy')
        .toList();
    List sList = statusOfOccupancy
        .where((e) =>
            e['Id'] == occupancyDetails[0]['StatusOfOccupancy'].toString())
        .toList();
    if (sList.isNotEmpty) {
      selectedStatusOfOccupancy = sList[0]['Name'].toString();
    }

    setState(() {});
  }

  Future<void> getRelationshipOfOccupantWithCustomer() async {
    List list = await dropdownServices.read();
    List relationship = list
        .where((element) =>
            element['Type'] == 'RelationshipOfOccupantWithCustomer')
        .toList();
    List rList = relationship
        .where((e) =>
            e['Id'] ==
            occupancyDetails[0]['RelationshipOfOccupantWithCustomer']
                .toString())
        .toList();
    if (rList.isNotEmpty) {
      selectedRelationship = rList[0]['Name'].toString();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "View Site Visit",
        action: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CustomTheme.defaultSize,
              if (customerDetails.isNotEmpty) ...[
                const Text(
                  "Customer Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomerViewWidget(
                  details: customerDetails,
                ),
                CustomTheme.defaultSize,
              ],
              CustomTheme.defaultSize,
              if (propertyDetails.isNotEmpty) ...[
                const Text(
                  "Property Location Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PropertyViewWidget(
                  details: propertyDetails,
                  city: selectedCity,
                  propertyType: propertyType,
                ),
                CustomTheme.defaultSize,
              ],
              CustomTheme.defaultSize,
              if (locationDetails.isNotEmpty) ...[
                const Text(
                  "Location Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                LocationViewWidget(
                    details: locationDetails,
                    infra: selectedSurroundingArea,
                    natureloc: selectedNatureOfLocality,
                    classloc: selectedClassOfLocality),
                CustomTheme.defaultSize,
              ],
              CustomTheme.defaultSize,
              if (occupancyDetails.isNotEmpty) ...[
                const Text(
                  "Occupancy Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OccupancyViewWidget(
                  details: occupancyDetails,
                  statusocc: selectedStatusOfOccupancy,
                  relaocc: selectedRelationship,
                ),
                CustomTheme.defaultSize,
              ],
              CustomTheme.defaultSize,
              if (feedbackDetails.isNotEmpty) ...[
                const Text(
                  "Feedback Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FeedbackViewWidget(
                  details: feedbackDetails,
                ),
                CustomTheme.defaultSize,
              ],
              CustomTheme.defaultSize,
              if (boundaryDetails.isNotEmpty) ...[
                const Text(
                  "Boundary Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                BoundaryViewWidget(
                  details: boundaryDetails,
                ),
                CustomTheme.defaultSize,
              ],
              CustomTheme.defaultSize,
              if (measurementDetails.isNotEmpty) ...[
                const Text(
                  "Measurement Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MeasurementViewWidget(
                  details: measurementDetails,
                ),
                CustomTheme.defaultSize,
              ],
              if (calculatorDetails.isNotEmpty) ...[
                const Text(
                  "Calculation Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StageCalculatorViewWidget(
                  details: calculatorDetails,
                ),
                CustomTheme.defaultSize,
              ],
              if (criticalCommentsDetails.isNotEmpty) ...[
                const Text(
                  "Critical Comments Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTheme.defaultSize,
                Text(criticalCommentsDetails[0]['Comment'].toString()),
              ],
              CustomTheme.defaultSize,
              if (locationMapDetails.isNotEmpty ||
                  sketchDetails.isNotEmpty ||
                  photographDetails.isNotEmpty) ...[
                const Text(
                  "Upload Details",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTheme.defaultSize,
                UploadViewWidget(
                  mapDetails: locationMapDetails,
                  sketchDetails: sketchDetails,
                  photographDetails: photographDetails,
                ),
                CustomTheme.defaultSize,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
