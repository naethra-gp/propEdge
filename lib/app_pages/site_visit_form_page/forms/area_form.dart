import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:prop_edge/app_pages/site_visit_form_page/forms/form_manager/form_manager.dart';
import 'package:prop_edge/app_services/local_db/local_services/area_services.dart';
import 'package:prop_edge/app_services/local_db/local_services/dropdown_services.dart';
import 'package:prop_edge/app_theme/custom_theme.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/form/text_form_widget.dart';

import '../../../app_utils/alert_service2.dart';
import '../../../app_utils/app/app_button_widget.dart';
import '../../../app_utils/form/custom_single_dropdown.dart';

class AreaForm extends StatefulWidget {
  final VoidCallback buttonClicked;
  final String propId;
  final bool onVisibility;
  const AreaForm({
    super.key,
    required this.buttonClicked,
    required this.propId,
    required this.onVisibility,
  });

  @override
  State<AreaForm> createState() => _AreaFormState();
}

class _AreaFormState extends State<AreaForm> {
  /// GLOBAL DECLARATION
  AlertService alertService = AlertService();
  AreaServices areaServices = AreaServices();
  DropdownServices dropdownServices = DropdownServices();
  bool resedentialSelected = false;
  TextEditingController latCtrl = TextEditingController();
  TextEditingController lonCtrl = TextEditingController();
  TextEditingController landmarkCtrl = TextEditingController();
  TextEditingController widthOfApproach = TextEditingController();
  TextEditingController anyNeagtivesctrl = TextEditingController();
  List areaList = [];
  Map<dynamic, bool> selectedCheckboxes = {};
  Map<int, Map<String, TextEditingController>> transportControllers = {};

  ///Dropdown data
  List landuseOfNeighbouringAreas = [];
  List infrastructureConditionOfNeighboringArea = [];
  List rateTheInfraStructure = [];
  List amenities = [];
  List natureOfLocality = [];
  List accessibilityOfPublicTransport = [];
  List siteAccess = [];
  List classOfLocality = [];

  var pubTransportstr = [];

  /// REASIGN OF DATA
  String? landUseofNeighAreas;
  String? infrastructureCondOfNeighAreas;
  String? rateTheInfra;
  String? natureOfLoca;
  String? nearByLand;
  String? classOfLoc;
  List<String> selectedAmenities = [];
  String? siteAccessText;

