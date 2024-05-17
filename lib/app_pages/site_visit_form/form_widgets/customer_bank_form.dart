import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proequity/app_services/sqlite/sqlite_services.dart';

import '../../../app_config/app_constants.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_widgets/alert_widget.dart';
import '../../../app_widgets/index.dart';

class CustomerBankForm extends StatefulWidget {
  const CustomerBankForm(
      {super.key, required this.buttonClicked, required this.propId});

  final VoidCallback buttonClicked;
  final String propId;

  @override
  State<CustomerBankForm> createState() => _CustomerBankFormState();
}

class _CustomerBankFormState extends State<CustomerBankForm> {
  CustomerService customerService = CustomerService();
  List customerDetails = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      getCustomerDetails(widget.propId);
    });
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: customerDetails.isNotEmpty
              ? [
                  CustomTextFormField(
                    title: 'Customer Name',
                    enabled: false,
                    readOnly: true,
                    initialValue:
                        removeNullValue(customerDetails[0]['CustomerName']),
                  ),
                  CustomTheme.defaultSize,
                  CustomTextFormField(
                    title: 'Institute/Bank Name',
                    enabled: false,
                    readOnly: true,
                    initialValue:
                        removeNullValue(customerDetails[0]['BankName']),
                  ),
                  CustomTheme.defaultSize,
                  CustomTextFormField(
                    title: 'Case/Loan Type',
                    enabled: false,
                    readOnly: true,
                    initialValue:
                        removeNullValue(customerDetails[0]['LoanType']),
                  ),
                  CustomTheme.defaultSize,
                  CustomTextFormField(
                    title: 'Contact Person Name',
                    enabled: false,
                    readOnly: true,
                    initialValue: removeNullValue(
                        customerDetails[0]['ContactPersonName']),
                  ),
                  CustomTheme.defaultSize,
                  CustomTextFormField(
                    title: 'Contact Person Number',
                    enabled: false,
                    readOnly: true,
                    initialValue: removeNullValue(
                        customerDetails[0]['ContactPersonNumber']),
                  ),
                  CustomTheme.defaultSize,
                  CustomTextFormField(
                    title: 'Site Inspection Date',
                    enabled: false,
                    readOnly: true,
                    initialValue: removeNullValue(
                        customerDetails[0]['SiteInspectionDate']),
                  ),
                  CustomTheme.defaultSize,
                  CustomTextFormField(
                    title: 'Property Address',
                    enabled: false,
                    readOnly: true,
                    initialValue:
                        removeNullValue(customerDetails[0]['PropertyAddress']),
                  ),
                  CustomTheme.defaultSize,
                  AppButton(
                    title: "Save & Next",
                    onPressed: () async {
                      PropertyListServices service = PropertyListServices();
                      List request = [
                        Constants.status[1],
                        "N",
                        widget.propId.toString()
                      ];
                      var result = await service.updateLocalStatus(request);
                      if (result == 1) {
                        AlertService().successToast("Status Updated");
                        widget.buttonClicked();
                      } else {
                        AlertService().errorToast("Status update Failure!");
                      }
                    },
                  )
                ]
              : [],
        ),
      ),
    );
  }

  getCustomerDetails(String propId) async {
    List property = await customerService.read();
    if (property.isNotEmpty) {
      customerDetails = property
          .where((element) => element['PropId'] == propId.toString())
          .toList();
      setState(() {});
    } else {
      AlertService().errorToast("No data found! Sync again...");
      Navigator.pushReplacementNamed(context, "mainPage", arguments: 2);
      return false;
    }
  }

  removeNullValue(value) {
    if (value.toString() == "null") {
      return "";
    } else {
      return value.toString();
    }
  }
}
