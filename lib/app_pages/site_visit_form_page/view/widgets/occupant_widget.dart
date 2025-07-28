import 'package:flutter/material.dart';

import '../../../reimbursement/widget/row_details_widget.dart';

class OccupantWidget extends StatelessWidget {
  final List occList;
  final String selectStateOfOcc;
  final String selectRelationShipApp;
  const OccupantWidget(
      {super.key,
      required this.occList,
      required this.selectStateOfOcc,
      required this.selectRelationShipApp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Occupancy Details",
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
            label: 'Status of Occupancy',
            value: selectStateOfOcc.toUpperCase()),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Occupancy Details:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 5),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Name',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          getEmptyToNil(occList[0]['OccupiedBy']
                              .toString()
                              .toUpperCase()), // Example Name
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Contact No',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          getEmptyToNil(occList[0]['OccupantContactNo']
                              .toString()
                              .toUpperCase()), // Example Contact No.
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Occupied Since', value: occList[0]['OccupiedSince']),
        SizedBox(height: 10.0),
        RowDetailsWidget(
            label: 'Relationship with Applicant',
            value: selectRelationShipApp.toUpperCase()),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Person met at site :',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 5),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Name',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          getEmptyToNil(occList[0]['PersonMetAtSite']
                              .toString()
                              .toUpperCase()), // Example Name
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Contact No',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          getEmptyToNil(occList[0]['PersonMetAtSiteContNo']
                              .toString()
                              .toUpperCase()), // Example Contact No.
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Divider(
                    indent: 5,
                    endIndent: 5,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  getEmptyToNil(String value) {
    return value == "" ? "-" : value;
  }
}
