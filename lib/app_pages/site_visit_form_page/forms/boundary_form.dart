import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_services/local_db/local_services/local_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_utils/alert_service.dart';
import '../../../app_utils/app/app_button_widget.dart';
import '../../../app_utils/form/text_form_widget.dart';

class BoundaryForm extends StatefulWidget {
  final VoidCallback buttonClicked;
  final String propId;

  const BoundaryForm({
    super.key,
    required this.buttonClicked,
    required this.propId,
  });

  @override
  State<BoundaryForm> createState() => _BoundaryFormState();
}

class _BoundaryFormState extends State<BoundaryForm> {
  /// GLOBAL DECLARATION
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BoundaryServices _boundaryServices = BoundaryServices();
  final AlertService _alertService = AlertService();

  final TextEditingController _eastController = TextEditingController();
  final TextEditingController _westController = TextEditingController();
  final TextEditingController _southController = TextEditingController();
  final TextEditingController _northController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBoundaryDetails();
  }

  /// Initial Fetch of Boundary details
  Future<void> _fetchBoundaryDetails() async {
    final boundaryData = await _boundaryServices.read(widget.propId);
    if (boundaryData.isNotEmpty) {
      final data = boundaryData.first;
      _eastController.text = _trimText(data['East'] ?? '');
      _westController.text = _trimText(data['West'] ?? '');
      _southController.text = _trimText(data['South'] ?? '');
      _northController.text = _trimText(data['North'] ?? '');
    }
    setState(() {});
  }

  String _trimText(String text) {
    return text.trim();
  }

  /// Save Boundary details
  Future<void> _saveAndNext() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();

      /// Request data to Boundary details
      final request = [
        "AsPerSite",
        _trimText(_eastController.text),
        _trimText(_westController.text),
        _trimText(_southController.text),
        _trimText(_northController.text),
        'N',
        widget.propId,
      ];

      final result = await _boundaryServices.update(request);
      if (result == 1) {
        _alertService.successToast("Boundary details saved successfully.");
        widget.buttonClicked();
      } else {
        _alertService.errorToast("Failed to save boundary details!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildBoundaryTextField('East', _eastController),
              CustomTheme.defaultSize,
              _buildBoundaryTextField('West', _westController),
              CustomTheme.defaultSize,
              _buildBoundaryTextField('South', _southController),
              CustomTheme.defaultSize,
              _buildBoundaryTextField('North', _northController),
              CustomTheme.defaultSize,

              /// Save button - Boundary details
              AppButton(
                title: "Save & Next",
                onPressed: _saveAndNext, // save form function
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Boundary Text Field
  Widget _buildBoundaryTextField(
      String title, TextEditingController controller) {
    return CustomTextFormField(
      title: title,
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9\s]+$')),
      ],
    );
  }

  @override
  void dispose() {
    _eastController.dispose();
    _westController.dispose();
    _southController.dispose();
    _northController.dispose();
    super.dispose();
  }
}
