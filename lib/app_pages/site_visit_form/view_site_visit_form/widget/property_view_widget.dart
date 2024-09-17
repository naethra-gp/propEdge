import 'package:flutter/material.dart';

import '../../../../app_theme/custom_theme.dart';
import 'list_view_widget.dart';

class PropertyViewWidget extends StatelessWidget {
  final List details;
  final String city;
  final String propertyType;

  const PropertyViewWidget({
    super.key,
    required this.details,
    required this.city,
    required this.propertyType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTheme.defaultSize,
        ListViewWidget(label: "City", value: removeNull(city)),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Colony", value: removeNull(details[0]['Colony'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Property Address As Per Site",
            value: removeNull(details[0]['PropertyAddressAsPerSite'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Address Matching",
            value: removeNull(details[0]['AddressMatching'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Local Municipal Body",
            value: removeNull(details[0]['LocalMuniciapalBody'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Name Of Municipal Body",
            value: removeNull(details[0]['NameOfMunicipalBody'])),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Property Type",
            value: removeNull(propertyType.toString())),
        CustomTheme.defaultHeight10,
        ListViewWidget(
            label: "Total Floors",
            value: removeNull(details[0]['TotalFloors'])),
        CustomTheme.defaultHeight10,
      ],
    );
  }

  removeNull(String field) {
    return field == "null" ? "-" : field;
  }
}
