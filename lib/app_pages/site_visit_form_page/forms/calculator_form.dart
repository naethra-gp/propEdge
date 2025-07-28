import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prop_edge/app_utils/alert_service.dart';

import '../../../app_services/local_db/local_services/calculator_service.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_utils/app/app_button_widget.dart';
import '../widget/calculator_widget/cell_form_feild.dart';

class CalculatorForm extends StatefulWidget {
  final VoidCallback buttonClicked;
  final String propId;
  const CalculatorForm(
      {super.key, required this.buttonClicked, required this.propId});

  @override
  State<CalculatorForm> createState() => _CalculatorFormState();
}

class _CalculatorFormState extends State<CalculatorForm> {
  /// GLOBAL DECLARATION
  List calDetails = [];
  List headerDetails = [];

  /// Column - DATA
  List progressColumn = [];
  List recommendedColumn = [];
  List totalFloorColumn = [];
  List completedFloorColumn = [];
  List progressPerColumn = [];
  List progressPerAsPerPolicyColumn = [];
  List recommendedPerColumn = [];
  List recommendedPerAsPerPolicyColumn = [];

  CalculatorService cService = CalculatorService();
  AlertService alertService = AlertService();
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

  /// CONTROLLER
  List<TextEditingController> progressControllers = [];
  List<TextEditingController> recommendControllers = [];
  List<TextEditingController> totalFloorControllers = [];
  List<TextEditingController> completedFloorControllers = [];
  List<TextEditingController> progressPerControllers = [];
  List<TextEditingController> recommendedPerControllers = [];
  List<TextEditingController> progressPerAsPerPolicyControllers = [];
  List<TextEditingController> recommendedPerAsPerPolicyControllers = [];
  late Colors fillColor;

