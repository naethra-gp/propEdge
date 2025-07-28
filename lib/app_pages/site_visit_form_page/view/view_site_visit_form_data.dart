import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prop_edge/app_pages/site_visit_form_page/view/widgets/area_widget.dart';
import 'package:prop_edge/app_pages/site_visit_form_page/view/widgets/comment_widget.dart';
import 'package:prop_edge/app_pages/site_visit_form_page/view/widgets/measurement_widget.dart';
import 'package:prop_edge/app_pages/site_visit_form_page/view/widgets/occupant_widget.dart';
import 'package:prop_edge/app_pages/site_visit_form_page/view/widgets/stage_calculator_widget.dart';
import 'package:prop_edge/app_pages/site_visit_form_page/view/widgets/upload_widget.dart';
import 'package:prop_edge/app_utils/alert_service2.dart';
import 'package:prop_edge/app_utils/alert_service.dart';

import '../../../app_services/local_db/local_services/dropdown_services.dart';
import '../../../app_services/local_db/local_services/local_services.dart';
import '../../../app_utils/app/app_bar.dart';
import 'widgets/boundary_widget.dart';
import 'widgets/customer_widget.dart';
import 'widgets/propert_widget.dart';

class ViewSiteVisitFormData extends StatefulWidget {
  final String propId;
  const ViewSiteVisitFormData({super.key, required this.propId});

  @override
  State<ViewSiteVisitFormData> createState() => _ViewSiteVisitFormDataState();
}

class _ViewSiteVisitFormDataState extends State<ViewSiteVisitFormData> {
  List customerList = [];
  List propertyList = [];
  List propertyOthers = [];
  List areaList = [];
  List occList = [];
  List bounList = [];
  List commList = [];
  List calcList = [];
  List measurementList = [];
  List uplLocMapList = [];
  List uplPropPlanList = [];
  List uplPtoGrphList = [];

  AlertService alertService = AlertService();
  CustomerServices cService = CustomerServices();
  DropdownServices dropdownServices = DropdownServices();
  AreaServices areaServices = AreaServices();
  PropertyDetailsServices propertyDetailsServices = PropertyDetailsServices();
  OccupancyServices occupancyServices = OccupancyServices();
  BoundaryServices boundaryServices = BoundaryServices();
  CommentsServices commentsServices = CommentsServices();
  MeasurementServices measurementServices = MeasurementServices();
  CalculatorService calculatorService = CalculatorService();
  LocationMapService locationMapService = LocationMapService();
  PlanService planService = PlanService();
  PhotographService photographService = PhotographService();

  String selectedNatureOfLocality = "";
  String selectedInfrastructureConditionOfNeighboringAreas = "";
  String selectedRateArea = "";
  String selectedlandUseOfNeighboringArea = "";
  String selectedClassOfLocality = "";
  List transNameList = [];
  String combTransNames = "";

  String selectStateOfOcc = "";
  String selectRelationShipApp = "";

  List sheetSizeList = [];
  List sizeTypeList = [];
  String selectedSizeType = "";
  String selectedSheetType = "";
  List sheetArray = [];
  @override
  void initState() {
    super.initState();
    getAllData();
  }

  getAllData() async {
    alertService.showLoading();
    customerList = await cService.readById(widget.propId);
    propertyList = await propertyDetailsServices.readById(widget.propId);
    areaList = await areaServices.read(widget.propId);
    occList = await occupancyServices.read(widget.propId);
    bounList = await boundaryServices.readById(widget.propId);
    measurementList = await measurementServices.readById(widget.propId);
    calcList = await calculatorService.read(widget.propId);
    commList = await commentsServices.read(widget.propId);
    uplLocMapList = await locationMapService.read(widget.propId);
    uplPropPlanList = await planService.read(widget.propId);
    uplPtoGrphList = await photographService.read(widget.propId);
    getLandUseOfNeighboringArea();
    getInfrastructureConditionOfNeighArea();
    rateTheInfraOfArea();
    getNatureOfLocality();
    getClassOfLocality();
    getPubTransport();
    fetchOccupancyData();
    fetchMeasurementData();
    getPropertyDetails();
    alertService.hideLoading();
    setState(() {});
  }

