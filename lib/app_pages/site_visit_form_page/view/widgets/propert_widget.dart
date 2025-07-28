import 'package:flutter/material.dart';
import '../../../reimbursement/widget/row_details_widget.dart';

class PropertyWidget extends StatelessWidget {
  final List list;
  final List others;
  const PropertyWidget({super.key, required this.list, required this.others});

  @override
  Widget build(BuildContext context) {
    var val = list[0];
    // var other = others[0];
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Property Details",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10.0),
        if (others.isNotEmpty) ...[
          RowDetailsWidget(
            label: "Region",
            value: others[0]['Region'].toString(),
          ),
          SizedBox(height: 10.0),
          RowDetailsWidget(
            label: "City",
            value: others[0]['City'].toString(),
            // value: others[0]['conditionOfProperty'].toString(),
          ),
          SizedBox(height: 10.0),
        ],
        RowDetailsWidget(
          label: "Colony",
          value: val['Colony'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Address Matching",
          value: val['AddressMatching'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Property Address",
          value: val['PropertyAddressAsPerSite'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Pincode",
          value: val['Pincode'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Name Of Municipal",
          value: val['NameOfMunicipalBody'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Property Type",
          value: others[0]['PropertyType'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Property Sub Type",
          value: others[0]['PropertySubType'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Project Name",
          value: val['ProjectName'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Developer Name",
          value: val['DeveloperName'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "BHK Configuration",
          value: others[0]['BHKConfiguration'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Structure",
          value: others[0]['Structure'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Structure Others",
          value: val['StructureOthers'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Floor",
          value: others[0]['Floor'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Floor Others",
          value: val['FloorOthers'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Kitchen & Cupboards",
          value: val['KitchenAndCupboardsExisting'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Kitchen/Pantry",
          value: val['KitchenOrPantry'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Kitchen Type",
          value: others[0]['KitchenType'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "No Of Lifts",
          value: val['NoOfLifts']?.toString() ?? '0',
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "No Of Staircases",
          value: val['NoOfStaircases']?.toString() ?? '0',
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Construction Old/New",
          value: others[0]['ConstructionOldOrNew'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Age Of Property",
          value: val['AgeOfProperty'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Condition Of Property",
          value: others[0]['ConditionOfProperty'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Area Of Property",
          value: val['AreaOfProperty'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Unit Type",
          value: others[0]['PlotUnitType'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Area Mtrs",
          value: val['PlotAreaMtrs'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Area Sqft",
          value: val['PlotAreaSqft'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Area Yards",
          value: val['PlotAreaYards'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Land Area",
          value: val['LandArea'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Property Area",
          value: val['PropertyArea'].toString(),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
          label: "Maintainance Level",
          value: others[0]['MaintainanceLevel'].toString(),
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
