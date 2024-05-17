import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:proequity/app_widgets/alert_widget.dart';
import '../../../../app_services/sqlite/calculator_service.dart';
import '../../../../app_widgets/index.dart';

class CalculatorDataTable extends StatefulWidget {
  final VoidCallback buttonSubmitted;
  final String propId;
  const CalculatorDataTable(
      {super.key, required this.buttonSubmitted, required this.propId});

  @override
  State<CalculatorDataTable> createState() => CalculatorDataTableState();
}

class CalculatorDataTableState extends State<CalculatorDataTable> {
  CalculatorService calculatorService = CalculatorService();
  bool _isDelayed = false;
  num Progsum = 0;
  num recomsum = 0;
  num totalFloorSum = 0;
  num completedFloorSum = 0;
  num progperSum = 0;
  num recompersum = 0;
  List<num> intList = [];
  List<num> intrecList = [];
  List<num> intProgPerList = [];
  List<num> intRecPerList = [];
  List<num> intCompletedFloorList = [], intTotalFloorList = [];
  List calculatorDetails = [];
  String progResu = "";
  List progress = [];
  List recommended = [];
  List totalFloor = [];
  List completedFloor = [];
  List pp = [];
  List rp = [];
  List progressFormValues = [];
  List recommendedFormValues = [];
  List totalFloorFormValues = [];
  List completedFloorFormValues = [];
  List progressPerFormValues = [];
  List recommendedPerFormValues = [];
  List lastTotal = [];
  double calculatedProgressPer = 0, calculatedRecommededPer = 0;
  List rowHead = [
    "Plinth",
    "rcc",
    "brickWork",
    "Internal Plaster",
    "External Plaster",
    "Flooring",
    "Electrification",
    "Woodwork",
    "Finishing",
    "Total"
  ];
  var calculatedValue, calculatedValue1;
  TextEditingController progperController = TextEditingController();
  TextEditingController recommendedController = TextEditingController();
  TextEditingController totController = TextEditingController();
  TextEditingController comCotroller = TextEditingController();
  TextEditingController recomperController = TextEditingController();

  List<TextEditingController> progressControllers = [];
  List<TextEditingController> recommendedControllers = [];
  List<TextEditingController> totControllers = [];
  List<TextEditingController> comControllers = [];
  List<TextEditingController> recomperControllers = [];
  List<TextEditingController> progperControllers = [];

  @override
  void initState() {
    getCalculatorRecords();
    recommendedController.addListener(getListener);
    super.initState();
  }

  getCalculatorRecords() async {
    AlertService().showLoading("Please wait...");
    calculatorDetails = await calculatorService.read(widget.propId);
    Future.delayed(const Duration(seconds: 0), () async {
      calculatorDetails = await calculatorService.read(widget.propId);
      progress = jsonDecode(calculatorDetails[0]['Progress']);
      recommended = jsonDecode(calculatorDetails[0]['Recommended']);
      totalFloor = jsonDecode(calculatorDetails[0]['TotalFloor']);
      completedFloor = jsonDecode(calculatorDetails[0]['CompletedFloor']);
      pp = jsonDecode(calculatorDetails[0]['ProgressPer']);
      rp = jsonDecode(calculatorDetails[0]['RecommendedPer']);
      _isDelayed = true;
      setState(() {});
      getListener();
    });
  }