  getPropertyDetails() async {
    final l = propertyList;
    debugPrint('->>> $l');

    /// REGION NAME
    List regionList = await dropdownServices.readByType('Region');
    List r1List = regionList.where((e) => e['Id'] == l[0]['Region']).toList();
    String regionName = '-';
    String cityName = '-';
    if (r1List.isNotEmpty) {
      regionName = r1List[0]['Name'];

      /// CITY NAME
      List cityList = jsonDecode(r1List[0]['Options']);
      List list2 = cityList.where((e) => e['Id'] == l[0]['City']).toList();
      if (list2.isNotEmpty) {
        cityName = list2[0]['Name'];
      }
    }

    /// CurrentConditionOfProperty
    String key0 = 'CurrentConditionOfProperty';
    String conditionOfProperty = '-';
    List conditionProperty = await dropdownServices.readByType(key0);
    List key0List = conditionProperty
        .where((e) => e['Id'] == l[0]['ConditionOfProperty'])
        .toList();
    if (key0List.isNotEmpty) {
      conditionOfProperty = key0List[0]['Name'];
    }

    /// CurrentConditionOfProperty
    String key1 = 'ConstructionOldOrNew';
    String constructionOldOrNew = '-';
    List constructionProperty = await dropdownServices.readByType(key1);
    List key1List = constructionProperty
        .where((e) => e['Id'] == l[0]['ConstructionOldNew'])
        .toList();
    if (key1List.isNotEmpty) {
      constructionOldOrNew = key1List[0]['Name'];
    }

    /// Floor DropDown
    String key2 = 'Floor';
    String floor = '-';
    List key2ListLocal = await dropdownServices.readByType(key2);
    List key2List = key2ListLocal
        .where((e) => e['Id'].toString() == l[0]['Floor'].toString())
        .toList();
    if (key2List.isNotEmpty) {
      floor = key2List[0]['Name'];
    }

    /// Kitchen Type DropDown
    String key3 = 'KitchenType';
    String kitchenType = '-';
    List key3Local = await dropdownServices.readByType(key3);
    List key3List = key3Local
        .where((e) => e['Id'].toString() == l[0]['KitchenType'].toString())
        .toList();
    if (key3List.isNotEmpty) {
      kitchenType = key3List[0]['Name'].toString();
    }

    /// MaintainanceLevel DropDown
    String key4 = 'MaintenanceLevel';
    String maintainanceLevel = '-';
    List key4Local = await dropdownServices.readByType(key4);
    String v2 = l[0]['MaintainanceLevel'].toString();
    List key4List = key4Local.where((e) => e['Id'].toString() == v2).toList();
    if (key4List.isNotEmpty) {
      maintainanceLevel = key4List[0]['Name'].toString();
    }

    /// MaintainanceLevel DropDown
    String key5 = 'UnitType';
    String plotUnitType = '-';
    List key5Local = await dropdownServices.readByType(key5);
    String v5 = l[0]['PlotUnitType'].toString();
    List key5List = key5Local.where((e) => e['Id'].toString() == v5).toList();
    if (key5List.isNotEmpty) {
      plotUnitType = key5List[0]['Name'].toString();
    }

    /// Property Type
    List propertyTypeList = await dropdownServices.readByType('PropertyType');
    List typeList =
        propertyTypeList.where((e) => e['Id'] == l[0]['PropertyType']).toList();
    String propertyType = '-';
    String propertySubType = '-';
    String bhk = '-';
    if (typeList.isNotEmpty) {
      propertyType = typeList[0]['Name'];

      /// Property Sub Type
      List subList = jsonDecode(typeList[0]['Options']);
      List subListLocal =
          subList.where((e) => e['Id'] == l[0]['PropertySubType']).toList();
      if (subListLocal.isNotEmpty) {
        propertySubType = subListLocal[0]['Name'];

        if (l[0]['PropertyType'] == '952' &&
            (l[0]['PropertySubType'] != '449' &&
                l[0]['PropertySubType'] != '8594')) {
          /// BHKConfiguration DropDown
          String key7 = 'BHKConfiguration';
          List key7Local = await dropdownServices.readByType(key7);
          String v7 = l[0]['BHKConfiguration'].toString();
          List key7List =
              key7Local.where((e) => e['Id'].toString() == v7).toList();
          if (key7List.isNotEmpty) {
            bhk = key7List[0]['Name'].toString();
          }
        } else {
          bhk = l[0]['BHKConfiguration'].toString();
        }
      }
    }

    /// Structure DropDown
    String key6 = 'Structure';
    String structure = '-';
    List key6Local = await dropdownServices.readByType(key6);
    String v6 = l[0]['Structure'].toString();
    List key6List = key6Local.where((e) => e['Id'].toString() == v6).toList();
    if (key6List.isNotEmpty) {
      structure = key6List[0]['Name'].toString();
    }
    // print('--------------------------------------------');
    // print("Region: $regionName");
    // print("City: $cityName");
    // print("ConditionOfProperty: $conditionOfProperty");
    // print("ConstructionOldOrNew: $constructionOldOrNew");
    // print("Floor: $floor");
    // print("KitchenType: $kitchenType");
    // print("MaintainanceLevel: $maintainanceLevel");
    // print("plotUnitType: $plotUnitType");
    // print("propertyType: $propertyType");
    // print("propertySubType: $propertySubType");
    // print("structure: $structure");
    // print("BHKConfiguration: $bhk");
    // print('--------------------------------------------');
    propertyOthers = [
      {
        'Region': regionName,
        'City': cityName,
        'ConditionOfProperty': conditionOfProperty,
        'ConstructionOldOrNew': constructionOldOrNew,
        'Floor': floor,
        'KitchenType': kitchenType,
        'MaintainanceLevel': maintainanceLevel,
        'PlotUnitType': plotUnitType,
        'PropertyType': propertyType,
        'PropertySubType': propertySubType,
        'Structure': structure,
        'BHKConfiguration': bhk,
      }
    ];
    setState(() {});
  }

