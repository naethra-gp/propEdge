import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:prop_edge/app_services/local_db/local_services/dropdown_services.dart';

import '../../app_theme/custom_theme.dart';
import '../../app_utils/app/app_bar.dart';
import 'widget/center_heading.dart';
import 'widget/image_widget.dart';
import 'widget/no_image_found_widget.dart';
import 'widget/row_details_widget.dart';

class ViewReimbursementDetails extends StatefulWidget {
  final List id;
  const ViewReimbursementDetails({super.key, required this.id});

  @override
  State<ViewReimbursementDetails> createState() =>
      _ViewReimbursementDetailsState();
}

class _ViewReimbursementDetailsState extends State<ViewReimbursementDetails> {
  // ReimbursementServices services = ReimbursementServices();
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
      details = widget.id;
      validURL = Uri.parse(details[0]['BillPath']).isAbsolute;
      if (details[0]['BillPath'].toString() == "") {
        noImage = true;
      }
    });
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
              if (validURL && !noImage) ...[
                ImageWidget(
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    imageUrl: val['BillPath'].toString(),
                    height: 200,
                    width: double.infinity,
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/image_error.jpg",
                      height: MediaQuery.of(context).size.height * 0.2,
                      fit: BoxFit.cover,
                    ),
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
                value: val['ExpenseComment'].toString(),
              ),
              CustomTheme.defaultSize,
            ],
          ),
        ),
      ),
    );
  }
}
