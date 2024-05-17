import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:proequity/app_widgets/app_common/app_bar.dart';

import '../../app_services/sqlite/reimbursement_services.dart';
import '../../app_theme/theme_files/app_color.dart';

class ViewReimbursement extends StatefulWidget {
  final String id;

  const ViewReimbursement({super.key, required this.id});

  @override
  State<ViewReimbursement> createState() => _ViewReimbursementState();
}

class _ViewReimbursementState extends State<ViewReimbursement> {
  ReimbursementServices services = ReimbursementServices();
  List details = [];
  bool noImage = false;
  bool validURL = false;
  @override
  void initState() {
    getDetails(widget.id);
    super.initState();
  }

  getDetails(String id) async {
    details = await services.readById(id);
    validURL = Uri.parse(details[0]['BillPath']).isAbsolute;
    if (details[0]['BillPath'].toString() == "") {
      noImage = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return details.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          )
        : Scaffold(
            appBar: AppBarWidget(
              title: details[0]['BillName'].toString(),
              action: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    CustomTheme.defaultHeight10,
                    if (!validURL && !noImage) ...[
                      Image.file(
                        File(details[0]['BillPath']),
                        height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ],
                    if (validURL && !noImage) ...[
                      Image.network(
                        details[0]['BillPath'],
                        height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ],
                    if (noImage) ...[
                      Image.asset(
                        "assets/images/img_1.png",
                        height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ],
                    const SizedBox(height: 50),
                    const Text(
                      "Reimbursement Details",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTheme.defaultSize,
                    rowDetails(
                      "Bill Name",
                      details[0]['BillName'].toString(),
                    ),
                    CustomTheme.defaultSize,
                    rowDetails(
                      "Nature Of Expense",
                      details[0]['NatureOfExpense'].toString(),
                    ),
                    CustomTheme.defaultSize,
                    rowDetails(
                      "Expense Date",
                      details[0]['ExpenseDate'].toString(),
                    ),
                    CustomTheme.defaultSize,
                    rowDetails(
                      "Number Of Days",
                      details[0]['NoOfDays'].toString(),
                    ),
                    CustomTheme.defaultSize,
                    rowDetails(
                      "Allowance",
                      "Rs. ${details[0]['TravelAllowance'].toString()}",
                    ),
                    CustomTheme.defaultSize,
                    rowDetails(
                      "Total Amount",
                      "Rs. ${details[0]['TotalAmount'].toString()}",
                    ),
                    CustomTheme.defaultSize,
                    rowDetails(
                      "Expense Comment",
                      getEmptyToNil(details[0]['ExpenseComment'].toString()),
                    ),
                    CustomTheme.defaultSize,
                  ],
                ),
              ),
            ),
          );
  }

  Widget rowDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          value,
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        )
      ]),
    );
  }

  getEmptyToNil(String value) {
    return value == "" ? "NIL" : value;
  }
}
