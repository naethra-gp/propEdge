import 'package:flutter/material.dart';

import '../../../../app_theme/custom_theme.dart';
import 'list_view_widget.dart';

class BoundaryViewWidget extends StatelessWidget {
  final List details;

  const BoundaryViewWidget({super.key, required this.details,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTheme.defaultSize,
        ListViewWidget(
          label: "East",
          value: removeNull(details[0]['East'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "West",
          value: removeNull(details[0]['West'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "South",
          value: removeNull(details[0]['South'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "North",
          value: removeNull(details[0]['North'].toString()),
        ),
        CustomTheme.defaultHeight10,
      ],
    );
  }

  removeNull(String field) {
    return field == "null" ? "-" : field;
  }
}