  @override
  void initState() {
    getCalValue();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in progressControllers) {
      controller.dispose();
    }
    for (var controller in recommendControllers) {
      controller.dispose();
    }
    for (var controller in totalFloorControllers) {
      controller.dispose();
    }
    for (var controller in completedFloorControllers) {
      controller.dispose();
    }
    for (var controller in progressPerControllers) {
      controller.dispose();
    }
    for (var controller in recommendedPerControllers) {
      controller.dispose();
    }
    for (var controller in progressPerAsPerPolicyControllers) {
      controller.dispose();
    }
    for (var controller in recommendedPerAsPerPolicyControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// To Remove Leading Zeros
  String removeLeadingZeros(String input) {
    return input.replaceFirst(RegExp('^0+'), '');
  }

  /// Initial Fetch of Caluculator Details
  getCalValue() async {
    calDetails = await cService.read(widget.propId);
    headerDetails = jsonDecode(calDetails[0]['Heads']);

    // PROGRESS CONTROLLERS
    progressColumn = jsonDecode(calDetails[0]['Progress']);
    for (int i = 0; i < progressColumn.length; i++) {
      progressControllers.add(TextEditingController());
      progressControllers[i].text = progressColumn[i].toString();
    }

    // RECOMMENDED CONTROLLER
    recommendedColumn = jsonDecode(calDetails[0]['Recommended']);
    for (int i = 0; i < recommendedColumn.length; i++) {
      recommendControllers.add(TextEditingController());
      recommendControllers[i].text = recommendedColumn[i].toString();
    }
    // TOTAL FLOOR CONTROLLER
    totalFloorColumn = jsonDecode(calDetails[0]['TotalFloor']);
    for (int i = 0; i < totalFloorColumn.length; i++) {
      totalFloorControllers.add(TextEditingController());
      totalFloorControllers[i].text = totalFloorColumn[i].toString();
    }

    // COMPLETED FLOOR CONTROLLER
    completedFloorColumn = jsonDecode(calDetails[0]['CompletedFloor']);
    for (int i = 0; i < completedFloorColumn.length; i++) {
      completedFloorControllers.add(TextEditingController());
      completedFloorControllers[i].text = completedFloorColumn[i].toString();
    }

    // ProgressPer Controller
    progressPerColumn = jsonDecode(calDetails[0]['ProgressPer']);
    for (int i = 0; i < progressPerColumn.length; i++) {
      progressPerControllers.add(TextEditingController());
      progressPerControllers[i].text = progressPerColumn[i].toString();
    }
    // RecommendedPer Controller
    recommendedPerColumn = jsonDecode(calDetails[0]['RecommendedPer']);
    for (int i = 0; i < recommendedPerColumn.length; i++) {
      recommendedPerControllers.add(TextEditingController());
      recommendedPerControllers[i].text = recommendedPerColumn[i].toString();
    }

    progressPerAsPerPolicyColumn =
        jsonDecode(calDetails[0]['ProgressPerAsPerPolicy']);
    for (int i = 0; i < progressPerAsPerPolicyColumn.length; i++) {
      progressPerAsPerPolicyControllers.add(TextEditingController());
      progressPerAsPerPolicyControllers[i].text =
          progressPerAsPerPolicyColumn[i].toString();
    }

    recommendedPerAsPerPolicyColumn =
        jsonDecode(calDetails[0]['RecommendedPerAsPerPolicy']);
    for (int i = 0; i < recommendedPerAsPerPolicyColumn.length; i++) {
      recommendedPerAsPerPolicyControllers.add(TextEditingController());
      recommendedPerAsPerPolicyControllers[i].text =
          recommendedPerAsPerPolicyColumn[i].toString();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
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
                      /// CALCULATOR TABLE
                      Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        // defaultColumnWidth: const FixedColumnWidth(150.0),
                        children: [
                          // Header values
                          TableRow(
                            children: [
                              for (int i = 0; i < headerRows.length; i++) ...[
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      headerRows[i].toString(),
                                      style: TextStyle(color: Colors.blue),
                                    ),
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
                                    child: CellFormField(
                                      controller: progressControllers[i],
                                      readOnly: true,
                                      fillColor: Colors.grey[200],
                                      onChanged: (value) {
                                        setState(() {
                                          progressColumn[i] =
                                              removeLeadingZeros(value);
                                          progressControllers[i].text =
                                              removeLeadingZeros(value);
                                        });
                                        updateTotalValue("Progress");
                                        calculatePercentage("Progress", i);
                                      },
                                      onFieldSubmitted: (value) {
                                        if (progressColumn[i].toString() ==
                                            "") {
                                          progressColumn[i] = 0;
                                          progressControllers[i].text = "0";
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        }
                                      },
                                      onTapOutside: (value) {
                                        if (progressColumn[i].toString() ==
                                            "") {
                                          progressColumn[i] = 0;
                                          progressControllers[i].text = "0";
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                /// RECOMMENDED COLUMN
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // child: Text(recommendedColumn[i].toString()),
                                    child: CellFormField(
                                      controller: recommendControllers[i],
                                      readOnly: true,
                                      fillColor: Colors.grey[200],
                                      onChanged: (value) {
                                        setState(() {
                                          recommendedColumn[i] =
                                              removeLeadingZeros(value);
                                          recommendControllers[i].text =
                                              removeLeadingZeros(value);
                                        });
                                        updateTotalValue("Recommend");
                                        calculatePercentage("Recommend", i);
                                      },
                                      onFieldSubmitted: (value) {
                                        if (recommendedColumn[i].toString() ==
                                            "") {
                                          recommendedColumn[i] = 0;
                                          recommendControllers[i].text = "0";
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        }
                                      },
                                      onTapOutside: (value) {
                                        if (recommendedColumn[i].toString() ==
                                            "") {
                                          recommendedColumn[i] = 0;
                                          recommendControllers[i].text = "0";
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                /// TOTAL FLOOR COLUMN
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CellFormField(
                                      controller: totalFloorControllers[i],
                                      readOnly:
                                          i == totalFloorControllers.length - 1,
                                      fillColor: Colors.blue[100],
                                      onChanged: (value) {
                                        setState(() {
                                          totalFloorColumn[i] =
                                              removeLeadingZeros(value);
                                          totalFloorControllers[i].text =
                                              removeLeadingZeros(value);
                                        });
                                        updateTotalValue("TotalFloor");
                                        calculatePercentage("Progress", i);
                                        calculatePercentage("Recommend", i);
                                      },
                                      onFieldSubmitted: (value) {
                                        if (totalFloorColumn[i].toString() ==
                                            "") {
                                          totalFloorColumn[i] = 0;
                                          totalFloorControllers[i].text = "0";
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        }
                                      },
                                      onTapOutside: (value) {
                                        if (totalFloorColumn[i].toString() ==
                                            "") {
                                          totalFloorColumn[i] = 0;
                                          totalFloorControllers[i].text = "0";
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                /// COMPLETED FLOOR COLUMN
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CellFormField(
                                      controller: completedFloorControllers[i],
                                      readOnly: i ==
                                          completedFloorControllers.length - 1,
                                      fillColor: Colors.blue[100],
                                      onChanged: (String value) {
                                        setState(() {
                                          completedFloorColumn[i] =
                                              removeLeadingZeros(value);
                                          completedFloorControllers[i].text =
                                              removeLeadingZeros(value);
                                        });
                                        updateTotalValue("CompletedFloor");
                                        calculatePercentage("Progress", i);
                                        calculatePercentage("Recommend", i);
                                      },
                                      onFieldSubmitted: (value) {
                                        if (completedFloorColumn[i]
                                                .toString() ==
                                            "") {
                                          completedFloorColumn[i] = 0;
                                          completedFloorControllers[i].text =
                                              "0";
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        }
                                      },
                                      onTapOutside: (value) {
                                        if (completedFloorColumn[i]
                                                .toString() ==
                                            "") {
                                          completedFloorColumn[i] = 0;
                                          completedFloorControllers[i].text =
                                              "0";
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                /// PROGRESS PER
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // child: Text(progressPerColumn[i].toString()),
                                    child: CellFormField(
                                      controller: progressPerControllers[i],
                                      readOnly: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                ),

                                /// RECOMMENDED PER
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CellFormField(
                                      controller: recommendedPerControllers[i],
                                      readOnly: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                ),

                                /// Progress Per As Per Policy
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CellFormField(
                                      controller:
                                          progressPerAsPerPolicyControllers[i],
                                      readOnly: true,
                                      fillColor: Colors.grey[200],
                                    ),
                                  ),
                                ),

                                /// RECOMMENDED Per As Per Policy
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CellFormField(
                                      controller:
                                          recommendedPerAsPerPolicyControllers[
                                              i],
                                      readOnly: true,
                                      fillColor: Colors.grey[200],
                                    ),
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
            CustomTheme.defaultSize,
            AppButton(
              title: "Save & Next",
              onPressed: () async {
                List<String> request = [];
                request = [
                  progressColumn.toString(),
                  recommendedColumn.toString(),
                  totalFloorColumn.toString(),
                  completedFloorColumn.toString(),
                  progressPerColumn.toString(),
                  recommendedPerColumn.toString(),
                  'N',
                  widget.propId.toString()
                ];
                var result = await cService.update(request);
                if (result == 1) {
                  alertService.successToast("Calculator Saved");
                  widget.buttonClicked();
                } else {
                  alertService.errorToast("Calculator Failure!");
                }
              },
            ),
            CustomTheme.defaultSize,
          ],
        ),
      ),
    );
  }

  updateTotalValue(String colName) {
    List<TextEditingController> controller = [];
    List columnList = [];

    /// CONDITION
    if (colName == "Progress") {
      controller = progressControllers;
      columnList = progressColumn;
    } else if (colName == "Recommend") {
      controller = recommendControllers;
      columnList = recommendedColumn;
    } else if (colName == "TotalFloor") {
      controller = totalFloorControllers;
      columnList = totalFloorColumn;
    } else if (colName == "CompletedFloor") {
      controller = completedFloorControllers;
      columnList = completedFloorColumn;
    }
    // calculateTotal(controller, columnList);

    /// OPERATIONS
    int sum = 0;
    for (int n = 0; n < columnList.length - 1; n++) {
      sum += int.parse(
        columnList[n].toString() == "" ? "0" : columnList[n].toString(),
      );
    }
    controller[controller.length - 1].text = sum.toString();
    columnList[columnList.length - 1] = sum.toString();
    setState(() {});
  }

  calculatePercentage(String column, int i) {
    int cf = int.parse(completedFloorControllers[i].text); // COMPLETED FLOOR
    int tf = int.parse(totalFloorControllers[i].text); // TOTAL FLOOR
    int p = int.parse(progressControllers[i].text); // PROGRESS
    int r = int.parse(recommendControllers[i].text); // RECOMMENDED
    if (column == "Progress") {
      double result = (cf * p) / tf;
      if (result.toString() == "Infinity" || result.toString() == "NaN") {
        result = 0;
      }
      progressPerControllers[i].text = result.toStringAsFixed(2);
      progressPerColumn[i] = result.toStringAsFixed(2);
    } else {
      double result = (cf * r) / tf;
      if (result.toString() == "Infinity" || result.toString() == "NaN") {
        result = 0;
      }
      recommendedPerControllers[i].text = result.toStringAsFixed(2);
      recommendedPerColumn[i] = result.toStringAsFixed(2);
    }
    setState(() {});
    calculateTotal(progressPerControllers, progressPerColumn);
    calculateTotal(recommendedPerControllers, recommendedPerColumn);
  }

  calculateTotal(List<TextEditingController> controller, List columnList) {
    double sum = 0;
    for (int n = 0; n < columnList.length - 1; n++) {
      sum += double.parse(
        columnList[n].toString() == "" ? "0" : columnList[n].toString(),
      );
    }
    controller[controller.length - 1].text = sum.toStringAsFixed(2);
    columnList[columnList.length - 1] = sum.toStringAsFixed(2);
    setState(() {});
  }
}
