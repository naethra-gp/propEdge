import 'package:flutter/material.dart';

import '../../../../app_theme/custom_theme.dart';
import 'list_view_widget.dart';

class CustomerViewWidget extends StatelessWidget {
  final List details;
  const CustomerViewWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTheme.defaultSize,
        ListViewWidget(
            label: "Customer Name",
            value: removeNull(details[0]['CustomerName'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Bank Name", value: removeNull(details[0]['BankName'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Loan Type", value: removeNull(details[0]['LoanType'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Contact Person Name",
            value: removeNull(details[0]['ContactPersonName'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Contact Person Number",
            value: removeNull(details[0]['ContactPersonNumber'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Property Address",
            value: removeNull(details[0]['PropertyAddress'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Site Inspection Date",
            value: removeNull(details[0]['SiteInspectionDate'])),
      ],
    );
  }

  removeNull(String field) {
    return field == "null" ? "-" : field;
  }
}
