import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import '../../../app_services/local_db/local_services/dropdown_services.dart';
import '../../../app_services/local_db/local_services/local_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_utils/alert_service2.dart';
import '../../../app_utils/app/app_button_widget.dart';
import '../../../app_utils/form/custom_single_dropdown.dart';
import '../../../app_utils/form/disabled_focus.dart';
import '../../../app_utils/form/text_form_widget.dart';

class OccupancyForm extends StatefulWidget {
  final VoidCallback buttonClicked;
  final String propId;

  const OccupancyForm({
    super.key,
    required this.buttonClicked,
    required this.propId,
  });

  @override
  State<OccupancyForm> createState() => _OccupancyFormState();
}

class _OccupancyFormState extends State<OccupancyForm> {
  /// GLOBAL DECLARATION
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DropdownServices _dropdownServices = DropdownServices();
  final OccupancyServices _occupancyServices = OccupancyServices();
  final AlertService _alertService = AlertService();

  DateTime _selectedDate = DateTime.now();

  List<Map<String, dynamic>> _occupancyList = [];
  List<Map<String, dynamic>> _relationshipList = [];

  String? _selectedOccupancy;
  String? _selectedRelationship;

  final TextEditingController _occupantNameController = TextEditingController();
  final TextEditingController _occupantContactController =
      TextEditingController();
  final TextEditingController _occupiedSinceController =
      TextEditingController();
  final TextEditingController _personMetNameController =
      TextEditingController();
  final TextEditingController _personMetContactController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchDropdownData();
    await _fetchOccupancyDetails();
  }

  /// Initial Fetch Dropdown Details
  Future<void> _fetchDropdownData() async {
    _occupancyList = await _dropdownServices.readByType('StatusOfOccupancy');
    _relationshipList = await _dropdownServices
        .readByType('RelationshipOfOccupantWithCustomer');
    setState(() {});
  }

  /// Initial Fetch of Occupancy Details
  Future<void> _fetchOccupancyDetails() async {
    final occupancyData = await _occupancyServices.read(widget.propId);
    if (occupancyData.isNotEmpty) {
      final data = occupancyData.first;
      _selectedOccupancy = _convertString(data['StatusOfOccupancy']);
      _selectedRelationship =
          _convertString(data['RelationshipOfOccupantWithCustomer']);
      _occupantNameController.text = _trimText(data['OccupiedBy']);
      _occupantContactController.text = _trimText(data['OccupantContactNo']);
      _occupiedSinceController.text = _trimText(data['OccupiedSince']);
      _personMetNameController.text = _trimText(data['PersonMetAtSite']);
      _personMetContactController.text =
          _trimText(data['PersonMetAtSiteContNo']);
    }
    setState(() {});
  }

  String? _convertString(String text) {
    return (text == '0' || text.isEmpty) ? null : text.trim();
  }

  String _trimText(String text) {
    return text.trim();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 99),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _occupiedSinceController.text = DateFormat('MMM-yyyy').format(picked);
      });
    }
  }

  Future<void> _saveAndNext() async {
    if (_formKey.currentState!.validate()) {
      final request = [
        _trimText(_occupantContactController.text),
        _trimText(_occupantNameController.text),
        _trimText(_occupiedSinceController.text),
        _trimText(_personMetNameController.text),
        _trimText(_personMetContactController.text),
        _trimText(_selectedRelationship!),
        _trimText(_selectedOccupancy!),
        'N',
        widget.propId,
      ];

      final result = await _occupancyServices.update(request);
      if (result == 1) {
        _alertService.successToast("Occupancy details saved successfully.");
        widget.buttonClicked();
      } else {
        _alertService.errorToast("Failed to save occupancy details!");
      }
    }
  }

  @override
  void dispose() {
    _occupantNameController.dispose();
    _occupantContactController.dispose();
    _occupiedSinceController.dispose();
    _personMetNameController.dispose();
    _personMetContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Status of Occupancy - DD
              CustomSingleDropdown(
                title: 'Status of Occupancy',
                required: true,
                items: _occupancyList
                    .map((e) => DropdownMenuItem(
                          value: e['Id'].toString(),
                          child: Text(
                            e['Name'].toString(),
                            style: CustomTheme.formFieldStyle,
                          ),
                        ))
                    .toList(),
                dropdownValue: _selectedOccupancy,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mandatory Field!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedOccupancy = value.toString();
                  });
                },
              ),
              const SizedBox(height: 20),
              // Occupant Details - Fields
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Occupant Details",
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
                          controller: _occupantNameController,
                          required: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z\s]+$')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mandatory Field!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          title: 'Contact No',
                          controller: _occupantContactController,
                          required: true,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mandatory Field!';
                            }
                            if (value.trim().length != 10) {
                              return 'Enter valid number!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Occupied Since - Fields
              CustomTextFormField(
                title: "Occupied Since",
                required: true,
                controller: _occupiedSinceController,
                focusNode: AlwaysDisabledFocusNode(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Mandatory field!";
                  }
                  return null;
                },
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
              // Relationship with Applicant - DD
              CustomSingleDropdown(
                title: 'Relationship with Applicant',
                required: true,
                items: _relationshipList
                    .map((e) => DropdownMenuItem(
                          value: e['Id'].toString(),
                          child: Text(
                            e['Name'].toString(),
                            style: CustomTheme.formFieldStyle,
                          ),
                        ))
                    .toList(),
                dropdownValue: _selectedRelationship,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mandatory Field!';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedRelationship = value.toString();
                  });
                },
              ),
              const SizedBox(height: 20),
              // Person met at Site - Fields
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Person met at Site",
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
                          controller: _personMetNameController,
                          required: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z\s]+$')),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mandatory field!";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          title: 'Contact No',
                          controller: _personMetContactController,
                          required: true,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Mandatory field!";
                            }
                            if (value.trim().length != 10) {
                              return 'Enter valid number!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Save - Occupancy Details
                  AppButton(
                    title: "Save & Next",
                    onPressed: _saveAndNext,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
