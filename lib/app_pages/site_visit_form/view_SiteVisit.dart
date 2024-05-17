import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:proequity/app_widgets/app_common/app_bar.dart';

import '../../app_services/sqlite/boundary_services.dart';
import '../../app_services/sqlite/calculator_service.dart';
import '../../app_services/sqlite/comments_services.dart';
import '../../app_services/sqlite/customer_services.dart';
import '../../app_services/sqlite/dropdown_services.dart';
import '../../app_services/sqlite/feedback_services.dart';
import '../../app_services/sqlite/location_detail_services.dart';
import '../../app_services/sqlite/measurement_services.dart';
import '../../app_services/sqlite/occupancy_services.dart';
import '../../app_services/sqlite/property_location_service.dart';
import '../../app_services/sqlite/upload_location_map_services.dart';
import '../../app_services/sqlite/upload_photograph_service.dart';
import '../../app_services/sqlite/upload_property_sketch_service.dart';
import '../../app_theme/theme_files/app_color.dart';
import '../../app_widgets/alert_widget.dart';
import 'form_widgets/state_calculator_widget/CalculatorDataTable.dart';

class ViewSiteVisit extends StatefulWidget {
  final String id;

  const ViewSiteVisit({super.key, required this.id});

  @override
  State<ViewSiteVisit> createState() => _ViewSiteVisitState();
}

class _ViewSiteVisitState extends State<ViewSiteVisit> {
  CustomerService customerService = CustomerService();
  PropertyLocationServices propertyLocationServices =
      PropertyLocationServices();
  DropdownServices dropdownServices = DropdownServices();
  LocationDetailServices locationDetailServices = LocationDetailServices();
  OccupancyServices occupancyServices = OccupancyServices();
  FeedbackServices feedbackServices = FeedbackServices();
  BoundaryServices boundaryServices = BoundaryServices();
  List _bd = [];
  List measurements = [];
  MeasurementServices mmServices = MeasurementServices();
  CommentsServices commentsServices = CommentsServices();
  List comments = [];
  UploadLocationMapService locationMapService = UploadLocationMapService();
  SketchService sketchService = SketchService();
  PhotographService photographService = PhotographService();

  List statusOfOccupancy = [];
  List relationship = [];
  List _od = [];

  List details = [];
  bool noImage = false;
  bool validURL = false;
  bool validURLphoto = false;
  bool validUrlLocMap = false;
  List cityList = [];
  List customerDetails = [];
  List locationDetails = [];
  String selectedCity = "";
  String _selectSheetSize = "", _selectSheetType = "";
  List _ld = [];
  List surroundingArea = [];
  String selectedSurroundingArea = '', latitude = "";
  String selectedNatureOfLocality = '', longitude = "";
  String selectedClassOfLocality = '';
  List natureOfLocality = [];
  List classOfLocality = [];
  List proximityFromCivicsAmenities = [];
  List siteAccess = [];
  List selectedCivicsAmenities = [];
  String selectedSiteAccess = "";
  String selectedStatusOfOccupancy = "";
  String selectedRelationship = "";
  String nearbyLandmark = "";
  List amenities = [];
  List maintenance = [];
  List selectedAmenities = [];
  List _fd = [];
  String selectedMaintenance = '';
  List dynamicArray = [];
  List sheetSizeList = [];
  List sizeTypeList = [];
  List dbMeasurement = [];
  List sheets = [];

//calculator Details
  CalculatorService calculatorService = CalculatorService();
  List calculatorDetails = [];
  List progress = [];
  List recommended = [];
  List totalFloor = [];
  List completedFloor = [];
  List progressPer = [];
  List recommendedPer = [];
  List progressFormValues = [];
  List recommendedFormValues = [];
  List totalFloorFormValues = [];
  List completedFloorFormValues = [];
  List progressPerFormValues = [];
  List recommendedPerFormValues = [];
  List rowHead = [
    "Plinth",
    "rcc",
    "brickWork",
    "Internal Plaster",
    "External Plaster",
    "Flooring",
    "Electrification",
    "Woodwork",
    "Finishing",
    "Total"
  ];
  List locationPhotos = [];
  List sketchPhotos = [];
  List photographPhotos = [];

