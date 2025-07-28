import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prop_edge/app_utils/alert_service2.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/form/custom_single_dropdown.dart';

import '../../../app_services/local_db/local_services/dropdown_services.dart';
import '../../../app_services/local_db/local_services/local_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_utils/app/app_button_widget.dart';
import '../../../app_utils/app/common_functions.dart';
import '../../../app_utils/form/text_form_widget.dart';
import 'form_manager/form_manager.dart';

class PropertyForm extends StatefulWidget {
  final String propId;
  final VoidCallback buttonClicked;
  final void Function(bool) onVisibility;

  const PropertyForm({
    super.key,
    required this.propId,
    required this.buttonClicked,
    required this.onVisibility,
  });

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  // final _formKey = GlobalKey<FormState>();

  // Radio Button Declarations
  String addressMatching = "";
  String cupboardsGroupValue = "";
  String kitchenGroupValue = "";
  String unitGroupValue = "";

  // Services Declarations
  DropdownServices dropdownServices = DropdownServices();
  CustomerServices cService = CustomerServices();
  AlertService alertService = AlertService();
  PropertyDetailsServices services = PropertyDetailsServices();

  // Controllers Declarations
  TextEditingController colonyCtrl = TextEditingController();
  TextEditingController propertyAddressCtrl = TextEditingController();
  TextEditingController pincodeCtrl = TextEditingController();
  TextEditingController municipalCtrl = TextEditingController();
  TextEditingController projectCtrl = TextEditingController();
  TextEditingController developerCtrl = TextEditingController();
  TextEditingController bhkCtrl = TextEditingController();
  TextEditingController structureOthersCtrl = TextEditingController();
  TextEditingController floorOthersCtrl = TextEditingController();
  TextEditingController liftCtrl = TextEditingController();
  TextEditingController staircaseCtrl = TextEditingController();
  TextEditingController ageOfPropertyCtrl = TextEditingController();
  TextEditingController areaOfPropertyCtrl = TextEditingController();
  // TextEditingController plotAreaCtrl = TextEditingController();
  TextEditingController sqftCtrl = TextEditingController();
  TextEditingController sqMeterCtrl = TextEditingController();
  TextEditingController sqYardsCtrl = TextEditingController();
  TextEditingController totalLandCtrl = TextEditingController();
  TextEditingController propertyAreaCtrl = TextEditingController();

  // Dropdown List Declarations
  List regionList = [];
  List cityList = [];
  List propertyList = [];
  List propertySubList = [];
  List bhkList = [];
  List structureList = [];
  List floorList = [];
  List kitchenTypeList = [];
  List constructionList = [];
  List conditionList = [];
  List unitTypeList = [];
  List maintenanceList = [];

  // Dropdown Selected value Declarations
  String? selectedCity;
  String? selectedRegion;
  String? selectedMaintenance;
  String? selectedPropertyType;
  String? selectedPropertySubType;
  String? selectedBHK;
  String? selectedStructure;
  String? selectedFloor;
  String? selectedKitchenType;
  String? selectedConstruction;
  String? selectedCondition;

  String? selectedOption;

  @override
  void initState() {
    super.initState();
    getDropDownData();
  }

  // Initial fetch of Dropdown Details
  getDropDownData() async {
    regionList = await dropdownServices.readByType('Region');
    propertyList = await dropdownServices.readByType('PropertyType');
    bhkList = await dropdownServices.readByType('BHKConfiguration');
    structureList = await dropdownServices.readByType('Structure');
    floorList = await dropdownServices.readByType('Floor');
    kitchenTypeList = await dropdownServices.readByType('KitchenType');
    constructionList =
        await dropdownServices.readByType('ConstructionOldOrNew');
    conditionList =
        await dropdownServices.readByType('CurrentConditionOfProperty');
    unitTypeList = await dropdownServices.readByType('UnitType');
    maintenanceList = await dropdownServices.readByType('MaintenanceLevel');
    fetchValue();
    setState(() {});
  }

