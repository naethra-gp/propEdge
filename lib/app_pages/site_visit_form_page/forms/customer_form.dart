import 'package:flutter/material.dart';
import 'package:prop_edge/app_utils/alert_service.dart';

import '../../../app_config/app_constants.dart';
import '../../../app_services/local_db/local_services/local_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_utils/app/app_button_widget.dart';
import '../../../app_utils/app/common_functions.dart';
import '../../../app_utils/form/text_form_widget.dart';
import 'form_manager/form_manager.dart';

class CustomerForm extends StatefulWidget {
  final VoidCallback buttonClicked;
  final String propId;
  const CustomerForm({
    super.key,
    required this.buttonClicked,
    required this.propId,
  });

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  /// GLOBAL DECLARATION
  CustomerServices cService = CustomerServices();
  AlertService alertService = AlertService();
  List details = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  /// Initial fetch of Customer Details
  getData() async {
    details = await cService.readById(widget.propId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: details.isEmpty
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Form(
                key: FormManager().customerForm,
                child: Column(
                  children: [
                    /// Institute/Bank Name - Field
                    CustomTextFormField(
                      title: 'Institute/Bank Name',
                      enabled: false,
                      readOnly: true,
                      required: true,
                      initialValue: details[0]['BankName'],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Institute/Bank Name is required";
                        }
                        return null;
                      },
                    ),
                    CustomTheme.defaultSize,

                    /// Branch Name - Field
                    CustomTextFormField(
                      title: 'Branch Name',
                      enabled: false,
                      readOnly: true,
                      required: true,
                      initialValue: CommonFunctions()
                          .removeNull(details[0]['BranchName']),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Branch Name is required";
                        }
                        return null;
                      },
                    ),
                    CustomTheme.defaultSize,

                    /// Case/Loan Type - Field
                    CustomTextFormField(
                      title: 'Case/Loan Type',
                      enabled: false,
                      readOnly: true,
                      required: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Case/Loan Type is required";
                        }
                        return null;
                      },
                      initialValue:
                          CommonFunctions().removeNull(details[0]['LoanType']),
                    ),
                    CustomTheme.defaultSize,

                    /// Customer Name - Field
                    CustomTextFormField(
                      title: 'Customer Name',
                      enabled: false,
                      readOnly: true,
                      required: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Customer name is required";
                        }
                        return null;
                      },
                      initialValue: CommonFunctions()
                          .removeNull(details[0]['CustomerName']),
                    ),
                    CustomTheme.defaultSize,

                    /// Customer Contact Number - Field
                    CustomTextFormField(
                      title: 'Customer Contact Number',
                      enabled: false,
                      readOnly: true,
                      required: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Customer Contact Number is required";
                        }
                        return null;
                      },
                      initialValue: CommonFunctions()
                          .removeNull(details[0]['CustomerContactNumber']),
                    ),
                    CustomTheme.defaultSize,

                    /// Contact Person Name - Field
                    CustomTextFormField(
                      title: 'Contact Person Name',
                      enabled: false,
                      required: true,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Contact Person Name is required";
                        }
                        return null;
                      },
                      initialValue: CommonFunctions()
                          .removeNull(details[0]['ContactPersonName']),
                    ),
                    CustomTheme.defaultSize,

                    /// Contact Person Number - Field
                    CustomTextFormField(
                      title: 'Contact Person Number',
                      required: true,
                      enabled: false,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Contact Person Number is required";
                        }
                        return null;
                      },
                      initialValue: CommonFunctions()
                          .removeNull(details[0]['ContactPersonNumber']),
                    ),
                    CustomTheme.defaultSize,

                    /// Property Address - Field
                    CustomTextFormField(
                      title: 'Property Address',
                      enabled: false,
                      required: true,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Property Address is required";
                        }
                        return null;
                      },
                      initialValue: CommonFunctions()
                          .removeNull(details[0]['PropertyAddress']),
                    ),
                    CustomTheme.defaultSize,

                    /// Site Inspection Date - Field
                    CustomTextFormField(
                      title: 'Site Inspection Date',
                      enabled: false,
                      readOnly: true,
                      required: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Site Inspection Date is required";
                        }
                        return null;
                      },
                      initialValue: CommonFunctions()
                          .removeNull(details[0]['SiteInspectionDate']),
                    ),
                    CustomTheme.defaultSize,

                    /// Save button - Customer Details
                    AppButton(title: "Save & Next", onPressed: formSubmit),
                  ],
                ),
              ),
            ),
    );
  }

  void formSubmit() async {
    if (FormManager().customerForm.currentState!.validate()) {
      FormManager().customerForm.currentState!.save();
      PropertyListService service = PropertyListService();
      List request = [Constants.status[1], "N", widget.propId.toString()];
      var result = await service.updateLocalStatus(request);
      if (result == 1) {
        alertService.successToast("Property status updated successfully.");
        widget.buttonClicked();
      } else {
        alertService.errorToast("Property status updated failed!");
      }
    }
  }
}
