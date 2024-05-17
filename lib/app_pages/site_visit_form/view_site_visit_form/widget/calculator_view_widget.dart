import 'dart:convert';

import 'package:flutter/material.dart';

import '../../form_widgets/state_calculator_widget/CalculatorDataTable.dart';

class CalculatorViewWidget extends StatelessWidget {
  final List details;
  const CalculatorViewWidget({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return datatableList(context);
  }

  Widget datatableList(BuildContext context) {
    num progsum = 0;
    num recomSum = 0;
    num totsum = 0;
    num complsum = 0;
    num progpersum = 0;
    num recompersum = 0;
    List progress = jsonDecode(details[0]['Progress']);
    List recommended = jsonDecode(details[0]['Recommended']);
    List totalFloor = jsonDecode(details[0]['TotalFloor']);
    List completedFloor = jsonDecode(details[0]['CompletedFloor']);
    List progressPer = jsonDecode(details[0]['ProgressPer']);
    List recommendedPer = jsonDecode(details[0]['RecommendedPer']);

    List rowHead = [
      "Plinth",
      "RCC",
      "Brick Work",
      "Internal Plaster",
      "External Plaster",
      "Flooring",
      "Electrification",
      "Wood Work",
      "Finishing",
      "Total"
    ];
    List<DataColumn> columns = <DataColumn>[];
    List<DataRow> rows = <DataRow>[];
    columns.add(
      const DataColumn(
        label: Text(''),
      ),
    );
    columns.add(
      DataColumn(
        label: Text(
          "Progress",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );

    columns.add(
      DataColumn(
        label: Text(
          "Recommended",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
    columns.add(
      DataColumn(
        label: Text(
          "Total Floor",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
    columns.add(
      DataColumn(
        label: Text(
          "Completed Floor",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
    columns.add(
      DataColumn(
        label: Text(
          "Progress %",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
    columns.add(
      DataColumn(
        label: Text(
          "Recommended %",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
    for (int i = 0; i < rowHead.length - 1; i++) {
      List<DataCell> singlecell = <DataCell>[];
      singlecell.add(
        DataCell(
          Text(
            (rowHead[i]).toString(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      );
      singlecell.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  progress[i].toString(),
                ),
              ),
            ),
          ),
        ),
      );
      progsum = progsum + progress[i];
      singlecell.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  recommended[i].toString(),
                ),
              ),
            ),
          ),
        ),
      );
      recomSum = recomSum + recommended[i];
      singlecell.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  totalFloor[i].toString(),
                ),
              ),
            ),
          ),
        ),
      );
      totsum = totsum + totalFloor[i];
      singlecell.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  completedFloor[i].toString(),
                ),
              ),
            ),
          ),
        ),
      );
      complsum = complsum + completedFloor[i];
      singlecell.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  progressPer[i].toString(),
                ),
              ),
            ),
          ),
        ),
      );
      progpersum = progpersum + progressPer[i];
      singlecell.add(
        DataCell(
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 35,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  recommendedPer[i].toString(),
                ),
              ),
            ),
          ),
        ),
      );
      recompersum = recompersum + recommendedPer[i];
      rows.add(
        DataRow(
          cells: singlecell,
        ),
      );
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
              child: Text(progsum.toString()),
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
              child: Text(recomSum.toString()),
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
              child: Text(totsum.toString()),
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
              child: Text(complsum.toString()),
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
              child: Text(removeNan(progpersum.toString())),
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

    Widget objWidget = datatableDynamic(columns: columns, rows: rows);
    return objWidget;
  }
}