  Future<void> getLandUseOfNeighboringArea() async {
    List list = await dropdownServices.read();
    List landUseOfNeighboringArea = list
        .where((element) => element['Type'] == 'LandUseOfNeighboringArea')
        .toList();

    List nList = landUseOfNeighboringArea
        .where((e) => e['Id'] == areaList[0]['LandUseOfNeighboringAreas'])
        .toList();
    if (nList.isNotEmpty) {
      selectedlandUseOfNeighboringArea = nList[0]['Name'].toString();
    }
    setState(() {});
  }

  Future<void> getInfrastructureConditionOfNeighArea() async {
    List list = await dropdownServices.read();
    List neighArea = list
        .where((element) =>
            element['Type'] == 'InfrastructureConditionOfNeighboringArea')
        .toList();
    List nArea = neighArea
        .where((e) =>
            e['Id'] ==
            areaList[0]['InfrastructureConditionOfNeighboringAreas'].toString())
        .toList();
    if (nArea.isNotEmpty) {
      selectedInfrastructureConditionOfNeighboringAreas =
          nArea[0]['Name'].toString();
    }
    setState(() {});
  }

  Future<void> rateTheInfraOfArea() async {
    List list = await dropdownServices.read();
    List rateList = list
        .where((element) =>
            element['Type'] == 'InfrastructureOfTheSurroundingArea')
        .toList();
    List rList = rateList
        .where((e) =>
            e['Id'] ==
            areaList[0]['InfrastructureOfTheSurroundingArea'].toString())
        .toList();
    if (rList.isNotEmpty) {
      selectedRateArea = rList[0]['Name'];
    }
    setState(() {});
  }

  Future<void> getNatureOfLocality() async {
    List list = await dropdownServices.read();
    List natureOfLocality =
        list.where((element) => element['Type'] == 'NatureOfLocality').toList();

    List nList = natureOfLocality
        .where((e) => e['Id'] == areaList[0]['NatureOfLocality'].toString())
        .toList();
    if (nList.isNotEmpty) {
      selectedNatureOfLocality = nList[0]['Name'].toString();
    }
    setState(() {});
  }

  Future<void> getClassOfLocality() async {
    // Only proceed if property type is residential (952)
    if (propertyList.isNotEmpty && propertyList[0]['PropertyType'] == '952') {
      List list = await dropdownServices.read();
      List classOfLocality = list
          .where((element) => element['Type'] == 'ClassOfLocality')
          .toList();
      List cList = classOfLocality
          .where((e) => e['Id'] == areaList[0]['ClassOfLocality'].toString())
          .toList();
      if (cList.isNotEmpty) {
        selectedClassOfLocality = cList[0]['Name'].toString();
      }
    } else {
      selectedClassOfLocality = '-';
    }

    setState(() {});
  }

  Future<void> getPubTransport() async {
    var pubTransString = areaList[0]['PublicTransport'];
    var pubTransList = jsonDecode(pubTransString);

    for (var item in pubTransList) {
      transNameList.add("${item['TypeName']} (${item['Distance']})");
    }

    combTransNames = transNameList.join(', ');
  }