  @override
  void initState() {
    getLocation();
    getCustomerDetails(widget.id);
    getLocationDetails(widget.id);
    getPropertyLocationDetails(widget.id);
    getCity();
    getBoundaryDetails(widget.id);
    getCalculatorRecords();
    getSiteAccess();
    getInfrastructureOfTheSurroundingArea();
    getNatureOfLocality();
    getClassOfLocality();
    getProximityFromCivicsAmenities();
    getStatusOfOccupancy();
    getRelationshipOfOccupantWithCustomer();
    getMeasurement();
    getComments();
    getImageDetails(widget.id);
    Future.delayed(const Duration(seconds: 0), () {
      getOccupancy(widget.id);
    });
    getAmenities();
    Future.delayed(const Duration(seconds: 0), () {
      getFeedback(widget.id);
    });

    super.initState();
  }

  Future<void> getComments() async {
    comments = await commentsServices.read(widget.id);
    setState(() {});
  }

  getImageDetails(String id) async {
    sketchPhotos = await sketchService.read(widget.id);
    photographPhotos = await photographService.read(widget.id);
    locationPhotos = await locationMapService.read(widget.id);
    validURL = Uri.parse(sketchPhotos[0]['ImagePath']).isAbsolute;
    validURLphoto =
        Uri.parse(photographPhotos[0]['ImagePath']).isAbsolute;
    validUrlLocMap =
        Uri.parse(locationPhotos[0]["ImagePath"]).isAbsolute;
    if (sketchPhotos[0]['ImagePath'] == "" ||
        photographPhotos[0]['ImagePath'] == "" ||
        locationPhotos[0]["ImagePath"] == "") {
      noImage = true;
    }
    setState(() {});
  }

  getBoundaryDetails(String id) async {
    _bd = await boundaryServices.read(id);
  }

  getCustomerDetails(String propId) async {
    List property = await customerService.read();
    customerDetails = property
        .where((element) => element['PropId'] == propId.toString())
        .toList();
    setState(() {});
  }

  Future<void> getCity() async {
    List list = await dropdownServices.read();
    cityList = list.where((element) => element['Type'] == 'City').toList();
    selectedCity = cityList
        .where((e) => e['Id'] == locationDetails[0]['City'])
        .toList()[0]['Name']
        .toString();
    setState(() {});
  }

  getMeasurement() async {
    dbMeasurement = await mmServices.read(widget.id);
    var val = dbMeasurement[0];
    _selectSheetSize = val['SizeType'];
    sheets = jsonDecode(val['Sheet']);
    _selectSheetType =
        val['SheetType'].toString() == "" ? "R" : val['SheetType'];
    setState(() {});
  }

  getPropertyLocationDetails(id) async {
    locationDetails = await propertyLocationServices.getPropertyLocation(id);
    setState(() {});
  }

  getLocationDetails(id) async {
    _ld = await locationDetailServices.read(id);
    List sArea = surroundingArea
        .where((e) =>
            e['Id'] == _ld[0]['InfrastructureOfTheSurroundingArea'].toString())
        .toList();
    if (sArea.isNotEmpty) {
      selectedSurroundingArea = sArea[0]['Name'].toString();
    }
    List nList = natureOfLocality
        .where((e) => e['Id'] == _ld[0]['NatureOfLocality'].toString())
        .toList();
    if (nList.isNotEmpty) {
      selectedNatureOfLocality = nList[0]['Name'].toString();
    }
    List cList = classOfLocality
        .where((e) => e['Id'] == _ld[0]['ClassOfLocality'].toString())
        .toList();
    if (cList.isNotEmpty) {
      selectedClassOfLocality = cList[0]['Name'].toString();
    }

    String civicText = _ld[0]['ProximityFromCivicsAmenities'] ?? "";
    if (civicText.split(",").isNotEmpty) {
      selectedCivicsAmenities = civicText.split(",");
    }
    List sList = siteAccess
        .where((e) => e['Id'] == _ld[0]['SiteAccess'].toString())
        .toList();
    if (sList.isNotEmpty) {
      selectedSiteAccess = sList[0]['Name'].toString();
    }
    setState(() {});
  }

