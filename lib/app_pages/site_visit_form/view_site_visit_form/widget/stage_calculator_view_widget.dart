import 'dart:convert';

import 'package:flutter/material.dart';

class StageCalculatorViewWidget extends StatelessWidget {
  final List details;

  const StageCalculatorViewWidget({super.key, required this.details});


  Widget tableCell(String value) {
    return Text(value, textAlign: TextAlign.center,);
  }
  @override
  Widget build(BuildContext context) {
    List headerRows = [
      "",
      "Progress",
      "Recommended",
      "Total Floor",
      "Completed Floor",
      "Progress %",
      "Recommended %",
      "Progress Policy",
      "Recommended Policy"
    ];
    List headerDetails = jsonDecode(details[0]['Heads']);
    List progressColumn = jsonDecode(details[0]['Progress']);
    List recommendedColumn = jsonDecode(details[0]['Recommended']);
    List totalFloorColumn = jsonDecode(details[0]['TotalFloor']);
    List completedFloorColumn = jsonDecode(details[0]['CompletedFloor']);
    List progressPerColumn = jsonDecode(details[0]['ProgressPer']);
    List recommendedPerColumn = jsonDecode(details[0]['RecommendedPer']);
    List progressPerAsPerPolicy = jsonDecode(details[0]['ProgressPerAsPerPolicy']);
    List recommendedPerAsPerPolicy = jsonDecode(details[0]['RecommendedPerAsPerPolicy']);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Table(
                      border: TableBorder.all(),
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      defaultVerticalAlignment:
                      TableCellVerticalAlignment.middle,
                      // defaultColumnWidth: const FixedColumnWidth(150.0),
                      children: [
                        TableRow(
                          children: [
                            for (int i = 0; i < headerRows.length; i++) ...[
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(headerRows[i].toString()),
                                ),
                              ),
                            ],
                          ],
                        ),
                        for (int i = 0; i < headerDetails.length; i++) ...[
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(headerDetails[i].toString()),
                                ),
                              ),

                              /// PROGRESS COLUMN
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: tableCell(progressColumn[i].toString()),
                                ),
                              ),

                              /// RECOMMENDED COLUMN
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: tableCell(recommendedColumn[i].toString()),
                                ),
                              ),

                              /// TOTAL FLOOR COLUMN
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: tableCell(totalFloorColumn[i].toString()),
                                ),
                              ),

                              /// COMPLETED FLOOR COLUMN
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: tableCell(completedFloorColumn[i].toString()),
                                ),
                              ),

                              /// PROGRESS PER
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: tableCell(progressPerColumn[i].toString()),
                                ),
                              ),

                              /// RECOMMENDED PER
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: tableCell(recommendedPerColumn[i].toString()),
                                ),
                              ),

                              /// Progress Per As Per Policy
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: tableCell(progressPerAsPerPolicy[i].toString()),
                                ),
                              ),

                              /// RECOMMENDED Per As Per Policy
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: tableCell(recommendedPerAsPerPolicy[i].toString()),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