  Future<void> fetchOccupancyData() async {
    try {
      List list = await dropdownServices.read();
      List statusOfOcc =
          list.where((e) => e['Type'] == 'StatusOfOccupancy').toList();
      List relationOfOcc = list
          .where((e) => e['Type'] == 'RelationshipOfOccupantWithCustomer')
          .toList();

      if (occList.isNotEmpty) {
        if (statusOfOcc.isNotEmpty) {
          List a = statusOfOcc
              .where((e) => e['Id'] == occList[0]['StatusOfOccupancy'])
              .toList();
          if (a.isNotEmpty) {
            selectStateOfOcc = a[0]['Name'].toString();
          }
        }

        if (relationOfOcc.isNotEmpty) {
          String aa = occList[0]['RelationshipOfOccupantWithCustomer'];
          List relationList =
              relationOfOcc.where((e) => e['Id'] == aa).toList();
          if (relationList.isNotEmpty) {
            selectRelationShipApp = relationList[0]['Name'].toString();
          }
        }
      }
    } catch (e) {
      print('Error in fetchOccupancyData: $e');
      selectStateOfOcc = '-';
      selectRelationShipApp = '-';
    }
    setState(() {});
  }

  Future<void> fetchMeasurementData() async {
    List list = await dropdownServices.read();
    String size = "MeasurementSheetSizeType";
    String type = "MeasurementSheetType";
    sheetSizeList = list.where((e) => e['Type'] == size).toList();
    sizeTypeList = list.where((e) => e['Type'] == type).toList();
    sheetArray = jsonDecode(measurementList[0]['Sheet']);

    List a = sheetSizeList
        .where((e) =>
            e['Id'].toString() == measurementList[0]['SizeType'].toString())
        .toList();
    List b = sizeTypeList
        .where((e) =>
            e['Id'].toString() == measurementList[0]['SheetType'].toString())
        .toList();
    if (a.isNotEmpty && b.isNotEmpty) {
      selectedSizeType = a[0]['Name'];
      selectedSheetType = b[0]['Name'];
      List mArray = jsonDecode(b[0]['Options']);
      for (int i = 0; i < sheetArray.length; i++) {
        //-------------- Description ------------------
        List dd = mArray
            .where((e) =>
                e['Id'].toString() == sheetArray[i]['Description'].toString())
            .toList();

        //-------------- Particulars ------------------
        List pArray = dd[0]['Options'];
        List pp = pArray
            .where((e) =>
                e['Id'].toString() == sheetArray[i]['Particulars'].toString())
            .toList();
        if (dd.isNotEmpty && pp.isNotEmpty) {
          //-------------- SET VALUES ------------------
          setState(() {
            sheetArray[i]['Description'] = dd[0]['Name'];
            sheetArray[i]['Particulars'] = pp[0]['Name'];
          });
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(title: 'View Details', action: false),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(height: 16),
              if (customerList.isNotEmpty)
                CustomerWidget(
                  list: customerList,
                ),
              SizedBox(height: 16),
              if (propertyList.isNotEmpty && propertyOthers.isNotEmpty)
                PropertyWidget(
                  list: propertyList,
                  others: propertyOthers,
                ),
              SizedBox(height: 16),
              if (areaList.isNotEmpty)
                AreaWidget(
                  areaList: areaList,
                  selectedlandUseOfNeighboringArea:
                      selectedlandUseOfNeighboringArea,
                  selectedInfrastructureConditionOfNeighboringAreas:
                      selectedInfrastructureConditionOfNeighboringAreas,
                  selectedRateArea: selectedRateArea,
                  selectedNatureOfLocality: selectedNatureOfLocality,
                  selectedClassOfLocality: selectedClassOfLocality,
                  transNameList: combTransNames,
                  propertyType: propertyList.isNotEmpty
                      ? propertyList[0]['PropertyType'].toString()
                      : '',
                ),
              SizedBox(height: 16),
              if (occList.isNotEmpty)
                OccupantWidget(
                    occList: occList,
                    selectStateOfOcc: selectStateOfOcc,
                    selectRelationShipApp: selectRelationShipApp),
              SizedBox(height: 16),
              if (bounList.isNotEmpty)
                BoundaryWidget(
                  bounList: bounList,
                ),
              SizedBox(height: 16),
              MeasurementViewWidget(
                details: measurementList,
                selectedSizeType: selectedSizeType,
                selectedSheetType: selectedSheetType,
                sheetArray: sheetArray,
              ),
              SizedBox(height: 16),
              if (calcList.isNotEmpty)
                StageCalculatorViewWidget(details: calcList),
              if (commList.isNotEmpty)
                CommentsWidget(
                  commList: commList,
                ),
              SizedBox(height: 16),
              UploadViewWidget(
                mapDetails: uplLocMapList,
                propPlanDetails: uplPropPlanList,
                photographDetails: uplPtoGrphList,
              )
            ],
          ),
        ),
      ),
    );
  }
}
