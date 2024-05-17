import 'package:flutter/material.dart';

import '../../../../app_theme/custom_theme.dart';
import 'list_view_widget.dart';

class LocationViewWidget extends StatelessWidget {
  final List details;
  final String infra;
  final String natureloc;
  final String classloc;

  const LocationViewWidget({
    super.key,
    required this.details, required this.infra, required this.natureloc, required this.classloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTheme.defaultSize,
        ListViewWidget(
          label: "Near by Landmark",
          value: removeNull(details[0]['NearbyLandmark'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Micro Market",
          value: removeNull(details[0]['Micromarket'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Latitude",
          value: removeNull(details[0]['Latitude'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Longitude",
          value: removeNull(details[0]['Longitude'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Infrastructure",
          value: removeNull(infra),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Nature Of Locality",
          value: removeNull(natureloc),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Class Of Locality",
          value: removeNull(classloc),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Civics Amenities",
          value: removeNull(details[0]['ProximityFromCivicsAmenities']
              .toString()
              .split(",")
              .toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Nearest Railway Station",
          value: removeNull(details[0]['NearestRailwayStation'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Nearest Metro Station",
          value: removeNull(details[0]['NearestMetroStation'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Nearest Bus Stop",
          value: removeNull(details[0]['NearestBusStop'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Approach Road",
          value: removeNull(details[0]['ConditionAndWidthOfApproachRoad'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Site Access",
          value: removeNull(details[0]['SiteAccess'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Neighborhood Type",
          value: removeNull(details[0]['NeighborhoodType'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Nearest Hospital",
          value: removeNull(details[0]['NearestHospital'].toString()),
        ),
        CustomTheme.defaultHeight10,
        ListViewWidget(
          label: "Any Negative To The Locality",
          value: removeNull(details[0]['AnyNegativeToTheLocality'].toString()),
        ),
        CustomTheme.defaultHeight10,
      ],
    );
  }

  removeNull(String field) {
    return field == "null" ? "-" : field;
  }
}
