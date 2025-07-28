import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prop_edge/app_services/local_db/local_services/dropdown_services.dart';

import '../../../app_theme/custom_theme.dart';
import '../../../app_utils/app/app_bar.dart';
import '../widget/center_heading.dart';
import '../widget/image_widget.dart';
import '../widget/no_image_found_widget.dart';
import '../widget/row_details_widget.dart';

class LocalViewDetails extends StatefulWidget {
  final List list;
  const LocalViewDetails({super.key, required this.list});

  @override
  State<LocalViewDetails> createState() => _LocalViewDetailsState();
}

class _LocalViewDetailsState extends State<LocalViewDetails> {
  List details = [];
  bool noImage = false;
  bool validURL = false;
  List expDD = [];
  DropdownServices dropdownServices = DropdownServices();

  @override
  void initState() {
    super.initState();
    getDropdown();
    setState(() {
      details = widget.list;
      debugPrint('---- $details ----');
      validURL = Uri.parse(details[0]['BillPath']).isAbsolute;
      if (details[0]['BillPath'].toString() == "") {
        noImage = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var val = details[0];
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          title: "View Details",
          action: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              CustomTheme.defaultHeight10,
              if (!validURL && !noImage) ...[
                ImageWidget(
                  child: Image.file(
                    File(val['BillPath'].toString()),
                    height: MediaQuery.of(context).size.height * 0.2,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
              if (noImage) ...[
                NoImageFoundWidget(),
              ],
              const SizedBox(height: 25),
              CenterHeading(),
              CustomTheme.defaultSize,
              RowDetailsWidget(
                label: "Bill Name",
                value: val['BillName'].toString().toUpperCase(),
              ),
              CustomTheme.defaultSize,
              RowDetailsWidget(
                label: "Nature Of Expense",
                value: getExpenseName(val['NatureOfExpense'].toString())
                    .toUpperCase(),
              ),
              CustomTheme.defaultSize,
              RowDetailsWidget(
                label: "Expense Date",
                value: val['ExpenseDate'].toString(),
              ),
              CustomTheme.defaultSize,
              RowDetailsWidget(
                label: "Number Of Days",
                value: val['NoOfDays'].toString(),
              ),
              CustomTheme.defaultSize,
              RowDetailsWidget(
                label: "Allowance",
                value: "Rs. ${val['TravelAllowance'].toString()}",
              ),
              CustomTheme.defaultSize,
              RowDetailsWidget(
                label: "Total Amount",
                value: "Rs. ${val['TotalAmount'].toString()}",
              ),
              CustomTheme.defaultSize,
              RowDetailsWidget(
                label: "Expense Comment",
                value: getEmptyToNil(val['ExpenseComment'].toString()),
              ),
              CustomTheme.defaultSize,
            ],
          ),
        ),
      ),
    );
  }

  getEmptyToNil(String value) {
    return value == "" ? "NIL" : value;
  }

  String getExpenseName(String natureOfExpenseId) {
    try {
      var matchedExpense = expDD.firstWhere(
        (expense) => expense['Id'].toString() == natureOfExpenseId,
      );
      return matchedExpense['Name'];
    } catch (e) {
      return '';
    }
  }

  getDropdown() async {
    expDD = await dropdownServices.readByType('NatureOfExpense');
    setState(() {});
  }
}
