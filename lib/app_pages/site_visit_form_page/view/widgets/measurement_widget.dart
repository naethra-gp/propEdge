import 'package:flutter/material.dart';

import '../../../reimbursement/widget/row_details_widget.dart';

class MeasurementViewWidget extends StatelessWidget {
  final List details;
  final String selectedSizeType;
  final String selectedSheetType;
  final List sheetArray;
  const MeasurementViewWidget(
      {super.key,
      required this.details,
      required this.selectedSizeType,
      required this.selectedSheetType,
      required this.sheetArray});

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Measurement Details",
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
          label: "SizeType",
          value: selectedSizeType,
          // value: removeNull(details[0]['SizeType'].toString()),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "SheetType",
          value: selectedSheetType,
          // value: removeNull(details[0]['SheetType'].toString()),
        ),
        Divider(
          indent: 25,
          endIndent: 25,
          color: Colors.grey,
        ),
        // SizedBox(height: 10.0),
        if (sheetArray.isNotEmpty) ...[
          for (int i = 0; i < sheetArray.length; i++) ...[
            SizedBox(height: 10.0),
            RowDetailsWidget(
              label: "Description",
              value: sheetArray[i]['Description'].toString(),
            ),
            SizedBox(height: 10.0),
            RowDetailsWidget(
              label: "Particulars",
              value: sheetArray[i]['Particulars'].toString(),
            ),
            SizedBox(height: 10.0),
            RowDetailsWidget(
                label: "Length",
                value: sheetArray[i]['Length'].toString()),
            SizedBox(height: 10.0),
            RowDetailsWidget(
                label: "Width",
                value: sheetArray[i]['Width'].toString()),
            SizedBox(height: 10.0),
            RowDetailsWidget(
              label: "Total",
              value: sheetArray[i]['Total'].toString(),
            ),
            // SizedBox(height: 10.0),
            Divider(
              indent: 5,
              endIndent: 5,
              color: Colors.grey,
            ),
          ],
        ],
      ],
    );
  }
}
