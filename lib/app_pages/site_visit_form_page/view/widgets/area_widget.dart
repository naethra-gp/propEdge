import 'package:flutter/material.dart';
import 'package:prop_edge/app_pages/reimbursement/widget/row_details_widget.dart';

class AreaWidget extends StatelessWidget {
  const AreaWidget({
    super.key,
    required this.areaList,
    required this.selectedlandUseOfNeighboringArea,
    required this.selectedInfrastructureConditionOfNeighboringAreas,
    required this.selectedRateArea,
    required this.selectedNatureOfLocality,
    required this.selectedClassOfLocality,
    required this.transNameList,
    required this.propertyType,
  });

  final List areaList;
  final String selectedlandUseOfNeighboringArea;
  final String selectedInfrastructureConditionOfNeighboringAreas;
  final String selectedRateArea;
  final String selectedNatureOfLocality;
  final String selectedClassOfLocality;
  final String transNameList;
  final String propertyType;

  @override
  Widget build(BuildContext context) {
    var val = areaList[0];
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Area Details",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(label: 'Latitude', value: val['Latitude'].toString()),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Longitude', value: val['Longitude'].toString()),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Nearby Landmark', value: val['NearbyLandmark'].toString()),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Land-Use Of Neighboring Areas',
            value: selectedlandUseOfNeighboringArea),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Infrastructure Condition Of Neighboring Areas',
            value: selectedInfrastructureConditionOfNeighboringAreas),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Rate the Infrastructure of the Area',
            value: selectedRateArea),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Nature Of Locality', value: selectedNatureOfLocality),
        SizedBox(height: 10.0),
        if (propertyType == '952') ...[
          RowDetailsWidget(
              label: 'Class Of Locality', value: selectedClassOfLocality),
          SizedBox(height: 10.0),
          RowDetailsWidget(
              label: 'Amenities Available', value: val['Amenities'].toString()),
        ],
        SizedBox(height: 10.0),
        RowDetailsWidget(label: 'Public Transport', value: transNameList),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Site Access', value: val['SiteAccess'].toString()),
        SizedBox(height: 10.0),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Width of Approach road',
            value: val['ConditionAndWidthOfApproachRoad'].toString()),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Any Negative To The Locality',
            value: val['AnyNegativeToTheLocality'].toString()),
        Divider(
          indent: 5,
          endIndent: 5,
          color: Colors.grey,
        ),
      ],
    );
  }
}
