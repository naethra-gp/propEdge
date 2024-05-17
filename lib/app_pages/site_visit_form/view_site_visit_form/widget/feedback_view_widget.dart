import 'package:flutter/material.dart';

import '../../../../app_theme/custom_theme.dart';
import 'list_view_widget.dart';

class FeedbackViewWidget extends StatelessWidget {
  final List details;

  const FeedbackViewWidget({super.key, required this.details,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTheme.defaultSize,
        ListViewWidget(
          label: "Amenities",
          value: removeNull(details[0]['Amenities'].toString().split(",").toString(),),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Maintenance Level",
          value: removeNull(details[0]['MaintainanceLevel'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Approx Age Of Property",
          value: removeNull(details[0]['ApproxAgeOfProperty'].toString()),
        ),
        CustomTheme.defaultHeight10,
      ],
    );
  }

  removeNull(String field) {
    return field == "null" ? "-" : field;
  }
}
