import 'package:flutter/material.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/boundary_form.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/critical_comments_form.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/customer_bank_form.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/feedback_form.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/location_detail_form.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/measurement_form.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/occupancy_form.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/property_location_form.dart';
import 'package:proequity/app_pages/site_visit_form/form_widgets/upload_pictures_page.dart';
import '../../app_widgets/index.dart';
import 'form_widgets/state_calculator_widget/new_stage_calculator.dart';

class SiteVisitForm extends StatefulWidget {
  const SiteVisitForm({super.key, this.propId});

  final String? propId;

  @override
  State<SiteVisitForm> createState() => _SiteVisitFormState();
}

class _SiteVisitFormState extends State<SiteVisitForm> {
  late List menuItem = [
    {
      "isSelected": true,
      "item": "Customer",
      "child": CustomerBankForm(
        propId: widget.propId.toString(),
        buttonClicked: () {
          selectionChange("Property");
        },
      ),
    },
    {
      "isSelected": false,
      "item": "Property",
      "child": PropertyLocationForm(
          propId: widget.propId.toString(),
          buttonClicked: () {
            selectionChange("Location");
          }),
    },
    {
      "isSelected": false,
      "item": "Location",
      "child": LocationDetailForm(
          propId: widget.propId.toString(),
          buttonSubmitted: () {
            selectionChange("Occupancy");
          }),
    },
    {
      "isSelected": false,
      "item": "Occupancy",
      "child": OccupancyForm(
          propId: widget.propId.toString(),
          buttonSubmitted: () {
            selectionChange("Feedback");
          }),
    },
    {
      "isSelected": false,
      "item": "Feedback",
      "child": FeedbackForm(
          propId: widget.propId.toString(),
          buttonSubmitted: () {
            selectionChange("Boundary");
          }),
    },
    {
      "isSelected": false,
      "item": "Boundary",
      "child": BoundaryForm(
          propId: widget.propId.toString(),
          buttonSubmitted: () {
            selectionChange("Measurement");
          }),
    },
    {
      "isSelected": false,
      "item": "Measurement",
      "child": MeasurementForm(
          propId: widget.propId.toString(),
          buttonSubmitted: () {
            selectionChange("Calculator");
          }),
    },
    {
      "isSelected": false,
      "item": "Calculator",
      // "child": CalculatorDataTable(
      //     propId: widget.propId.toString(),
      //     buttonSubmitted: () {
      //       selectionChange("Comment");
      //     }),
      "child": StageCalculatorWidget(
          propId: widget.propId.toString(),
          buttonSubmitted: () {
            selectionChange("Comment");
          }),
    },
    {
      "isSelected": false,
      "item": "Comment",
      "child": CriticalComments(
          propId: widget.propId.toString(),
          buttonSubmitted: () {
            selectionChange("Uploads");
          }),
    },
    {
      "isSelected": false,
      "item": "Uploads",
      "child": UploadPictures(
          propId: widget.propId.toString(),
          buttonSubmitted: () {
            selectionChange("Map");
          }),
    },
    // {
    //   "isSelected": false,
    //   "item": "Sketch",
    //   "child": const Text("Work in Process"),
    // },
    // {
    //   "isSelected": false,
    //   "item": "Photographs",
    //   "child": const Text("Work in Process"),
    // },
  ];

  selectionChange(String label) {
    for (var element in menuItem) {
      setState(() {
        if (element['item'] == label) {
          element['isSelected'] = true;
        } else {
          element['isSelected'] = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Site Visit Form",
        action: false,
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              // return alert;
              return AlertDialog(
                title: const Text("Alert"),
                content: const Text("Do you want to exit from this form?"),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'mainPage',
                          arguments: 2);
                    },
                  ),
                  TextButton(
                    child: const Text("Cancel",
                        style: TextStyle(
                          color: Colors.red,
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
          // if (shouldPop ?? false) {
          //   SystemNavigator.pop();
          // }
        },
        child:Material(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Wrap(
                  spacing: 0,
                  children: <Widget>[
                    for (int i = 0; i < menuItem.length; i++)
                      topMenu(context, menuItem[i], i),
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
                indent: 15,
                endIndent: 15,
              ),
              for (int i = 0; i < menuItem.length; i++)
                if (menuItem[i]['isSelected'] == true)
                  Center(
                    child: menuItem[i]['child'],
                  ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),),
    );
  }

  topMenu(context, item, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          for (int j = 0; j < menuItem.length; j++) {
            menuItem[j]['isSelected'] = false;
            if (menuItem[index]['item'] == item['item']) {
              item['isSelected'] = true;
            } else {
              item['isSelected'] = false;
            }
          }
        });
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // <-- Radius
        ),
        backgroundColor: item['isSelected']
            ? Theme.of(context).primaryColor
            : Colors.transparent,
      ),
      child: Text(
        item['item'].toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: item['isSelected']
              ? Colors.white
              : Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
