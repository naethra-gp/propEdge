import 'dart:convert';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:prop_edge/app_services/local_db/local_services/tracking_service.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/location_service.dart';
import '../../../app_config/app_constants.dart';
import '../../../app_services/local_db/local_services/local_services.dart';
import '../../../app_theme/app_color.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_utils/alert_service2.dart';
import '../../../app_utils/app/app_button_widget.dart';
// import '../../../app_utils/app/location_service.dart';
import 'widgets/upload_form_dialog.dart';
import 'widgets/uploads/list_image_widget.dart';
import 'widgets/uploads/upload_outline_button_widget.dart';

class UploadForm extends StatefulWidget {
  final VoidCallback buttonClicked;
  final String propId;
  final bool onVisibility;
  const UploadForm({
    super.key,
    required this.buttonClicked,
    required this.propId,
    required this.onVisibility,
  });

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final CustomSegmentedController<int> _controller =
      CustomSegmentedController();
  final AlertService _alertService = AlertService();
  final LocationMapService _locationMapService = LocationMapService();
  final PhotographService _photographService = PhotographService();
  final PlanService _planService = PlanService();

  List<Map<String, dynamic>> _locationPhotos = [];
  List<Map<String, dynamic>> _propertyPlanPhotos = [];
  List<Map<String, dynamic>> _photographPhotos = [];
  bool _validURL = false;

  CustomerServices customerServices = CustomerServices();
  PropertyDetailsServices propertyDetailsServices = PropertyDetailsServices();
  CommentsServices commentsServices = CommentsServices();
  OccupancyServices occupancyServices = OccupancyServices();
  AreaServices areaServices = AreaServices();
  LocationMapService locationMapService = LocationMapService();
  PlanService planService = PlanService();
  PhotographService photographService = PhotographService();
  LocationService locationService = LocationService();
  TrackingServices trackingServices = TrackingServices();

  /// customer - Form
  String instName = "";
  String branchName = "";
  String caseOrLoanType = "";
  String cusName = "";
  String cusConNo = "";
  String conPerName = "";
  String conPerNumber = "";
  String propAddress = "";
  String siteInsDate = "";

  /// comments - Form
  String comm = "";

  /// occ - Form
  String staOcc = "";
  String occName = "";
  String occConNo = "";
  String occSince = "";
  String relationShipApp = "";
  String perMetSiteName = "";
  String perMetContNo = "";

  ///area - Form
  String lat = "";
  String long = "";
  String landuseOfNeighAreas = "1014";
  String infraConOfNeighAreas = "";
  String rateTheInfra = "";
  String natureOfLoca = "";
  String classOfLoc = ""; //res-selected
  String ammenAvai = ""; //res-selected
  String siteAccess = "";
  String negIfAny = "";
  List pubtrans = [];
  var missingFeilds = [];

  ///uploads-Form
  List locMap = [];
  List propPlan = [];
  List ptoList = [];

  ///property - form
  String region = "";
  String city = "";
  String pincode = "";
  // String addressMatching = "Yes";
  String prpAddress = "";
  String propertyType = "952";
  String propertySubType = "";
  String bhkConfig = ""; //res-sele
  String structure = ""; //not to open for plots
  // String floor = "";
  String kitchenAndCupboardsExisting = "Yes";
  String kitchenTypeStr = ""; //res-sel and kitc and cub (y/n)--(y)
  String kitOrPan = ""; //only for commercial
  String noOfLifts = ""; //not to open for plots
  String noOfstairCases = ""; //not to open for plots
  String consOldOrNew = ""; //not to open for plots
  String appAgeOfProp = ""; //not to open for plots
  String currentConOfProp = ""; //not to open for plots
  String areaOfProp = "";
  String unitType = ""; //only for plots
  String sqft = "";
  String mtrs = "";
  String yards = "";
  String plotArea = ""; //only for plots
  String totalLandArea = ""; // only if Independent Floor , Land + Building
  String propArea = ""; // only if Independent Floor , Land + Building
  String mainLevel = ""; //not to open for plots
  Set<String> missingTabs = {};

  @override
  void initState() {
    super.initState();
    _controller.value = 1;
    _fetchPhotoLists();
    debugPrint('--- ${widget.onVisibility} ---');
    fetOcc();
    // checkWithFinalValidation();
  }

