import 'package:flutter/material.dart';

class FormManager {
  static final FormManager _instance = FormManager._internal();
  factory FormManager() => _instance;
  FormManager._internal(); // Singleton pattern

  final GlobalKey<FormState> customerForm = GlobalKey<FormState>();
  final GlobalKey<FormState> propertyForm = GlobalKey<FormState>();
  final GlobalKey<FormState> areaForm = GlobalKey<FormState>();
  final GlobalKey<FormState> occupancyForm = GlobalKey<FormState>();
  final GlobalKey<FormState> boundaryForm = GlobalKey<FormState>();
  final GlobalKey<FormState> measurementForm = GlobalKey<FormState>();
  final GlobalKey<FormState> calculatorForm = GlobalKey<FormState>();
  final GlobalKey<FormState> commentsForm = GlobalKey<FormState>();
  final GlobalKey<FormState> uploadsForm = GlobalKey<FormState>();

  /// Validate all forms and return invalid forms
  List<String> validateAllForms() {
    Map<String, GlobalKey<FormState>> forms = {
      "Customer Form": customerForm,
      "Property Form": propertyForm,
      "Area Form": areaForm,
      "Occupancy Form": occupancyForm,
      "Boundary Form": boundaryForm,
      "Measurement Form": measurementForm,
      "Calculator Form": calculatorForm,
      "Comments Form": commentsForm,
      "Uploads Form": uploadsForm,
    };

    List<String> invalidForms = [];

    forms.forEach((formName, formKey) {
      bool isValid = formKey.currentState?.validate() ?? false;

      if (!isValid) {
        invalidForms.add(formName);
      } else {
        formKey.currentState!.save(); // Save state if valid
      }
    });

    return invalidForms;
  }
}
