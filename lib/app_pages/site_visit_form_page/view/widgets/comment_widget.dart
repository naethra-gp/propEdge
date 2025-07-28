import 'package:flutter/material.dart';

import '../../../reimbursement/widget/row_details_widget.dart';

class CommentsWidget extends StatelessWidget {
  final List commList;
  const CommentsWidget({
    super.key,
    required this.commList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Comments Details",
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
          label: 'Comments Details',
          value: commList[0]['Comment'].toString(),
        ),
        SizedBox(height: 10.0),
        Divider(indent: 5, endIndent: 5, color: Colors.grey),
      ],
    );
  }
}