  @override
  void initState() {
    // TODO: implement initState
    debugPrint('--- ${widget.onVisibility} ---');
    fetchAreaDetails(widget.propId);
    getDropdownData();
    if (latCtrl.text.toString() == "0" ||
        lonCtrl.text.toString() == "0" ||
        latCtrl.text.isEmpty ||
        lonCtrl.text.isEmpty) {
      checkPermission();
    }
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    latCtrl.dispose();
    lonCtrl.dispose();
    landmarkCtrl.dispose();
    widthOfApproach.dispose();
    anyNeagtivesctrl.dispose();
    for (var checkboxId in transportControllers.keys) {
      transportControllers[checkboxId]!['name']!.dispose();
      transportControllers[checkboxId]!['distance']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: FormManager().areaForm,
          child: Column(
            children: [
              /// Latitude & Longitude - Fields
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomTextFormField(
                      title: 'Latitude',
                      controller: latCtrl,
                      required: true,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.toString().isEmpty) {
                          return 'Mandatory Field!';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextFormField(
                      title: 'Longitude',
                      controller: lonCtrl,
                      suffixIconTrue: true,
                      suffixIcon: Icons.gps_fixed_rounded,
                      suffixIconOnPressed: checkPermission,
                      validator: (value) {
                        if (value == null || value.toString().isEmpty) {
                          return 'Mandatory Field!';
                        }
                        return null;
                      },
                      readOnly: true,
                      required: true,
                    ),
                  ),
                ],
              ),
              CustomTheme.defaultSize,

              /// Nearby Landmark - Field
              CustomTextFormField(
                title: 'Nearby Landmark',
                suffixIcon: Icons.gps_fixed,
                controller: landmarkCtrl,
                // validator: (value) => Validators.isEmpty(value),
                keyboardType: TextInputType.text,
              ),
              CustomTheme.defaultSize,

              /// Land-use of Neighboring Areas - DD
              CustomSingleDropdown(
                title: 'Land-use of Neighboring Areas',
                required: true,
                items: itemConvert(landuseOfNeighbouringAreas),
                dropdownValue: landUseofNeighAreas,
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return 'Mandatory Field!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    landUseofNeighAreas = value.toString();
                    // resedentialSelected = landUseofNeighAreas == "1014";
                  });
                },
              ),
              CustomTheme.defaultSize,

              /// Infrastructure Condition of Neighboring Areas - DD
              CustomSingleDropdown(
                title: 'Infrastructure Condition of Neighboring Areas',
                required: true,
                items: itemConvert(infrastructureConditionOfNeighboringArea),
                dropdownValue: infrastructureCondOfNeighAreas,
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return 'Mandatory Field!';
                  }
                  return null;
                },
                onChanged: (value) {
                  infrastructureCondOfNeighAreas = value.toString();
                  setState(() {});
                },
              ),
              CustomTheme.defaultSize,

              /// Rate the Infrastructure of the Area - DD
              CustomSingleDropdown(
                title: 'Rate the Infrastructure of the Area',
                required: true,
                items: itemConvert(rateTheInfraStructure),
                dropdownValue: rateTheInfra,
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return 'Mandatory Field!';
                  }
                  return null;
                },
                onChanged: (value) {
                  rateTheInfra = value.toString();
                  setState(() {});
                },
              ),
              CustomTheme.defaultSize,

              /// Nature of Locality - DD
              CustomSingleDropdown(
                title: 'Nature of Locality',
                required: true,
                items: itemConvert(natureOfLocality),
                dropdownValue: natureOfLoca,
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return 'Mandatory Field!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    natureOfLoca = value.toString();
                  });
                },
              ),

              /// only if - Residential DD selected
              // if (resedentialSelected) ...[
              CustomTheme.defaultSize,
              if (widget.onVisibility) ...[
                CustomSingleDropdown(
                  title: 'Class of Locality',
                  required: widget.onVisibility,
                  items: itemConvert(classOfLocality),
                  dropdownValue: classOfLoc,
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return 'Mandatory Field!';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (widget.onVisibility) {
                      setState(() {
                        classOfLoc = value.toString();
                      });
                    } else {
                      classOfLoc = '';
                    }
                  },
                ),
                CustomTheme.defaultSize,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "Amenities available",
                          style: CustomTheme.formLabelStyle,
                          children: const [
                            TextSpan(
                                text: ' *',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: amenities.map((item) {
                          String id = item['Id'].toString();
                          String name = item['Name'].toString();
                          return CheckboxListTile(
                            title:
                                Text(name, style: CustomTheme.formFieldStyle),
                            value: selectedAmenities.contains(id),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedAmenities.add(id);
                                } else {
                                  selectedAmenities.remove(id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    if (selectedAmenities.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 5),
                        child: Text(
                          'Please select at least one amenity',
                          style:
                              TextStyle(color: Colors.red[700], fontSize: 12),
                        ),
                      ),
                  ],
                ),
                CustomTheme.defaultSize,
              ],
              // ],
              CustomTheme.defaultSize,

              /// Accessibility of Public Transport - Checkboxes
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Accessibility of Public Transport",
                        style: CustomTheme.formLabelStyle,
                        children: const [
                          TextSpan(
                              text: ' *', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: accessibilityOfPublicTransport.map((item) {
                      int id = int.parse(item['Id'].toString());
                      String name = item['Name'].toString();

                      return Row(
                        children: [
                          Checkbox(
                            value: selectedCheckboxes[id] ?? false,
                            onChanged: (val) {
                              setState(() {
                                selectedCheckboxes[id] = val ?? false;
                                if (!val!) {
                                  transportControllers.remove(id);
                                }
                              });
                            },
                          ),
                          Text(name, style: CustomTheme.formFieldStyle),
                        ],
                      );
                    }).toList(),
                  ),

                  // Conditionally Display Fields Based on Selection
                  if (selectedCheckboxes[968] ?? false)
                    ...buildNearestTransportFields(
                        "Nearest Airport", selectedCheckboxes[968]!, 968),
                  if (selectedCheckboxes[969] ?? false)
                    ...buildNearestTransportFields("Nearest Bus stop local",
                        selectedCheckboxes[969]!, 969),
                  if (selectedCheckboxes[970] ?? false)
                    ...buildNearestTransportFields(
                        "Nearest Inter-City Bus Depot",
                        selectedCheckboxes[970]!,
                        970),
                  if (selectedCheckboxes[971] ?? false)
                    ...buildNearestTransportFields(
                        "Nearest Local Train Station",
                        selectedCheckboxes[971]!,
                        971),
                  if (selectedCheckboxes[972] ?? false)
                    ...buildNearestTransportFields(
                        "Nearest Metro Station", selectedCheckboxes[972]!, 972),
                  if (selectedCheckboxes[973] ?? false)
                    ...buildNearestTransportFields("Nearest Railway Station",
                        selectedCheckboxes[973]!, 973),
                ],
              ),

              /// Site Access - DD
              CustomSingleDropdown(
                title: 'Site Access',
                required: true,
                items: itemConvert(siteAccess),
                dropdownValue: siteAccessText,
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return 'Mandatory Field!';
                  }
                  return null;
                },
                onChanged: (value) {
                  siteAccessText = value.toString();
                  setState(() {});
                },
              ),
              CustomTheme.defaultSize,

              /// Width of Approach Road - Field
              CustomTextFormField(
                title: 'Width of Approach Road (in Meters)',
                controller: widthOfApproach,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.toString().isNotEmpty) {
                    RegExp regex = RegExp(r'^\d{1,5}(\.\d{1,2})?$');
                    if (!regex.hasMatch(value)) {
                      return 'Enter the valid width (e.g. 12345.67)';
                    }
                  }
                  return null;
                },
              ),
              CustomTheme.defaultSize,

              /// Negatives - Field
              CustomTextFormField(
                title: 'Negatives (if any)',
                required: true,
                controller: anyNeagtivesctrl,
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return 'Mandatory Field!';
                  }

                  return null;
                },
              ),
              SizedBox(height: 25),

              /// Save button
              AppButton(
                title: "Save & Next",
                onPressed: () async {
                  /// Checking for Transport Controllers
                  if (transportControllers.isEmpty) {
                    alertService.errorToast('Public Transport is Mandatory!');
                    return;
                  }

                  /// Checking for Lat & Long
                  if (latCtrl.text == "0" || lonCtrl.text == "0") {
                    alertService
                        .errorToast('Latitude or Longitude should not be 0');
                    return;
                  }

                  /// Form Validation
                  if (FormManager().areaForm.currentState!.validate()) {
                    FormManager().areaForm.currentState!.save();
                    FocusScope.of(context).unfocus();
                    saveForm(); // Save Form if validated
                  }
                },
              ),
              CustomTheme.defaultSize,
            ],
          ),
        ),
      ),
    );
  }

  /// Initial Fetch of Area Details
  fetchAreaDetails(String propId) async {
    areaList = await areaServices.read(propId);
    if (areaList.isNotEmpty) {
      var area = areaList.first;
      latCtrl.text = trimText(area['Latitude']);
      lonCtrl.text = trimText(area['Longitude']);
      landmarkCtrl.text = trimText(area['NearbyLandmark']);

      landUseofNeighAreas =
          convertString(area['LandUseOfNeighboringAreas'].toString());
      // if (landUseofNeighAreas == '1014') {
      //   resedentialSelected = true;
      // }

      infrastructureCondOfNeighAreas = convertString(
          area['InfrastructureConditionOfNeighboringAreas'].toString());
      rateTheInfra =
          convertString(area['InfrastructureOfTheSurroundingArea'].toString());
      natureOfLoca = convertString(area['NatureOfLocality'].toString());

      // Only set class of locality and amenities if property is residential
      if (widget.onVisibility) {
        classOfLoc = convertString(area['ClassOfLocality'].toString());
        // Handle multiple amenities
        String amenitiesStr = area['Amenities'].toString();
        if (amenitiesStr.isNotEmpty && amenitiesStr != '0') {
          selectedAmenities = amenitiesStr.split(',');
        }
      } else {
        // Clear values if property is not residential
        classOfLoc = null;
        selectedAmenities = [];
      }

      siteAccessText = convertString(area['SiteAccess'].toString());

      pubTransportstr = jsonDecode(area['PublicTransport']);

      /// Create LOOP for Public Transport details
      for (var item in pubTransportstr) {
        int id = int.parse(item['TypeId'].toString());
        selectedCheckboxes[id] = true;
        if (!transportControllers.containsKey(id)) {
          transportControllers[id] = {
            'name': TextEditingController(),
            'distance': TextEditingController(),
          };
        }
        transportControllers[id]!['name']!.text = item['Name'] ?? '';
        transportControllers[id]!['distance']!.text = item['Distance'] ?? '';
      }

      widthOfApproach.text =
          trimText(area['ConditionAndWidthOfApproachRoad'].toString());
      anyNeagtivesctrl.text =
          trimText(area['AnyNegativeToTheLocality'].toString());
      setState(() {});
    }
  }

  convertString(String text) {
    if (text == '0' || text == '') {
      return null;
    }
    return text.toString().trim();
  }

  trimText(String text) {
    return text.toString().trim();
  }

  /// Initial Fetch Of Dropdown data's
  getDropdownData() async {
    landuseOfNeighbouringAreas =
        await dropdownServices.readByType('LandUseOfNeighboringArea');
    infrastructureConditionOfNeighboringArea = await dropdownServices
        .readByType('InfrastructureConditionOfNeighboringArea');
    rateTheInfraStructure =
        await dropdownServices.readByType('InfrastructureOfTheSurroundingArea');
    natureOfLocality = await dropdownServices.readByType('NatureOfLocality');
    accessibilityOfPublicTransport =
        await dropdownServices.readByType('AccessibilityOfPublicTransport');
    classOfLocality = await dropdownServices.readByType('ClassOfLocality');
    amenities = await dropdownServices.readByType('Amenities');
    siteAccess = await dropdownServices.readByType('SiteAccess');

    setState(() {});
  }

  itemConvert(List list) {
    return list.map((e) {
      return DropdownMenuItem(
        value: e['Id'].toString(),
        child: Text(
          e['Name'].toString(),
          style: CustomTheme.formFieldStyle,
        ),
      );
    }).toList();
  }

  /// Location Data
  checkPermission() async {
    PermissionStatus checkPermission = await Location().hasPermission();
    bool serviceEnabled = await Location().serviceEnabled();

    /// Check for Location Service Enabled
    if (!serviceEnabled) {
      serviceEnabled = await Location().requestService();
      if (!serviceEnabled) {
        alertService.errorToast('Location services are disabled.');
        return;
      }
    }
    if (checkPermission == PermissionStatus.denied) {
      checkPermission = await Location().requestPermission();
      if (checkPermission == PermissionStatus.denied) {
        Fluttertoast.showToast(msg: 'Request Denied !');
        return;
      }
    }
    if (checkPermission == PermissionStatus.deniedForever) {
      Fluttertoast.showToast(msg: 'Denied Forever !');
      return;
    }

    /// Get Lat & Long Data
    getLocData();
  }

  /// Lat & Long Data
  getLocData() async {
    alertService.showLoading();
    print('location done');
    LocationData? locationData = await Location().getLocation();
    alertService.hideLoading();
    setState(() {
      latCtrl.text = locationData.latitude.toString();
      lonCtrl.text = locationData.longitude.toString();
    });
  }

  /// Trsnsport Fields Based on checkbox Selected
  List<Widget> buildNearestTransportFields(
      String title, bool selected, int checkboxId) {
    if (!transportControllers.containsKey(checkboxId)) {
      transportControllers[checkboxId] = {
        'name': TextEditingController(),
        'distance': TextEditingController(),
      };
    }
    // String distanceLabel = 'Distance';
    // if (checkboxId == 968 || checkboxId == 969) {
    //   distanceLabel = 'Distance (in Km)';
    // }
    return [
      Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            text: title,
            style: CustomTheme.formLabelStyle,
          ),
        ),
      ),
      const SizedBox(height: 5),
      Row(
        children: [
          Expanded(
              child: CustomTextFormField(
            title: 'Name',
            controller: transportControllers[checkboxId]!['name'],
            required: selected,
            validator: (value) {
              if (value == null || value.toString().isEmpty || !selected) {
                return 'Mandatory Field!';
              }
              return null;
            },
          )),
          const SizedBox(width: 10),
          Expanded(
              child: CustomTextFormField(
            title: 'Distance (in Km)',
            keyboardType: TextInputType.number,
            required: selected,
            controller: transportControllers[checkboxId]!['distance'],
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(
            //       RegExp(r'^\d{0,2}(\.\d{0,2})?$')),
            // ],
            validator: (value) {
              if (value != null && value.toString().isNotEmpty) {
                RegExp regex = RegExp(r'^\d{1,5}(\.\d{1,2})?$');
                if (!regex.hasMatch(value)) {
                  return 'Enter the valid Distance';
                }
              }
              return null;
            },
          )),
        ],
      ),
      CustomTheme.defaultSize,
    ];
  }

  /// Save Area Details
  saveForm() async {
    List<Map<String, dynamic>> transportDataValues = [];
    selectedCheckboxes.forEach((checkboxId, isSelected) {
      if (isSelected) {
        var controllers = transportControllers[checkboxId];
        if (controllers != null) {
          String name = controllers['name']!.text;
          String distance = controllers['distance']!.text;

          var checkboxItem = accessibilityOfPublicTransport.firstWhere(
            (item) => int.parse(item['Id'].toString()) == checkboxId,
          );

          String typeName =
              checkboxItem.isNotEmpty ? checkboxItem['Name'].toString() : '';

          TransportInfo transportInfo = TransportInfo(
            distance: distance,
            id: checkboxId,
            name: name,
            typeId: checkboxId,
            typeName: typeName,
          );
          transportDataValues.add(transportInfo.toJson());
        }
      }
    });
    String transportDataJson = jsonEncode(transportDataValues);
    if (widget.onVisibility && selectedAmenities.isEmpty) {
      alertService.errorToast('Please select at least one amenity');
      return;
    }

    /// Request Data to send Area Details
    var request = [
      trimText(latCtrl.text),
      trimText(lonCtrl.text),
      trimText(landmarkCtrl.text),
      trimText(landUseofNeighAreas.toString()),
      trimText(infrastructureCondOfNeighAreas.toString()),
      trimText(rateTheInfra.toString()),
      trimText(natureOfLoca.toString()),
      if (widget.onVisibility) ...{
        trimText(classOfLoc.toString()),
        selectedAmenities.join(',') // Join multiple amenities with comma
      } else ...[
        classOfLoc = '0',
        ''
      ],
      transportDataJson,
      trimText(siteAccessText.toString()),
      trimText(widthOfApproach.text),
      trimText(anyNeagtivesctrl.text),
      "N",
      widget.propId
    ];

    /// Update LocalDB
    var updated = await areaServices.updateLocalSync(request);

    if (updated == 1) {
      alertService.successToast("Area details saved successfully.");
      widget.buttonClicked();
    } else {
      alertService.errorToast("Area details saved failed!");
    }
  }
}

/// Transport Information - Model
class TransportInfo {
  final String distance;
  final int id;
  final String name;
  final int typeId;
  final String typeName;

  TransportInfo({
    required this.distance,
    required this.id,
    required this.name,
    required this.typeId,
    required this.typeName,
  });

  Map<String, dynamic> toJson() {
    return {
      'Distance': distance,
      'Id': id,
      'Name': name,
      'TypeId': typeId,
      'TypeName': typeName,
    };
  }
}
