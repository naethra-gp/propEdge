import 'package:flutter/material.dart';

import '../../../reimbursement/widget/row_details_widget.dart';

class CustomerWidget extends StatelessWidget {
  final List list;

  const CustomerWidget({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    var val = list[0];
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Customer Bank Details",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Customer Name",
          value: val['CustomerName'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Customer Contact Number",
          value: val['CustomerContactNumber'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Bank Name",
          value: val['BankName'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Branch Name",
          value: val['BranchName'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Contact Person Name",
          value: val['ContactPersonName'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Contact Person Number",
          value: val['ContactPersonNumber'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Loan Type",
          value: val['LoanType'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Property Address",
          value: val['PropertyAddress'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Site Inspection Date",
          value: val['SiteInspectionDate'].toString(),
        ),
        SizedBox(height: 10.0),
        Divider(
          indent: 5,
          endIndent: 5,
          color: Colors.grey,
        ),
      ],
    );
  }
}