  // Initial fetch of Property Details
  fetchValue() async {
    List list = await services.readById(widget.propId);
    // print("property ${jsonEncode(list)}");
    selectedRegion = convertNull(list[0]['Region']);
    List a = regionList
        .where((e) => e['Id'].toString() == selectedRegion.toString())
        .toList();
    if (a.isNotEmpty) {
      cityList = jsonDecode(a[0]['Options']);
      selectedCity = convertNull(list[0]['City'].toString());
    }

    colonyCtrl.text = list[0]['Colony'].toString();
    addressMatching = list[0]['AddressMatching'].toString();
    propertyAddressCtrl.text = list[0]['PropertyAddressAsPerSite'].toString();
    pincodeCtrl.text = list[0]['Pincode'].toString();
    municipalCtrl.text = list[0]['NameOfMunicipalBody'].toString();
    selectedPropertyType = convertNull(list[0]['PropertyType']);
    List b = propertyList
        .where((e) => e['Id'].toString() == selectedPropertyType.toString())
        .toList();
    if (b.isNotEmpty) {
      propertySubList = jsonDecode(b[0]['Options']);
      selectedPropertySubType =
          convertNull(list[0]['PropertySubType'].toString());
    }
    projectCtrl.text = list[0]['ProjectName'].toString();
    developerCtrl.text = list[0]['DeveloperName'].toString();
    // TODO: --- Check BHK ---
    if (selectedPropertyType == "952" &&
        (selectedPropertySubType != '449' &&
            selectedPropertySubType != '8594')) {
      selectedBHK = convertNull(list[0]['BHKConfiguration'].toString());
    } else {
      bhkCtrl.text = list[0]['BHKConfiguration'].toString();
    }
    selectedStructure = convertNull(list[0]['Structure'].toString());
    structureOthersCtrl.text = list[0]['StructureOthers'].toString();
    floorOthersCtrl.text = list[0]['FloorOthers'].toString();
    selectedFloor = convertNull(list[0]['Floor'].toString());
    cupboardsGroupValue = list[0]['KitchenAndCupboardsExisting'].toString();
    kitchenGroupValue = list[0]['KitchenOrPantry'].toString();
    selectedKitchenType = convertNull(list[0]['KitchenType'].toString());
    liftCtrl.text = list[0]['NoOfLifts'].toString();
    staircaseCtrl.text = list[0]['NoOfStaircases'].toString();

    selectedConstruction =
        convertNull(list[0]['ConstructionOldNew'].toString());
    ageOfPropertyCtrl.text = list[0]['AgeOfProperty'].toString();
    selectedCondition = convertNull(list[0]['ConditionOfProperty'].toString());
    areaOfPropertyCtrl.text = list[0]['AreaOfProperty'].toString();
    totalLandCtrl.text = list[0]['LandArea'].toString();
    propertyAreaCtrl.text = list[0]['PropertyArea'].toString();
    selectedMaintenance = convertNull(list[0]['MaintainanceLevel'].toString());
    unitGroupValue = list[0]['PlotUnitType'].toString();
    // plotAreaCtrl = convertNull(list[0]['PlotUnitType'].toString());
    sqftCtrl.text = list[0]['PlotAreaSqft'].toString();
    sqMeterCtrl.text = list[0]['PlotAreaMtrs'].toString();
    sqYardsCtrl.text = list[0]['PlotAreaYards'].toString();

    setState(() {});
  }

  convertNull(String value) {
    if (value == '0' || value == '') {
      return null;
    }
    return value;
  }