  getOccupancy(id) async {
    _od = await occupancyServices.read(id);
    List sList = statusOfOccupancy
        .where((e) => e['Id'] == _od[0]['StatusOfOccupancy'].toString())
        .toList();
    if (sList.isNotEmpty) {
      selectedStatusOfOccupancy = sList[0]['Name'].toString();
    }

    List rList = relationship
        .where((e) =>
            e['Id'] == _od[0]['RelationshipOfOccupantWithCustomer'].toString())
        .toList();
    if (rList.isNotEmpty) {
      selectedRelationship = rList[0]['Name'].toString();
    }

    setState(() {});
  }

  getFeedback(id) async {
    _fd = await feedbackServices.read(id);
    selectedAmenities = _fd[0]['Amenities'].toString().split(",");
    List mList = maintenance
        .where((e) => e['Id'] == _fd[0]['MaintainanceLevel'].toString())
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

  getCalculatorRecords() async {
    AlertService().showLoading("Please wait...");
    Future.delayed(const Duration(seconds: 0), () async {
      calculatorDetails = await calculatorService.read(widget.id);
      progress = jsonDecode(calculatorDetails[0]['Progress']);
      recommended = jsonDecode(calculatorDetails[0]['Recommended']);
      totalFloor = jsonDecode(calculatorDetails[0]['TotalFloor']);
      completedFloor = jsonDecode(calculatorDetails[0]['CompletedFloor']);
      progressPer = jsonDecode(calculatorDetails[0]['ProgressPer']);
      recommendedPer = jsonDecode(calculatorDetails[0]['RecommendedPer']);
      setState(() {});
      AlertService().hideLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return customerDetails.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          )
        : Scaffold(
            appBar: const AppBarWidget(
              title: "View Site Visit",
              action: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    CustomTheme.defaultHeight10,
                    const Text(
                      "Customer Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTheme.defaultSize,
                    rowDetails(
                        "Customer Name",
                        removeNullValue(customerDetails[0]['CustomerName'])
                            .toString()),
                    CustomTheme.defaultSize,
                    rowDetails(
                        "Institute/Bank Name",
                        removeNullValue(customerDetails[0]['BankName'])
                            .toString()),
                    CustomTheme.defaultSize,
                    rowDetails(
                        "Case/Loan Type",
                        removeNullValue(customerDetails[0]['LoanType'])
                            .toString()),
                    CustomTheme.defaultSize,
                    rowDetails(
                        "Contact Person Name",
                        removeNullValue(customerDetails[0]['ContactPersonName'])
                            .toString()),
                    CustomTheme.defaultSize,
                    rowDetails(
                        "Contact Person Number",
                        removeNullValue(
                                customerDetails[0]['ContactPersonNumber'])
                            .toString()),
                    CustomTheme.defaultSize,
                    rowDetails(
                        "Site Inspection date",
                        removeNullValue(
                                customerDetails[0]['SiteInspectionDate'])
                            .toString()),
                    CustomTheme.defaultSize,
                    rowDetails(
                        "Property Address",
                        removeNullValue(customerDetails[0]['PropertyAddress'])
                            .toString()),
                    CustomTheme.defaultSize,
                    const Text(
                      "Customer Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (locationDetails.isNotEmpty) ...[
                      CustomTheme.defaultSize,
                      rowDetails("City", removeNullValue(selectedCity)),
                      CustomTheme.defaultSize,
                      rowDetails(
                          "Colony",
                          removeNullValue(locationDetails[0]['Colony'])
                              .toString()),
                      CustomTheme.defaultSize,
                      rowDetails(
                          "Property Address as per Site",
                          removeNullValue(locationDetails[0]
                                  ['PropertyAddressAsPerSite'])
                              .toString()),
                      CustomTheme.defaultSize,
                      rowDetails(
                          "Address Matching",
                          removeNullValue(locationDetails[0]['AddressMatching'])
                              .toString()),
                      CustomTheme.defaultSize,
                      rowDetails(
                          "Jurisdiction/Local Municipal Body",
                          removeNullValue(
                                  locationDetails[0]['LocalMuniciapalBody'])
                              .toString()),
                      CustomTheme.defaultSize,
                      rowDetails(
                          "Name of Municipal Body",
                          removeNullValue(
                                  locationDetails[0]['NameOfMunicipalBody'])
                              .toString()),
                      CustomTheme.defaultSize,
                    ],
                    const Text(
                      "Property Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_ld.isNotEmpty) ...[
                      rowDetails("Near By Location",
                          removeNullValue(_ld[0]['NearbyLandmark'])),
                      CustomTheme.defaultSize,
                      rowDetails("MicroMarket/Locality",
                          removeNullValue(_ld[0]['Micromarket'])),
                      CustomTheme.defaultSize,
                      rowDetails("Latitude", removeNullValue(latitude)),
                      CustomTheme.defaultSize,
                      rowDetails("Longitude", removeNullValue(longitude)),
                      CustomTheme.defaultSize,
                      rowDetails("Infrastructure of  surrounding area",
                          removeNullValue(selectedSurroundingArea)),
                      CustomTheme.defaultSize,
                      rowDetails("Nature of Locality",
                          removeNullValue(selectedNatureOfLocality)),
                      CustomTheme.defaultSize,
                      rowDetails("Class of Locality",
                          removeNullValue(selectedClassOfLocality)),
                      CustomTheme.defaultSize,
                      rowDetails(
                          "Proximity from civics amenities /public transport",
                          removeNullValue(selectedCivicsAmenities.toString())),
                      CustomTheme.defaultSize,
                      rowDetails("Nearest Railway Station",
                          removeNullValue(_ld[0]['NearestRailwayStation'])),
                      CustomTheme.defaultSize,
                      rowDetails("Nearest Metro Station",
                          removeNullValue(_ld[0]['NearestMetroStation'])),
                      CustomTheme.defaultSize,
                      rowDetails("Nearest Bus Stop",
                          removeNullValue(_ld[0]['NearestBusStop'])),
                      CustomTheme.defaultSize,
                      rowDetails(
                          "Condition & Width of approach Road",
                          removeNullValue(
                              _ld[0]['ConditionAndWidthOfApproachRoad'])),
                      CustomTheme.defaultSize,
                      rowDetails(
                          "Site Access", removeNullValue(selectedSiteAccess)),
                      CustomTheme.defaultSize,
                      rowDetails("Neighborhood Type",
                          removeNullValue(_ld[0]['NeighborhoodType'])),
                      CustomTheme.defaultSize,
                      rowDetails("Nearest Hospital",
                          removeNullValue(_ld[0]['NearestHospital'])),
                      CustomTheme.defaultSize,
                      rowDetails("Any negative to the locality",
                          removeNullValue(_ld[0]['AnyNegativeToTheLocality'])),
                      CustomTheme.defaultSize,
                    ],
                    const Text(
                      "Occupancy Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_od.isNotEmpty) ...[
                      rowDetails("Status of Occupancy",
                          removeNullValue(selectedStatusOfOccupancy)),
                      CustomTheme.defaultSize,
                      rowDetails(
                          "Occupied By", removeNullValue(_od[0]['OccupiedBy'])),
                      CustomTheme.defaultSize,
                      rowDetails("Relationship of occupant with customer",
                          removeNullValue(selectedRelationship)),
                      CustomTheme.defaultSize,
                      rowDetails("Occupied Since",
                          removeNullValue(_od[0]['OccupiedSince'])),
                      CustomTheme.defaultSize,
                    ],
                    const Text(
                      "Feedback Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_fd.isNotEmpty) ...[
                      rowDetails("Amenities",
                          removeNullValue(selectedSurroundingArea)),
                      CustomTheme.defaultSize,
                      rowDetails("Maintenance Level",
                          removeNullValue(selectedMaintenance)),
                      CustomTheme.defaultSize,
                      rowDetails("Approx. Age of Property",
                          removeNullValue(_fd[0]['ApproxAgeOfProperty'])),
                      CustomTheme.defaultSize,
                    ],
                    const Text(
                      "Boundary Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_bd.isNotEmpty) ...[
                      rowDetails("East", removeNullValue(_bd[0]['East'])),
                      CustomTheme.defaultSize,
                      rowDetails("West", removeNullValue(_bd[0]['West'])),
                      CustomTheme.defaultSize,
                      rowDetails("South", removeNullValue(_bd[0]['South'])),
                      CustomTheme.defaultSize,
                      rowDetails("North", removeNullValue(_bd[0]['North'])),
                      CustomTheme.defaultSize,
                    ],
                    const Text(
                      "Measurement Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTheme.defaultSize,
                    if (dbMeasurement.isNotEmpty) ...[
                      rowDetails("Measurement Sheet Size Type",
                          removeNullValue(_selectSheetSize)),
                      CustomTheme.defaultSize,
                      rowDetails("Measurement Sheet Type",
                          removeNullValue(_selectSheetType)),
                      CustomTheme.defaultSize,
                    ],
                    const Text(
                      "Calculator Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTheme.defaultSize,
                    if (progress.isNotEmpty ||
                        recommended.isNotEmpty ||
                        totalFloor.isNotEmpty ||
                        progressPer.isNotEmpty ||
                        completedFloor.isNotEmpty ||
                        recommendedPer.isNotEmpty) ...[
                      Datatablelist(),
                    ],
                    CustomTheme.defaultSize,
                    const Text(
                      "Comment Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTheme.defaultSize,
                    if (comments.isNotEmpty) ...[
                      rowDetails("Comments",
                          removeNullValue(comments[0]['Comment']).toString()),
                    ],
                    CustomTheme.defaultSize,
                    const Text(
                      "Upload Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTheme.defaultSize,
                    const Text("Map"),
                    if (!validUrlLocMap &&
                        !noImage &&
                        locationPhotos.isNotEmpty) ...[
                          if(!validUrlLocMap)
                      Image.file(
                        File(locationPhotos[0]['ImagePath']),
                        height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.cover,
                      ),
                      if(validUrlLocMap)
                        Image.network(locationPhotos[0]['ImagePath'].toString(),
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                    ],
                    CustomTheme.defaultSize,
                    const Text("Sketch"),
                    if (!validURL && !noImage && sketchPhotos.isNotEmpty) ...[
                      if(!validURL)
                      Image.file(
                        File(sketchPhotos[0]['ImagePath']),
                        height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.cover,
                      ),
                      if(validURL)
                        Image.network(sketchPhotos[0]['ImagePath'],
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                    ],
                    CustomTheme.defaultSize,
                    const Text("Photograph"),
                    if (!validURLphoto &&
                        !noImage &&
                        photographPhotos.isNotEmpty) ...[
                          if(!validURLphoto)
                      Image.file(
                        File(photographPhotos[0]['ImagePath']),
                        height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.cover,
                      ),
                      if(validURLphoto)
                        Image.network(photographPhotos[0]['ImagePath'],
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                    ],
                    CustomTheme.defaultSize,
                    if (noImage) ...[
                      Image.asset(
                        "assets/images/img_1.png",
                        height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
  }

  Widget rowDetails(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          //padding: const EdgeInsets.only(right: 10, left: 10, bottom: 5),
          flex: 3,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
          )),
      Expanded(
          flex: 1,
          child: Text(
            value,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ))
    ]);
  }

  Widget Datatablelist() {
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(const DataColumn(label: Text('')));
    columns.add(DataColumn(
        label: Text("Progress",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ))));

    columns.add(DataColumn(
        label: Text("Recommended",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ))));
    columns.add(DataColumn(
        label: Text("Total Floor",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ))));
    columns.add(DataColumn(
        label: Text("Completed Floor",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ))));
    columns.add(DataColumn(
        label: Text("ProgressPer",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ))));
    columns.add(DataColumn(
        label: Text("RecommendedPer",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ))));
    for (int i = 0; i < rowHead.length; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(DataCell(Text((rowHead[i]).toString(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ))));
      singlecell.add(DataCell(Align(
          alignment: Alignment.center, child: Text(progress[i].toString()))));
      singlecell.add(DataCell(Align(
          alignment: Alignment.center,
          child: Text(recommended[i].toString()))));
      singlecell.add(DataCell(Align(
        alignment: Alignment.center,
        child: Text(totalFloor[i].toString()),
      )));
      singlecell.add(DataCell(Align(
        alignment: Alignment.center,
        child: Text(completedFloor[i].toString()),
      )));
      singlecell.add(DataCell(Align(
          alignment: Alignment.center,
          child: Text(progressPer[i].toString()))));
      singlecell.add(DataCell(Align(
        alignment: Alignment.center,
        child: Text(recommendedPer[i].toString()),
      )));
      rows.add(DataRow(
        cells: singlecell,
      ));
    }
    Widget objWidget = datatableDynamic(columns: columns, rows: rows);
    return objWidget;
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
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.reduced);
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
    setState(() {});
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

  removeNullValue(value) {
    if (value.toString() == "null" || value == "") {
      return "Nil";
    } else {
      return value.toString();
    }
  }
}