  Future getListener() async {
    for (int i = 0; i < progress.length; i++) {
      TextEditingController progController =
          TextEditingController(text: progress[i].toString());
      progressControllers.add(progController);
      TextEditingController recController =
          TextEditingController(text: recommended[i].toString());
      recommendedControllers.add(recController);
      TextEditingController totController =
          TextEditingController(text: totalFloor[i].toString());
      totControllers.add(totController);
      TextEditingController complController =
          TextEditingController(text: completedFloor[i].toString());
      comControllers.add(complController);
      TextEditingController progperController =
          TextEditingController(text: removeNan(pp[i].toString()));
      progperControllers.add(progperController);
      TextEditingController recomperController =
          TextEditingController(text: removeNan(rp[i].toString()));
      recomperControllers.add(recomperController);
    }
    AlertService().hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isDelayed
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Datatablelist(progress, recommended, totalFloor,
                      completedFloor, pp, rp),
                  AppButton(
                      title: "Save & Next",
                      onPressed: () async {
                        List<String> request = [];
                        request = [
                          progress.toString(),
                          recommended.toString(),
                          totalFloor.toString(),
                          completedFloor.toString(),
                          pp.toString(),
                          rp.toString(),
                          'N',
                          widget.propId.toString()
                        ];
                        var result = await calculatorService.update(request);
                        if (result == 1) {
                          AlertService().successToast("Calculator Saved");
                          widget.buttonSubmitted();
                        } else {
                          AlertService().errorToast("Calculator Failure!");
                        }
                      }),
                  CustomTheme.defaultSize,
                ],
              ),
            )
          : const Text("Loading..."),
    );
  }

  List<num>? convertDynamicToInt(List<dynamic> values) {
    if (values != []) {
      List<num>? l = values.map((value) {
        if (value is int) {
          return value;
        } else if (value is double) {
          return value;
        } else if (value is String && value != "NaN" && value != "Infinity") {
          double k = double.parse(double.parse(value).toStringAsFixed(2));
          return k.toInt();
        } else if (value == "NaN" || value == "Infinity") {
          return 0;
        } else {
          return 0;
        }
      }).toList();
      return l;
    }
  }

  Widget Datatablelist(
      List<dynamic> progress,
      List<dynamic> recommended,
      List<dynamic> tot,
      List<dynamic> com,
      List<dynamic> pp,
      List<dynamic> rp) {
    intList = convertDynamicToInt(progress)!;
    intrecList = convertDynamicToInt(recommended)!;
    intTotalFloorList = convertDynamicToInt(totalFloor)!;
    intCompletedFloorList = convertDynamicToInt(completedFloor)!;
    intProgPerList = convertDynamicToInt(pp)!;
    intRecPerList = convertDynamicToInt(rp)!;
    Progsum = 0;
    recomsum = 0;
    progperSum = 0;
    recompersum = 0;
    totalFloorSum = 0;
    completedFloorSum = 0;

    for (int i = 0; i < intList.length - 1; i++) {
      Progsum += intList[i];
    }

    for (int i = 0; i < intrecList.length - 1; i++) {
      recomsum += intrecList[i];
    }
    for (int i = 0; i < intProgPerList.length - 1; i++) {
      progperSum += intProgPerList[i];
    }
    progperSum = double.parse(progperSum.toStringAsFixed(2));

    for (int i = 0; i < intRecPerList.length - 1; i++) {
      recompersum += intRecPerList[i];
    }
    recompersum = double.parse(recompersum.toStringAsFixed(2));

    for (int i = 0; i < intTotalFloorList.length - 1; i++) {
      totalFloorSum += intTotalFloorList[i];
    }
    for (int i = 0; i < intCompletedFloorList.length - 1; i++) {
      completedFloorSum += intCompletedFloorList[i];
    }
    completedFloorSum = double.parse(completedFloorSum.toStringAsFixed(2));


    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(const DataColumn(
      label: Text(""),
    ));
    columns.add(const DataColumn(
      label: Text("Progress"),
    ));
    columns.add(const DataColumn(
      label: Text("Recommended"),
    ));
    columns.add(const DataColumn(
      label: Text("Total Floor"),
    ));
    columns.add(const DataColumn(
      label: Text("completed Floor"),
    ));
    columns.add(const DataColumn(
      label: Text("Progress Per"),
    ));
    columns.add(const DataColumn(
      label: Text("Recommended Per"),
    ));

    for (int i = 0; i < progress.length - 1; i++) {
      /*TextEditingController progressController = TextEditingController(
          text: progress[i].toString());
       recommendedController = TextEditingController(
          text: recommended[i].toString());
       totController = TextEditingController(
          text: tot[i].toString());
       comCotroller = TextEditingController(
          text: com[i].toString());
      progperController = TextEditingController(
          text: removeNan(pp[i]).toString());
       recomperController = TextEditingController(
          text: removeNan(rp[i]).toString());*/

      List<DataCell> cells = [];
      cells.add(
        DataCell(
          Text(rowHead[i]),
        ),
      ); // Assuming rowHead has the appropriate row headings
      cells.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                maxLength: 3,
                decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  counterText: "",
                ),
                enableInteractiveSelection: false,
                controller: progressControllers[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (val) {
                  setState(
                    () {
                      if (val == "") {
                        val = "0";
                      }
                      progress[i] = int.parse(val);
                      intList = convertDynamicToInt(progress)!;
                      for (int i = 0; i < intList.length - 1; i++) {
                        Progsum += intList[i];
                      }

                      if (totControllers[i].text != "" &&
                          progressControllers[i].text != "") {
                        calculatedProgressPer =
                            (double.parse(comControllers[i].text) /
                                    double.parse(totControllers[i].text)) *
                                double.parse(progressControllers[i].text);
                        print("calculatedProgressPer -> $calculatedProgressPer");
                        // calculatedProgressPer = double.parse(double.parse(calculatedProgressPer.toStringAsFixed(2)));
                        if (calculatedProgressPer.toString() == "NaN" ||
                            calculatedProgressPer.toString() == "Infinity") {
                          calculatedProgressPer = 0;
                        }

                        progperControllers[i].text =
                            calculatedProgressPer.toString();
                        pp[i] = removeNan(calculatedProgressPer.toString());
                        intProgPerList = convertDynamicToInt(pp)!;
                        for (int j = 0; j < intProgPerList.length - 1; j++) {
                          progperSum += intProgPerList[j];
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      cells.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                maxLength: 3,
                decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  counterText: "",
                ),
                enableInteractiveSelection: false,
                controller: recommendedControllers[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (val) {
                  setState(
                    () {
                      if (val == "") {
                        // val = "0";
                      }
                      recommendedControllers[i].text = val;
                      recommended[i] = int.parse(val);
                      intrecList = convertDynamicToInt(progress)!;
                      for (int i = 0; i < intrecList.length - 1; i++) {
                        recomsum += intrecList[i];
                      }
                      if (totControllers[i].text != "" &&
                          recommendedControllers[i].text != "") {
                        calculatedRecommededPer =
                            (double.parse(comControllers[i].text) /
                                    double.parse(totControllers[i].text)) *
                                double.parse(recommendedControllers[i].text);
                        if (calculatedRecommededPer.toString() == "NaN" ||
                            calculatedRecommededPer.toString() == "Infinity") {
                          calculatedRecommededPer = 0;
                        }
                        recomperControllers[i].text =
                            calculatedRecommededPer.toString();
                        removeNan(recomperControllers[i].text);
                        rp[i] = removeNan(calculatedRecommededPer.toString());
                      }
                      intRecPerList = convertDynamicToInt(rp)!;
                      for (int j = 0; j < intRecPerList.length - 1; j++) {
                        recompersum += intRecPerList[j];
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
      cells.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                maxLength: 3,
                decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  counterText: "",
                ),
                enableInteractiveSelection: false,
                controller: totControllers[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (val) {
                  if (val == "") {
                    val = "0";
                  }
                  if (comControllers[i].text != "" &&
                      totControllers[i].text != "") {
                    setState(
                      () {
                        totController.text = val;
                        tot[i] = val;
                        if (totControllers[i].text != "" &&
                            progressControllers[i].text != "") {
                          print("kk${double.parse(comControllers[i].text)}");
                          print(double.parse(totControllers[i].text));
                          print(double.parse(progressControllers[i].text));
                          calculatedProgressPer =
                              (double.parse(comControllers[i].text) /
                                      double.parse(totControllers[i].text)) *
                                  double.parse(progressControllers[i].text);
                          if (calculatedProgressPer.toString() == "NaN" ||
                              calculatedProgressPer.toString() == "Infinity") {
                            calculatedProgressPer = 0;
                          }
                          progperControllers[i].text =
                              calculatedProgressPer.toString();
                          pp[i] = removeNan(calculatedProgressPer.toString());
                          print("calculatedValue$calculatedProgressPer");
                        }

                        if (totControllers[i].text != "" &&
                            recommendedControllers[i].text != "") {
                          print("kk${double.parse(comControllers[i].text)}");
                          print(double.parse(totControllers[i].text));
                          print(double.parse(recommendedControllers[i].text));
                          calculatedRecommededPer =
                              (double.parse(comControllers[i].text) /
                                      double.parse(totControllers[i].text)) *
                                  double.parse(recommendedControllers[i].text);
                          if (calculatedRecommededPer.toString() == "NaN" ||
                              calculatedRecommededPer.toString() ==
                                  "Infinity") {
                            calculatedRecommededPer = 0;
                          }
                          recomperControllers[i].text =
                              calculatedRecommededPer.toString();
                          rp[i] = removeNan(calculatedRecommededPer.toString());
                          print("calculatedValue__ recomPer$calculatedRecommededPer");
                        }

                        intTotalFloorList = convertDynamicToInt(tot)!;
                        print(
                            "intTotalFloorList$intTotalFloorList");
                        for (int j = 0; j < intTotalFloorList.length - 1; j++) {
                          totalFloorSum += intTotalFloorList[j];
                        }

                        intProgPerList = convertDynamicToInt(pp)!;
                        print("intProgPerList$intProgPerList");
                        for (int j = 0; j < intProgPerList.length - 1; j++) {
                          progperSum += intProgPerList[j];
                        }
                        intRecPerList = convertDynamicToInt(rp)!;
                        print("intRecPerList$intRecPerList");
                        for (int j = 0; j < intRecPerList.length - 1; j++) {
                          recompersum += intRecPerList[j];
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      );
      cells.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                inputFormatters: [
                  // FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                maxLength: 3,
                decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  counterText: "",
                ),
                enableInteractiveSelection: false,
                controller: comControllers[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (val) {
                  if (val == "") {
                    val = "0";
                  }

                  //   comCotroller.text=val;
                  if (comControllers[i].text != "" &&
                      totControllers[i].text != "") {
                    setState(
                      () {
                        comControllers[i].text = val;
                        com[i] = val;

                        intCompletedFloorList = convertDynamicToInt(com)!;
                        print("intCompletedFloorList$intCompletedFloorList");
                        for (int j = 0;
                            j < intCompletedFloorList.length - 1;
                            j++) {
                          completedFloorSum += intCompletedFloorList[j];
                        }

                        if (comControllers[i].text != "" &&
                            progressControllers[i].text != "") {
                          print("kk${double.parse(comControllers[i].text)}");
                          print(double.parse(totControllers[i].text));
                          print(double.parse(progressControllers[i].text));
                          calculatedProgressPer =
                              (double.parse(comControllers[i].text) /
                                      double.parse(totControllers[i].text)) *
                                  double.parse(progressControllers[i].text);
                          if (calculatedProgressPer.toString() == "NaN" ||
                              calculatedProgressPer.toString() == "Infinity") {
                            calculatedProgressPer = 0;
                          }
                          progperControllers[i].text =
                              calculatedProgressPer.toString();
                          pp[i] = removeNan(calculatedProgressPer.toString());
                          print("calculatedValue__pp${pp[i]}");
                        }

                        if (comControllers[i].text != "" &&
                            recommendedControllers[i].text != "") {
                          print("kk${double.parse(comControllers[i].text)}");
                          print(double.parse(totControllers[i].text));
                          print(double.parse(recommendedControllers[i].text));
                          calculatedRecommededPer =
                              (double.parse(comControllers[i].text) /
                                      double.parse(totControllers[i].text)) *
                                  double.parse(recommendedControllers[i].text);
                          if (calculatedRecommededPer.toString() == "NaN" ||
                              calculatedRecommededPer.toString() ==
                                  "Infinity") {
                            calculatedRecommededPer = 0;
                          }
                          recomperControllers[i].text =
                              calculatedRecommededPer.toString();
                          rp[i] = removeNan(calculatedRecommededPer.toString());
                          print("calculatedValue__ recomPer$calculatedRecommededPer");
                        }

                        intProgPerList = convertDynamicToInt(pp)!;
                        print("intProgPerList$intProgPerList");
                        for (int j = 0; j < intProgPerList.length - 1; j++) {
                          progperSum += intProgPerList[j];

                          intRecPerList = convertDynamicToInt(rp)!;
                          print("intRecPerList$intRecPerList");
                          for (int j = 0; j < intRecPerList.length - 1; j++) {
                            recompersum += intRecPerList[j];
                          }
                        }
                      },
                    );
                  }

                  // Handle submitted value
                },
              ),
            ),
          ),
        ),
      );
      cells.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  counterText: "",
                ),
                // maxLength: 3,
                inputFormatters: [
                  // FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                enableInteractiveSelection: false,
                controller: progperControllers[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autocorrect: false,
                readOnly: true,
                enableSuggestions: false,
                onChanged: (val) {
                  setState(
                    () {
                      progperControllers[i].text = val;
                      pp[i] = int.parse(val);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
      cells.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                // maxLength: 2,
                enableInteractiveSelection: false,
                controller: recomperControllers[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                autocorrect: false,
                readOnly: true,
                enableSuggestions: false,
                onChanged: (val) {
                  setState(
                    () {
                      recomperControllers[i].text = val;
                      rp[i] = int.parse(val);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      rows.add(DataRow(cells: cells));
    }

    List<DataCell> totalCells = [];
    totalCells.add(const DataCell(Text("Total")));
    totalCells.add(
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 35,
            width: 65,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(Progsum.toString()),
            ),
          ),
        ),
      ),
    );
    totalCells.add(
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 35,
            width: 65,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(recomsum.toString()),
            ),
          ),
        ),
      ),
    );
    totalCells.add(
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 35,
            width: 65,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(totalFloorSum.toString()),
            ),
          ),
        ),
      ),
    );
    totalCells.add(
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 35,
            width: 65,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(completedFloorSum.toString()),
            ),
          ),
        ),
      ),
    );
    totalCells.add(
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 35,
            width: 65,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(removeNan(progperSum.toString())),
            ),
          ),
        ),
      ),
    );
    totalCells.add(
      DataCell(
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 35,
            width: 65,
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(recompersum.toString()),
            ),
          ),
        ),
      ),
    );
    rows.add(DataRow(cells: totalCells));

    return datatableDynamic(columns: columns, rows: rows);
  }
}

Widget datatableDynamic({List<DataColumn>? columns, List<DataRow>? rows}) {
  Widget objWidget = Container(
    color: Colors.white,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns!,
          rows: rows!,
          horizontalMargin: 15,
          columnSpacing: 15,
        ),
      ),
    ),
  );
  return objWidget;
}

removeNan(value) {
  if (value.toString() == "NaN" || value == "Infinity") {
    return 0;
  } else {
    return value.toString();
  }
}