  @override
  void dispose() {
    super.dispose();
    colonyCtrl.dispose();
    propertyAddressCtrl.dispose();
    pincodeCtrl.dispose();
    municipalCtrl.dispose();
    projectCtrl.dispose();
    developerCtrl.dispose();
    bhkCtrl.dispose();
    structureOthersCtrl.dispose();
    floorOthersCtrl.dispose();
    liftCtrl.dispose();
    staircaseCtrl.dispose();
    ageOfPropertyCtrl.dispose();
    areaOfPropertyCtrl.dispose();
    sqftCtrl.dispose();
    sqMeterCtrl.dispose();
    sqYardsCtrl.dispose();
    totalLandCtrl.dispose();
    propertyAreaCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: FormManager().propertyForm,
          child: Column(
            children: [
              Row(
                children: [
                  /// Region & City <-> Dropdown
                  Expanded(
                    child: CustomSingleDropdown(
                      required: true,
                      dropdownValue: selectedRegion,
                      items: itemConvert(regionList),
                      title: 'Region',
                      validator: (value) =>
                          value == null ? "Mandatory Field!" : null,
                      onChanged: (value) {
                        selectedRegion = value.toString();
                        List a = regionList
                            .where(
                                (e) => e['Id'].toString() == value.toString())
                            .toList();
                        cityList = jsonDecode(a[0]['Options']);
                        selectedCity = null;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  // City - Dropdown - Based on Region
                  Expanded(
                    child: CustomSingleDropdown(
                      required: true,
                      dropdownValue: selectedCity,
                      items: itemConvert(cityList),
                      title: 'City',
                      validator: (value) =>
                          value == null ? "Mandatory Field!" : null,
                      onChanged: (value) {
                        selectedCity = value.toString();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              CustomTheme.defaultSize,
              // Colony/Locality/Micro-market - Field
              CustomTextFormField(
                controller: colonyCtrl,
                title: 'Colony/Locality/Micro-market',
                maxLength: 200,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9\s./,]'),
                  ),
                ],
              ),
              CustomTheme.defaultSize,
              // Address Matching - Radio button
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: "Address Matching",
                    style: CustomTheme.formLabelStyle,
                    children: const [
                      TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
              ),
              // FormField<String>(
              //   validator: (value) {
              //     if (value == null) {
              //       return "Address Matching is Mandatory!";
              //     }
              //     return null;
              //   },
              //   builder: (FormFieldState<String> state) {
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Row(
              //           children: [
              //             Radio<String>(
              //               value: 'Yes',
              //               groupValue: addressMatching,
              //               onChanged: (String? value) async {
              //                 List d = await cService.readById(widget.propId);
              //                 addressMatching = value.toString();
              //                 propertyAddressCtrl.text =
              //                     d[0]['PropertyAddress'];
              //                 state.didChange(value);
              //                 setState(() {});
              //               },
              //             ),
              //             Text("Yes", style: CustomTheme.formFieldStyle),
              //             SizedBox(width: 50),
              //             Radio<String>(
              //               value: 'No',
              //               groupValue: addressMatching,
              //               onChanged: (String? value) {
              //                 addressMatching = value.toString();
              //                 propertyAddressCtrl.text = '';
              //                 state.didChange(value);
              //                 setState(() {});
              //               },
              //             ),
              //             Text("No", style: CustomTheme.formFieldStyle),
              //           ],
              //         ),
              //         if (state.hasError)
              //           Text(
              //             state.errorText!,
              //             style: CustomTheme.errorStyle,
              //           ),
              //       ],
              //     );
              //   },
              // ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Yes',
                    groupValue: addressMatching,
                    onChanged: (String? value) async {
                      List d = await cService.readById(widget.propId);
                      addressMatching = value.toString();
                      propertyAddressCtrl.text = d[0]['PropertyAddress'];
                      setState(() {});
                    },
                  ),
                  Text('Yes', style: CustomTheme.formFieldStyle),
                  SizedBox(width: 50),
                  Radio<String>(
                    value: 'No',
                    groupValue: addressMatching,
                    onChanged: (String? value) {
                      propertyAddressCtrl.text = '';
                      addressMatching = value.toString();
                      setState(() {});
                    },
                  ),
                  Text('No', style: CustomTheme.formFieldStyle),
                ],
              ),
              CustomTheme.defaultSize,
              // Property Address - Field
              CustomTextFormField(
                title: 'Property Address',
                controller: propertyAddressCtrl,
                readOnly: addressMatching == 'Yes',
                required: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mandatory Field";
                  }
                  return null;
                },
              ),
              CustomTheme.defaultSize,
              // Pincode - Field
              CustomTextFormField(
                title: 'Pincode',
                controller: pincodeCtrl,
                required: true,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // ✅ Only digits
                  LengthLimitingTextInputFormatter(6), // ✅ Max 6 digits
                ],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    FocusScope.of(context).unfocus();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mandatory Field";
                  } else if (value.length != 6) {
                    return "Pincode must be exactly 6 digits";
                  }
                  return null;
                },
              ),
              CustomTheme.defaultSize,
              // Name of Municipal Body/Jurisdiction - Field
              CustomTextFormField(
                controller: municipalCtrl,
                title: 'Name of Municipal Body/Jurisdiction',
              ),
              CustomTheme.defaultSize,
              // Property Type - DD
              Row(
                children: [
                  Expanded(
                    child: CustomSingleDropdown(
                      required: true,
                      dropdownValue: selectedPropertyType,
                      items: itemConvert(propertyList),
                      title: 'Property Type',
                      validator: (value) =>
                          value == null ? "Mandatory Field!" : null,
                      onChanged: (value) {
                        selectedPropertyType = value.toString();
                        List a = propertyList
                            .where(
                                (e) => e['Id'].toString() == value.toString())
                            .toList();
                        propertySubList = jsonDecode(a[0]['Options']);
                        selectedPropertySubType = null;
                        selectedStructure = null;
                        selectedBHK = null;
                        bhkCtrl.text = '';
                        selectedStructure = null;
                        structureOthersCtrl.text = '';
                        selectedFloor = null;
                        floorOthersCtrl.text = '';
                        selectedKitchenType = null;
                        selectedConstruction = null;
                        selectedCondition = null;
                        cupboardsGroupValue = '';
                        kitchenGroupValue = '';
                        liftCtrl.text = '';
                        staircaseCtrl.text = '';
                        ageOfPropertyCtrl.text = '';
                        unitGroupValue = '';
                        sqftCtrl.text = '';
                        sqMeterCtrl.text = '';
                        sqYardsCtrl.text = '';
                        selectedMaintenance = null;
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  // Property Sub-type - DD
                  Expanded(
                    child: CustomSingleDropdown(
                      title: 'Property Sub-type',
                      required: true,
                      dropdownValue: selectedPropertySubType,
                      items: itemConvert(propertySubList),
                      validator: (value) =>
                          value == null ? "Mandatory Field!" : null,
                      onChanged: (value) {
                        setState(() {
                          selectedPropertySubType = value.toString();
                          selectedBHK = null;
                          bhkCtrl.text = '';
                          totalLandCtrl.text = '';
                          propertyAreaCtrl.text = '';
                          areaOfPropertyCtrl.text = '';
                        });
                      },
                    ),
                  ),
                ],
              ),
              CustomTheme.defaultSize,
              // Project Name - Field
              CustomTextFormField(
                title: 'Project Name',
                controller: projectCtrl,
              ),
              CustomTheme.defaultSize,
              // Builder/Developer Name - Field
              CustomTextFormField(
                title: 'Builder/Developer Name',
                controller: developerCtrl,
              ),
              CustomTheme.defaultSize,

              /// BHK Configuration -  (Only for Residential)
              /// (Textbox in case of Row houses and Villas, Dropdown for rest)
              /// 449 - Row House and 8594 - Villas
              if (selectedPropertyType == "952" &&
                  (selectedPropertySubType != '449' &&
                      selectedPropertySubType != '8594')) ...[
                CustomSingleDropdown(
                  required: true,
                  dropdownValue: selectedBHK,
                  items: itemConvert(bhkList),
                  title: 'BHK Configuration',
                  validator: (value) =>
                      value == null ? "Mandatory Field!" : null,
                  onChanged: (value) {
                    selectedBHK = value.toString();
                    setState(() {});
                  },
                ),
                CustomTheme.defaultSize,
              ],
              if (selectedPropertyType == "952" &&
                  (selectedPropertySubType == '449' ||
                      selectedPropertySubType == '8594')) ...[
                CustomTextFormField(
                  title: 'BHK Configuration',
                  required: true,
                  controller: bhkCtrl,
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "Mandatory Field!";
                    }
                    return null;
                  },
                ),
                CustomTheme.defaultSize,
              ],

              /// Structure - Dropdown - Mandatory  (Not to open for Plots)
              /// 958 - Plots value(id) in dropdown api.
              if (selectedPropertyType != "958") ...[
                Row(
                  children: [
                    Expanded(
                      child: CustomSingleDropdown(
                        required: true,
                        dropdownValue: selectedStructure,
                        items: itemConvert(structureList),
                        title: 'Structure',
                        validator: (value) =>
                            value == null ? "Mandatory Field!" : null,
                        onChanged: (value) {
                          selectedStructure = value.toString();
                          if (selectedStructure != "1007") {
                            structureOthersCtrl
                                .clear(); // Clear text when not "Others"
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        title: 'Others',
                        controller: structureOthersCtrl,
                        readOnly: selectedStructure != "1007",
                      ),
                    ),
                  ],
                ),
                CustomTheme.defaultSize,
              ],

              /// Floor - Dropdown (Only for Residential)
              if (selectedPropertyType == "952") ...[
                Row(
                  children: [
                    Expanded(
                      child: CustomSingleDropdown(
                        required: false,
                        dropdownValue: selectedFloor,
                        items: itemConvert(floorList),
                        title: 'Floor',
                        onChanged: (value) {
                          selectedFloor = value.toString();
                          if (selectedFloor != "1007") {
                            floorOthersCtrl
                                .clear(); // Clear text when not "Others"
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        title: 'Others',
                        controller: floorOthersCtrl,
                        readOnly: selectedFloor != "1008",
                      ),
                    ),
                  ],
                ),
                CustomTheme.defaultSize,
              ],

              /// Property has Kitchen & Cupboards existing or not? (Only for Residential)
              if (selectedPropertyType == "952") ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "Property has Kitchen & Cupboards existing or not?",
                      style: CustomTheme.formLabelStyle,
                      children: const [
                        TextSpan(
                            text: ' *', style: TextStyle(color: Colors.red))
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: cupboardsGroupValue,
                      onChanged: (String? value) {
                        setState(() {
                          cupboardsGroupValue = value.toString();
                        });
                      },
                    ),
                    Text('Yes', style: CustomTheme.formFieldStyle),
                    SizedBox(width: 50),
                    Radio<String>(
                      value: 'No',
                      groupValue: cupboardsGroupValue,
                      onChanged: (String? value) {
                        setState(() {
                          cupboardsGroupValue = value.toString();
                        });
                      },
                    ),
                    Text('No', style: CustomTheme.formFieldStyle),
                  ],
                ),
                CustomTheme.defaultSize,
                if (cupboardsGroupValue == 'Yes') ...[
                  /// Kitchen Type (if yes): (Only for Residential) (dropdown)
                  CustomSingleDropdown(
                    required: true,
                    dropdownValue: selectedKitchenType,
                    items: itemConvert(kitchenTypeList),
                    title: 'Kitchen Type',
                    validator: (value) =>
                        value == null ? "Mandatory Field!" : null,
                    onChanged: (value) {
                      selectedKitchenType = value.toString();
                      setState(() {});
                    },
                  ),
                  CustomTheme.defaultSize,
                ],
              ],

              /// Property has Kitchen or Pantry? (Only for Commercial)
              /// 953 is Commercial ID in dropdown master.
              if (selectedPropertyType == "953") ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "Property has Kitchen or Pantry?",
                      style: CustomTheme.formLabelStyle,
                      children: const [
                        TextSpan(
                            text: ' *', style: TextStyle(color: Colors.red))
                      ],
                    ),
                  ),
                ),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: 'Kitchen',
                      groupValue: kitchenGroupValue,
                      onChanged: (String? value) {
                        setState(() {
                          kitchenGroupValue = value.toString();
                        });
                      },
                    ),
                    Text('Kitchen', style: CustomTheme.formFieldStyle),
                    SizedBox(width: 50),
                    Radio<String>(
                      value: 'Pantry',
                      groupValue: kitchenGroupValue,
                      onChanged: (String? value) {
                        setState(() {
                          kitchenGroupValue = value.toString();
                        });
                      },
                    ),
                    Text('Pantry', style: CustomTheme.formFieldStyle),
                  ],
                ),
                CustomTheme.defaultSize,
              ],

              /// * Construction Old or New:(dropdown) (Not to open for Plots)
              if (selectedPropertyType != "958") ...[
                Row(
                  children: [
                    /// No. of Lifts: (Not to open for Plots)
                    Expanded(
                      child: CustomTextFormField(
                        title: 'No. of Lifts',
                        controller: liftCtrl,
                        maxLength: 2,
                        required: true,
                        validator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return "Mandatory Field!";
                          }
                          return null;
                        },
                        // validator: (value) =>
                        //     value == null ? "Mandatory Field!" : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(width: 10),

                    /// * No. of staircases: (Not to open for Plots)
                    Expanded(
                      child: CustomTextFormField(
                        title: 'No. of staircases',
                        controller: staircaseCtrl,
                        maxLength: 2,
                        required: true,
                        validator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return "Mandatory Field!";
                          }
                          return null;
                        },
                        // validator: (value) =>
                        //     value == null ? "Mandatory Field!" : null,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                CustomTheme.defaultSize,
                CustomSingleDropdown(
                  required: true,
                  dropdownValue: selectedConstruction,
                  items: itemConvert(constructionList),
                  title: 'Construction Old or New',
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "Mandatory Field!";
                    }
                    return null;
                  },
                  // validator: (value) =>
                  //     value == null ? "Mandatory Field!" : null,
                  onChanged: (value) {
                    selectedConstruction = value.toString();
                    setState(() {});
                  },
                ),
                CustomTheme.defaultSize,

                /// *  Approximate Age of Property (in years)  (Not to open for Plots) >> only numbers
                // CustomTextFormField(
                //   title: 'Approximate Age of Property (in years)',
                //   controller: ageOfPropertyCtrl,
                //   required: true,
                //   validator: (value) {
                //     if (value == null || value.toString().isEmpty) {
                //       return "Mandatory Field!";
                //     }
                //     return null;
                //   },
                //   // validator: (value) =>
                //   //     value == null ? "Mandatory Field!" : null,
                // ),
                CustomTextFormField(
                  title: 'Approximate Age of Property (in years)',
                  controller: ageOfPropertyCtrl,
                  required: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return "Mandatory Field!";
                    }

                    final int? age = int.tryParse(value);
                    if (age == null) return 'Enter a valid number';

                    if (selectedConstruction == "983" &&
                        (age < 0 || age > 10)) {
                      return 'Enter a value between >=10 and <=0';
                    } else if (selectedConstruction == "984" &&
                        (age < 10 || age > 20)) {
                      return 'Enter a value between <=10 and >=20';
                    } else if (selectedConstruction == "985" &&
                        (age < 20 || age > 100)) {
                      return 'Enter a value >= 20 (max 100)';
                    }

                    return null;
                  },
                ),

                CustomTheme.defaultSize,

                /// * Current Condition of Property: (Not to open for Plots) (dropdown)
                CustomSingleDropdown(
                  required: true,
                  dropdownValue: selectedCondition,
                  items: itemConvert(conditionList),
                  title: 'Current Condition of Property',
                  validator: (value) =>
                      value == null ? "Mandatory Field!" : null,
                  onChanged: (value) {
                    selectedCondition = value.toString();
                    setState(() {});
                  },
                ),
                CustomTheme.defaultSize,
              ],

              /// * For Apartment, Villa, Office, Shop, Industrial & Other Property Type
              /// 	>> Area of Property (in Sq. Ft): (only number) (validation - 2 digit to 5 digit)
              if (selectedPropertySubType == '8595' ||
                  selectedPropertySubType == '8594') ...[
                CustomTextFormField(
                  title: 'Area of Property (in Sq. Ft)',
                  controller: areaOfPropertyCtrl,
                  keyboardType: TextInputType.number,
                  required: true,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(
                  //     RegExp(r'^\d{2,5}(\.\d{1,2})?$'),
                  //   ),
                  // ],
                  validator: (value) {
                    final pattern = RegExp(r'^\d{2,5}(\.\d{1,2})?$');
                    if (value.isEmpty || !pattern.hasMatch(value)) {
                      return 'Enter a number with 2-5 digits (max 2 decimals)';
                    }
                    return null;
                  },
                  onChanged: (String value) {},
                ),
                CustomTheme.defaultSize,
              ],

              /// * For Plots
              /// 	Unit type:  (In Sq. Ft)  (In Sq. Mtrs)             (In Sq. Yards)
              /// 	Plot Area:  text box - allow only numbers  (validation - 2 digit to 5 digit)
              /// 	[Site Engineer can fill any of the 3, the rest 2 will fill automatically
              if (selectedPropertyType == "958") ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: "Unit type",
                      style: CustomTheme.formLabelStyle,
                      children: const [
                        TextSpan(
                            text: ' *', style: TextStyle(color: Colors.red))
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var e in unitTypeList) ...[
                        Radio<String>(
                          value: e['Id'].toString(),
                          groupValue: unitGroupValue,
                          onChanged: (String? value) {
                            unitGroupValue = value.toString();
                            setState(() {});
                            // convertArea();
                          },
                        ),
                        Text(
                          e['Name'].toString(),
                          style: CustomTheme.formFieldStyle,
                        ),
                      ],
                    ],
                  ),
                ),
                // CustomTextFormField(
                //   title: 'Plot Area',
                //   controller: plotAreaCtrl,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [
                //     FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                //   ],
                //   validator: (value) {
                //     final pattern = RegExp(r'^\d{2,5}(\.\d{1,2})?$');
                //     if (value.isEmpty || !pattern.hasMatch(value)) {
                //       return 'Enter a number with 2-5 digits.';
                //     }
                //     return null;
                //   },
                //   onChanged: (value) {
                //     convertArea();
                //   },
                // ),
                CustomTheme.defaultSize,
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: sqftCtrl,
                        title: 'Sq. Ft',
                        readOnly: unitGroupValue != '1',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a number";
                          }
                          if (value.length < 2 || value.length > 5) {
                            return "Enter a number between 2 to 5 digits";
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          if (value.isEmpty) {
                            sqMeterCtrl.text = '';
                            sqYardsCtrl.text = '';
                          }
                          int input = int.parse(value.toString());
                          sqMeterCtrl.text =
                              (input * 0.092903).toStringAsFixed(2);
                          sqYardsCtrl.text =
                              (input * 0.111111).toStringAsFixed(2).toString();
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        controller: sqMeterCtrl,
                        title: 'Sq. Meters',
                        readOnly: unitGroupValue != '3',
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          // Regex to validate 2 to 5 digits with optional 2 decimal places
                          final regex = RegExp(r'^\d{2,5}(\.\d{1,2})?$');
                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid number (2-5 digits, decimal places optional)';
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          if (value.isEmpty) {
                            sqftCtrl.text = '';
                            sqYardsCtrl.text = '';
                          }
                          int input = int.parse(value.toString());
                          sqftCtrl.text = (input * 10.7639).toStringAsFixed(0);
                          sqYardsCtrl.text =
                              (input * 1.19599).toStringAsFixed(2);
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        controller: sqYardsCtrl,
                        title: 'Sq. Yards',
                        readOnly: unitGroupValue != '4',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }
                          // Regex to validate 2 to 5 digits with optional 2 decimal places
                          final regex = RegExp(r'^\d{2,5}(\.\d{1,2})?$');
                          if (!regex.hasMatch(value)) {
                            return 'Please enter a valid number (2-5 digits, decimal places optional)';
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          if (value.isEmpty) {
                            sqftCtrl.text = '';
                            sqMeterCtrl.text = '';
                          }
                          int input = int.parse(value.toString());
                          sqftCtrl.text = (input * 9).toStringAsFixed(0);
                          sqMeterCtrl.text =
                              (input * 0.836127).toStringAsFixed(2);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                CustomTheme.defaultSize,
              ],

              /// * (For Independent Floor & Land + Building)
              /// 	Total Land Area: Text box? (only number) (validation - 2 digit to 5 digit)
              /// 	Property Area: Text box? (only number) (validation - 2 digit to 5 digit)
              if (selectedPropertySubType == '5027' ||
                  selectedPropertySubType == '8942') ...[
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        title: 'Total Land Area',
                        controller: totalLandCtrl,
                        keyboardType: TextInputType.number,
                        required: true,
                        validator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return 'Mandatory Field!';
                          }
                          if (!RegExp(r'^\d{2,5}(\.\d{1,2})?$')
                              .hasMatch(value)) {
                            return "Enter 2-5 digits and up to 2 decimals";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        title: 'Property Area',
                        controller: propertyAreaCtrl,
                        keyboardType: TextInputType.number,
                        required: true,
                        validator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return 'Mandatory Field!';
                          }
                          if (!RegExp(r'^\d{2,5}(\.\d{1,2})?$')
                              .hasMatch(value)) {
                            return "Enter 2-5 digits and up to 2 decimals";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                CustomTheme.defaultSize,
              ],

              /// * Maintenance Level: (Not to open for Plots) (dropdown)
              if (selectedPropertyType != "958") ...[
                CustomSingleDropdown(
                  required: true,
                  dropdownValue: selectedMaintenance,
                  items: itemConvert(maintenanceList),
                  title: 'Maintenance Level',
                  validator: (value) =>
                      value == null ? "Select Maintenance" : null,
                  onChanged: (value) {
                    selectedMaintenance = value.toString();
                    setState(() {});
                  },
                ),
              ],
              SizedBox(height: 25),
              AppButton(
                title: "Save & Next",
                onPressed: () {
                  if (selectedPropertyType == "953") {
                    if (kitchenGroupValue.isEmpty) {
                      alertService.errorToast(
                          'Property has Kitchen or Pantry is mandatory!');
                      return;
                    }
                  }
                  if (selectedPropertyType == "952") {
                    if (cupboardsGroupValue.isEmpty) {
                      alertService.errorToast(
                          'Property has Kitchen & Cupboards existing or not is Mandatory!');
                      return;
                    }
                  }
                  if (addressMatching.isEmpty) {
                    alertService.errorToast('Address Matching is Mandatory!');
                    return;
                  }
                  if (FormManager().propertyForm.currentState!.validate()) {
                    FormManager().propertyForm.currentState!.save();
                    FocusScope.of(context).unfocus();
                    submitForm();
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

  itemArray(List list) {
    return (f, cs) => list.map((e) => e['Name'].toString().trim()).toList();
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

  submitForm() async {
    String bhk = '';
    if (selectedPropertyType == "952" &&
        (selectedPropertySubType != '449' &&
            selectedPropertySubType != '8594')) {
      bhk = selectedBHK.toString();
    } else {
      bhk = bhkCtrl.text.toString();
    }
    List params = [
      addressMatching,
      ageOfPropertyCtrl.text,
      areaOfPropertyCtrl.text,
      bhk,
      selectedCity,
      colonyCtrl.text,
      selectedCondition,
      selectedConstruction,
      developerCtrl.text,
      selectedFloor,
      floorOthersCtrl.text,
      cupboardsGroupValue,
      kitchenGroupValue,
      selectedKitchenType,
      totalLandCtrl.text,
      selectedMaintenance,
      municipalCtrl.text,
      liftCtrl.text,
      staircaseCtrl.text,
      pincodeCtrl.text,
      sqMeterCtrl.text,
      sqftCtrl.text,
      sqYardsCtrl.text,
      unitGroupValue,
      projectCtrl.text,
      propertyAddressCtrl.text,
      propertyAreaCtrl.text,
      selectedPropertySubType,
      selectedPropertyType,
      selectedRegion,
      selectedStructure,
      structureOthersCtrl.text,
      "N",
      widget.propId,
    ];
    List finalParams = [];
    for (var e in params) {
      finalParams.add(CommonFunctions().removeNull(e.toString()));
    }
    var result = await services.update(finalParams);
    if (result == 1) {
      alertService.successToast("Property details saved successfully.");
      widget.buttonClicked();
      if (selectedPropertyType == '952' ||
          selectedPropertyType == '953' ||
          selectedPropertyType == '954') {
        widget.onVisibility(true);
      } else {
        widget.onVisibility(false);
      }
    } else {
      alertService.errorToast("Property details saved failed!");
    }
  }
}
