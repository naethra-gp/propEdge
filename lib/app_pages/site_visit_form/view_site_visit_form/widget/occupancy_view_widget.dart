import 'package:flutter/material.dart';

import '../../../../app_theme/custom_theme.dart';
import 'list_view_widget.dart';

class OccupancyViewWidget extends StatelessWidget {
  final List details;
 final String statusocc;
 final String relaocc;

  const OccupancyViewWidget({
    super.key,
    required this.details,
    required this.statusocc, required this.relaocc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTheme.defaultSize,
        ListViewWidget(
          label: "Status Of Occupancy",
          value: removeNull(statusocc),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Occupied By",
          value: removeNull(details[0]['OccupiedBy'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Relationship Of Occupant With Customer",
          value: removeNull(relaocc),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Occupied Since",
          value: removeNull(details[0]['OccupiedSince'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Person Met At Site",
          value: removeNull(details[0]['PersonMetAtSite'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Person Met At Site Contact No",
          value: removeNull(details[0]['PersonMetAtSiteContNo'].toString()),
        ),
        CustomTheme.defaultHeight10,
      ],
    );
  }

  removeNull(String field) {
    return field == "null" ? "-" : field;
  }
}
