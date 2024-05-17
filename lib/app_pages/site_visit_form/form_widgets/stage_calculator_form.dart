import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import 'package:proequity/app_theme/theme_files/app_color.dart';
import 'package:proequity/app_widgets/alert_widget.dart';
import '../../../app_services/sqlite/calculator_service.dart';
import '../../../app_widgets/index.dart';
import 'state_calculator_widget/calculated_progress_form.dart';
import 'state_calculator_widget/calculated_recomended_form.dart';
import 'state_calculator_widget/completed_floor_form.dart';
import 'state_calculator_widget/progress_form.dart';
import 'state_calculator_widget/recommended_form.dart';
import 'state_calculator_widget/total_floor_form.dart';
import 'state_calculator_widget/widgets/advance_expansion_tile.dart';

class StageCalculatorForm extends StatefulWidget {
  final VoidCallback buttonSubmitted;
  final String propId;
  const StageCalculatorForm(
      {super.key, required this.buttonSubmitted, required this.propId});

  @override
  State<StageCalculatorForm> createState() => _StageCalculatorFormState();
}

class _StageCalculatorFormState extends State<StageCalculatorForm> {
  CalculatorService calculatorService = CalculatorService();
  bool _isDelayed = false;

  List calculatorDetails = [];

  List progress = [];
  List recommended = [];
  List totalFloor = [];
  List completedFloor = [];
  List progressPer = [];
  List recommendedPer = [];
  List progressFormValues = [];
  List recommendedFormValues = [];
  List totalFloorFormValues = [];
  List completedFloorFormValues = [];
  List progressPerFormValues = [];
  List recommendedPerFormValues = [];

  @override
  void initState() {
    getCalculatorRecords();
    super.initState();
  }

  getCalculatorRecords() async {
    AlertService().showLoading("Please wait...");
    Future.delayed(const Duration(seconds: 0), () async {
      calculatorDetails = await calculatorService.read(widget.propId);
      progress = jsonDecode(calculatorDetails[0]['Progress']);
      recommended = jsonDecode(calculatorDetails[0]['Recommended']);
      totalFloor = jsonDecode(calculatorDetails[0]['TotalFloor']);
      completedFloor = jsonDecode(calculatorDetails[0]['CompletedFloor']);
      progressPer = jsonDecode(calculatorDetails[0]['ProgressPer']);
      recommendedPer = jsonDecode(calculatorDetails[0]['RecommendedPer']);
      _isDelayed = true;
      setState(() {});
      AlertService().hideLoading();
    });
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    super.dispose();
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
                  CustomExpansionTile(
                    title: 'Progress Form',
                    leadingIcon: LineAwesome.building,
                    leadingIconColor: AppColors.primary,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ProgressFormWidget(
                          plinth: progress[0].toString(),
                          rcc: progress[1].toString(),
                          brickwork: progress[2].toString(),
                          internalPlaster: progress[3].toString(),
                          externalPlaster: progress[4].toString(),
                          flooring: progress[5].toString(),
                          electrification: progress[6].toString(),
                          woodwork: progress[7].toString(),
                          finishing: progress[8].toString(),
                          total: progress[9].toString(),
                          callback: (value) {
                            progressFormValues = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTheme.defaultSize,
                  CustomExpansionTile(
                    title: 'Recommended Form',
                    leadingIcon: LineAwesome.user_circle,
                    leadingIconColor: AppColors.primary,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RecommendedForm(
                          plinth: recommended[0].toString(),
                          rcc: recommended[1].toString(),
                          brickwork: recommended[2].toString(),
                          internalPlaster: recommended[3].toString(),
                          externalPlaster: recommended[4].toString(),
                          flooring: recommended[5].toString(),
                          electrification: recommended[6].toString(),
                          woodwork: recommended[7].toString(),
                          finishing: recommended[8].toString(),
                          total: recommended[9].toString(),
                          callback: (value) {
                            recommendedFormValues = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTheme.defaultSize,
                  CustomExpansionTile(
                    title: 'Total Floor in building',
                    leadingIcon: LineAwesome.building_solid,
                    leadingIconColor: AppColors.primary,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TotalFloorForm(
                          plinth: totalFloor[0].toString(),
                          rcc: totalFloor[1].toString(),
                          brickwork: totalFloor[2].toString(),
                          internalPlaster: totalFloor[3].toString(),
                          externalPlaster: totalFloor[4].toString(),
                          flooring: totalFloor[5].toString(),
                          electrification: totalFloor[6].toString(),
                          woodwork: totalFloor[7].toString(),
                          finishing: totalFloor[8].toString(),
                          total: totalFloor[9].toString(),
                          callback: (value) {
                            totalFloorFormValues = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTheme.defaultSize,
                  CustomExpansionTile(
                    title: 'Complete Floor Form',
                    leadingIcon: Bootstrap.building_fill_lock,
                    leadingIconColor: AppColors.primary,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CompletedFloorForm(
                          plinth: completedFloor[0].toString(),
                          rcc: completedFloor[1].toString(),
                          brickwork: completedFloor[2].toString(),
                          internalPlaster: completedFloor[3].toString(),
                          externalPlaster: completedFloor[4].toString(),
                          flooring: completedFloor[5].toString(),
                          electrification: completedFloor[6].toString(),
                          woodwork: completedFloor[7].toString(),
                          finishing: completedFloor[8].toString(),
                          total: completedFloor[9].toString(),
                          callback: (value) {
                            completedFloorFormValues = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTheme.defaultSize,
                  CustomExpansionTile(
                    title: 'Calculated Progress',
                    leadingIcon: Bootstrap.calculator,
                    leadingIconColor: AppColors.primary,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CalculatedProgressForm(
                          plinth: progressPer[0].toString(),
                          rcc: progressPer[1].toString(),
                          brickwork: progressPer[2].toString(),
                          internalPlaster: progressPer[3].toString(),
                          externalPlaster: progressPer[4].toString(),
                          flooring: progressPer[5].toString(),
                          electrification: progressPer[6].toString(),
                          woodwork: progressPer[7].toString(),
                          finishing: progressPer[8].toString(),
                          total: progressPer[9].toString(),
                          callback: (value) {
                            progressPerFormValues = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTheme.defaultSize,
                  CustomExpansionTile(
                    title: 'Calculated Recommended',
                    leadingIcon: LineAwesome.calculator_solid,
                    leadingIconColor: AppColors.primary,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CalculatedRecommendedForm(
                          plinth: recommendedPer[0].toString(),
                          rcc: recommendedPer[1].toString(),
                          brickwork: recommendedPer[2].toString(),
                          internalPlaster: recommendedPer[3].toString(),
                          externalPlaster: recommendedPer[4].toString(),
                          flooring: recommendedPer[5].toString(),
                          electrification: recommendedPer[6].toString(),
                          woodwork: recommendedPer[7].toString(),
                          finishing: recommendedPer[8].toString(),
                          total: recommendedPer[9].toString(),
                          callback: (value) {
                            recommendedPerFormValues = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTheme.defaultSize,
                  AppButton(
                      title: "Save & Next",
                      onPressed: () async {
                        widget.buttonSubmitted();
                        if (progressFormValues.isNotEmpty) {
                          print("progressFormValues -> $progressFormValues");
                        } else {
                          print("progress old value => $progress");
                        }
                      }),
                  CustomTheme.defaultSize,
                ],
              ),
            )
          : const Text("Loading..."),
    );
  }
}
