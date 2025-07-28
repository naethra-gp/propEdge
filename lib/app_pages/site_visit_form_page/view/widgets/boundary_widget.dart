import 'package:flutter/material.dart';

import '../../../reimbursement/widget/row_details_widget.dart';

class BoundaryWidget extends StatelessWidget {
  final List bounList;
  const BoundaryWidget({
    super.key,
    required this.bounList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Boundary Details",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(label: "East", value: bounList[0]['East'].toString()),
        SizedBox(height: 10.0),
        RowDetailsWidget(label: "West", value: bounList[0]['West'].toString()),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: "South", value: bounList[0]['South'].toString()),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: "North", value: bounList[0]['North'].toString()),
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