  fetOcc() async {
    List ocList = await occupancyServices.read(widget.propId);
    for (var item in ocList) {
      staOcc = item['StatusOfOccupancy'].toString();
      occName = item['OccupiedBy'].toString();
      occConNo = item['OccupantContactNo'].toString();
      occSince = item['OccupiedSince'].toString();
      relationShipApp = item['RelationshipOfOccupantWithCustomer'].toString();
      perMetSiteName = item['PersonMetAtSite'].toString();
      perMetContNo = item['PersonMetAtSiteContNo'].toString();
    }
    print('staocc $staOcc');
  }

  Future<void> _fetchPhotoLists() async {
    switch (_controller.value) {
      case 1:
        _locationPhotos = await _locationMapService.read(widget.propId);
        break;
      case 2:
        _propertyPlanPhotos = await _planService.read(widget.propId);
        if (_propertyPlanPhotos.isNotEmpty) {
          _validURL = Uri.parse(_propertyPlanPhotos[0]['ImagePath']).isAbsolute;
        }
        break;
      case 3:
        _photographPhotos = await _photographService.read(widget.propId);
        break;
    }
    setState(() {});
  }

  void _showUploadPictures(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UploadDialog(
          propId: widget.propId,
          title: title,
        );
      },
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(135),
    ).then((dynamic val) {
      if (val != null && val) {
        _fetchPhotoLists();
      }
    });
  }

  Future<void> checkWithFinalValidation() async {
    _alertService.showLoading();
    List cs = await customerServices.readById(widget.propId);
    List pl = await propertyDetailsServices.readById(widget.propId);
    print('cs $cs');
    List commList = await commentsServices.read(widget.propId);
    List occList = await occupancyServices.read(widget.propId);
    List areaList = await areaServices.read(widget.propId);
    locMap = await locationMapService.read(widget.propId);
    print("locMap $locMap");
    propPlan = await planService.read(widget.propId);
    ptoList = await photographService.read(widget.propId);
    cusConNo = cs[0]['CustomerContactNumber'].toString();
    comm = commList[0]['Comment'].toString();
    missingFeilds.clear();

    for (var item in cs) {
      instName = item['BankName'].toString();
      branchName = item['BranchName'].toString();
      caseOrLoanType = item['LoanType'].toString();
      cusName = item['CustomerName'].toString();
      cusConNo = item['CustomerContactNumber'].toString();
      conPerName = item['ContactPersonName'].toString();
      conPerNumber = item['ContactPersonNumber'].toString();
      propAddress = item['PropertyAddress'].toString();
      siteInsDate = item['SiteInspectionDate'].toString();
    }

    for (var item in pl) {
      region = item['Region'].toString();
      city = item['City'].toString();
      prpAddress = item['PropertyAddressAsPerSite'].toString();
      pincode = item['Pincode'].toString();
      propertyType = item['PropertyType'].toString();
      propertySubType = item['PropertySubType'].toString();
      print(propertyType);
      if (propertyType == "952") {
        bhkConfig = item['BHKConfiguration'].toString();
        // floor = item['Floor'].toString();
        kitchenAndCupboardsExisting =
            item['KitchenAndCupboardsExisting'].toString();
        if (item['KitchenAndCupboardsExisting'].toString() == "Yes") {
          kitchenTypeStr = item['KitchenType'].toString();
        }
      }
      if (propertyType != "958") {
        structure = item['Structure'].toString();
        noOfLifts = item['NoOfLifts'].toString();
        noOfstairCases = item['NoOfStaircases'].toString();
        consOldOrNew = item['ConstructionOldNew'].toString();
        appAgeOfProp = item['AgeOfProperty'].toString();
        currentConOfProp = item['ConditionOfProperty'].toString();
        mainLevel = item['MaintainanceLevel'].toString();
      }
      if (propertyType == "958") {
        unitType = item['PlotUnitType'].toString();
        if (unitType == "1") {
          // mtrs = item['PlotAreaMtrs'].toString();
          sqft = item['PlotAreaSqft'].toString();
        } else if (unitType == "3") {
          mtrs = item['PlotAreaMtrs'].toString();
        } else if (unitType == "4") {
          yards = item['PlotAreaYards'].toString();
        }
      }
      if (propertySubType == "8595" || propertySubType == "8594") {
        areaOfProp = item['AreaOfProperty'];
      }

      if ((propertySubType == "5027" || propertySubType == "8942") &&
          propertyType == "952") {
        totalLandArea = item['LandArea'].toString();
        propArea = item['PropertyArea'].toString();
      }
      if (propertyType == "953") {
        kitOrPan = item['KitchenOrPantry'].toString();
      }
    }

    for (var item in occList) {
      staOcc = item['StatusOfOccupancy'].toString();
      occName = item['OccupiedBy'].toString();
      occConNo = item['OccupantContactNo'].toString();
      occSince = item['OccupiedSince'].toString();
      relationShipApp = item['RelationshipOfOccupantWithCustomer'].toString();
      perMetSiteName = item['PersonMetAtSite'].toString();
      perMetContNo = item['PersonMetAtSiteContNo'].toString();
    }
    for (var item in areaList) {
      lat = item['Latitude'].toString();
      long = item['Longitude'].toString();
      landuseOfNeighAreas = item['LandUseOfNeighboringAreas'].toString();
      if (widget.onVisibility) {
        classOfLoc = item['ClassOfLocality'].toString();
        ammenAvai = item['Amenities'].toString();
      }
      infraConOfNeighAreas =
          item['InfrastructureConditionOfNeighboringAreas'].toString();
      rateTheInfra = item['InfrastructureOfTheSurroundingArea'].toString();
      natureOfLoca = item['NatureOfLocality'].toString();
      siteAccess = item['SiteAccess'].toString();
      negIfAny = item['AnyNegativeToTheLocality'].toString();
      pubtrans = jsonDecode(item['PublicTransport'].toString());
    }
    _alertService.hideLoading();
  }

  Future<void> _finalSubmit() async {
    AlertService alertService = AlertService();

    bool serviceEnabled = await locationService.location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.location.requestService();
      if (!serviceEnabled) {
        alertService
            .errorToast('Please enable your location before final submission');
        return;
      }
    }

    bool? confirm = await alertService.confirmAlert(
      context,
      'Final Confirmation',
      Constants.finalFormAlertText,
    );

    if (confirm!) {
      await checkWithFinalValidation();
      finalSubmitClicked();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            _buildSegmentedControl(),
            const SizedBox(height: 25),
            if (_controller.value == 1) ...[
              _buildUploadSection(
                title: Constants.locationMapTitle,
                photos: _locationPhotos,
                onUploadPressed: () =>
                    _showUploadPictures(context, Constants.locationMapTitle),
                onDelete: (item) async {
                  final result = await _locationMapService.updateIsActive(
                      ["N", "true", "N", item['primaryId'].toString()]);
                  if (result == 1) _fetchPhotoLists();
                },
              ),
            ],
            if (_controller.value == 2) ...[
              _buildUploadSection(
                title: Constants.propertyPlanTitle,
                photos: _propertyPlanPhotos,
                onUploadPressed: () =>
                    _showUploadPictures(context, Constants.propertyPlanTitle),
                onDelete: (item) async {
                  final result = await _planService.updateIsActive(
                      ["N", "true", "N", item['primaryId'].toString()]);
                  if (result == 1) _fetchPhotoLists();
                },
              ),
            ],
            if (_controller.value == 3) ...[
              _buildUploadSection(
                title: Constants.photographTitle,
                photos: _photographPhotos,
                onUploadPressed: () =>
                    _showUploadPictures(context, Constants.photographTitle),
                onDelete: (item) async {
                  final result = await _photographService.updateIsActive(
                      ["N", "true", "N", item['primaryId'].toString()]);
                  if (result == 1) _fetchPhotoLists();
                },
              ),
              const SizedBox(height: 25),
              _buildFinalSubmitButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: CustomSlidingSegmentedControl<int>(
        initialValue: 1,
        padding: 10,
        curve: Curves.easeInCirc,
        controller: _controller,
        onValueChanged: (int index) {
          _controller.value = index;
          _fetchPhotoLists();
        },
        children: {
          1: _buildSegmentTitle('Location Map', 1),
          2: _buildSegmentTitle('Property Plan', 2),
          3: _buildSegmentTitle('Photograph', 3),
        },
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6FA),
          borderRadius: BorderRadius.circular(8),
        ),
        thumbDecoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 2.0,
              offset: const Offset(0.0, 2.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentTitle(String title, int index) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight:
            index == _controller.value ? FontWeight.w800 : FontWeight.w700,
        color: index == _controller.value ? Colors.white : Colors.black45,
      ),
    );
  }

  Widget _buildUploadSection({
    required String title,
    required List<Map<String, dynamic>> photos,
    required VoidCallback onUploadPressed,
    required Function(Map<String, dynamic>) onDelete,
  }) {
    return Column(
      children: [
        UploadOutlineButtonWidget(
          onPressed: photos.length > 15
              ? () => _alertService.errorToast(Constants.maxUploadMessage)
              : onUploadPressed,
          buttonLabel: "Upload $title",
        ),
        CustomTheme.defaultSize,
        SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: photos.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = photos[index];
                  return ListImageWidget(
                    list: item,
                    onDelete: (bool confirm) async {
                      if (confirm) await onDelete(item);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinalSubmitButton() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: AppButton(
          title: "Final Submit",
          onPressed: _finalSubmit,
        ),
      ),
    );
  }

  finalSubmitClicked() async {
    // TODO: CHECK VALIDATION IN ALL FORMS

    if (!validateForm()) {
      _alertService.errorToast(
          'Some of the Fields not filled in ${missingTabs.join(', ')}!');
      return;
    }
    // PropertyLocationService pls = PropertyLocationService();
    // LocationDetailServices lds = LocationDetailServices();
    // CommentsServices ccs = CommentsServices();
    // List pl = await pls.getPropertyLocation(widget.propId);
    // List ld = await lds.read(widget.propId);
    // List cc = await ccs.read(widget.propId);
    // List lms = await locationMapService.read(widget.propId);
    // List ss = await sketchService.read(widget.propId);
    // List ps = await photographService.read(widget.propId);

    // if (pl[0]['PropertyAddressAsPerSite'].toString().isEmpty) {
    //   AlertService()
    //       .errorToast("Address is mandatory in Property Tab");
    // } else if ((ld[0]['Latitude'].toString().isEmpty ||
    //     ld[0]['Latitude'].toString() == '0') &&
    //     (ld[0]['Longitude'].toString().isEmpty ||
    //         ld[0]['Longitude'].toString() == '0')) {
    //   AlertService()
    //       .errorToast("Lat & Lon is mandatory in Location Tab");
    // } else if (cc[0]['Comment'].toString().isEmpty) {
    //   AlertService()
    //       .errorToast("Comment is mandatory in Comment Tab");
    // } else if (lms.isEmpty) {
    //   AlertService().errorToast(
    //       "Location Photo is mandatory in Location Tab");
    // } else if (ss.isEmpty) {
    //   AlertService().errorToast(
    //       "Sketch Photo is mandatory in Sketch Tab");
    // } else if (ps.isEmpty) {
    //   AlertService().errorToast(
    //       "Photograph Photo is mandatory in Photograph Tab");
    // } else {
    //   AlertService().hideLoading();
    //   alertService.confirmFinalSubmit(
    //       context, msg, "Submit", "Review", () async {
    //     Navigator.pushNamed(context, "siteVisitForm",
    //         arguments: widget.propId.toString());
    //   }, () async {

    PropertyListService service = PropertyListService();

    LocationData? currentLocation = await locationService.getCurrentLocation();
    // String? plLat;
    // String? plLong;
    // if (currentLocation != null) {x
    //   plLat = currentLocation.latitude.toString();
    //   plLong = currentLocation.longitude.toString();
    // }
    // await locationService.saveLocation(currentLocation, 'PS');
    await trackingServices.insertLocation(currentLocation!, 'PS');

    List request = [
      Constants.status[2],
      "N",
      // plLat,
      // plLong,
      widget.propId.toString(),
    ];
    var result = await service.updateLocalStatus(request);
    if (result == 1) {
      _alertService.successToast("Form status updated");
    } else {
      _alertService.errorToast("Form status update failed!");
    }
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, 'mainPage', arguments: 2);
    // });
    // }
  }

  bool validateForm() {
    // missingFeilds.clear();
    missingTabs.clear();

    //Customer form
    if (instName.isEmpty ||
        branchName.isEmpty ||
        caseOrLoanType.isEmpty ||
        cusName.isEmpty ||
        cusConNo.isEmpty ||
        conPerName.isEmpty ||
        conPerNumber.isEmpty ||
        propAddress.isEmpty ||
        siteInsDate.isEmpty) {
      missingTabs.add("Customer Tab");
    }

    // Comments Form Validations
    if (comm.isEmpty) missingTabs.add("Comment Tab");

    // Area Form
    if (lat.isEmpty ||
        lat == '0' ||
        long.isEmpty ||
        long == '0' ||
        natureOfLoca.isEmpty ||
        infraConOfNeighAreas.isEmpty ||
        rateTheInfra.isEmpty ||
        siteAccess.isEmpty ||
        landuseOfNeighAreas.isEmpty) {
      missingTabs.add("Area Tab");
    }

    if (widget.onVisibility && (classOfLoc.isEmpty || ammenAvai.isEmpty)) {
      missingTabs.add("Area Tab");
    }
    // Occupancy Form
    if (staOcc.isEmpty ||
        occName.isEmpty ||
        occConNo.isEmpty ||
        occSince.isEmpty ||
        relationShipApp.isEmpty ||
        perMetContNo.isEmpty ||
        perMetSiteName.isEmpty) {
      missingTabs.add("Occupancy Tab");
    }

    for (var pubtransItem in pubtrans) {
      String name = pubtransItem['Name']?.toString() ?? '';
      String distance = pubtransItem['Distance']?.toString() ?? '';
      if (name.isEmpty || distance.isEmpty) {
        missingTabs.add("Area Tab");
      }
    }
    print(locMap);
    print(propPlan);
    print(ptoList);
    // Uploads Form
    if (locMap.isEmpty) missingTabs.add("Location Map Tab");
    if (propPlan.isEmpty) missingTabs.add("Property Plan Tab");
    if (ptoList.isEmpty) missingTabs.add("Photograph Tab");

    // Property Form
    if (region.isEmpty ||
        region == "0" ||
        city.isEmpty ||
        city == "0" ||
        prpAddress.isEmpty ||
        pincode.isEmpty ||
        propertyType.isEmpty ||
        propertyType == "0" ||
        propertySubType.isEmpty ||
        propertySubType == "0") {
      missingTabs.add("Property Tab");
      // isPropertyTab = true;
    }
    if (bhkConfig.isEmpty && propertyType == "952") {
      missingTabs.add("Property Tab");
    }
    // if (bhkConfig == null && propertyType == "952") {
    //   missingTabs.add("Property Tab c2");
    // }

    if ((kitchenAndCupboardsExisting == "Yes" && propertyType == "952") &&
        (kitchenTypeStr.isEmpty || kitchenTypeStr == "0")) {
      missingTabs.add("Property Tab");
    }

    if (propertyType == "953" && kitOrPan.isEmpty) {
      missingTabs.add("Property Tab");
    }

    // if (propertyType == "952" &&
    //     (kitchenTypeStr.isEmpty || kitchenTypeStr == "0")) {
    //   missingTabs.add("Property Tab c5");
    // }

    if ((noOfLifts.isEmpty) && propertyType != "958") {
      missingTabs.add("Property Tab");
    }

    if ((noOfstairCases.isEmpty) && propertyType != "958") {
      missingTabs.add("Property Tab");
    }

    // if (consOldOrNew == null && propertyType != "958") {
    //   missingTabs.add("Property Tab c8");
    // }
    if ((consOldOrNew.isEmpty || consOldOrNew == "0") &&
        propertyType != "958") {
      missingTabs.add("Property Tab");
    }

    if ((appAgeOfProp.isEmpty || appAgeOfProp == "0") &&
        propertyType != "958") {
      missingTabs.add("Property Tab");
    }

    if ((currentConOfProp.isEmpty || currentConOfProp == "0") &&
        propertyType != "958") {
      missingTabs.add("Property Tab");
    }
    // if ((currentConOfProp == null) && propertyType != "958") {
    //   missingTabs.add("Property Tab c10");
    // }

    if ((areaOfProp.isEmpty || areaOfProp == "0") &&
        (propertySubType == "8595" || propertySubType == "8594")) {
      missingTabs.add("Property Tab");
    }

    if (propertyType == "958") {
      if (unitType == "1" && sqft.isEmpty) {
        missingTabs.add("Property Tab");
      } else if (unitType == "3" && mtrs.isEmpty) {
        missingTabs.add("Property Tab");
      } else if (unitType == "4" && yards.isEmpty) {
        missingTabs.add("Property Tab");
      }
    }

    if (propertySubType == "5027" || propertySubType == "8942") {
      if (totalLandArea.isEmpty || totalLandArea == "0") {
        missingTabs.add("Property Tab");
      }
      if (propArea.isEmpty || propArea == "0") {
        missingTabs.add("Property Tab");
      }
    }

    if (propertyType != "958" && (mainLevel.isEmpty || mainLevel == "0")) {
      missingTabs.add("Property Tab");
    }

    return missingTabs.isEmpty;
  }
}
