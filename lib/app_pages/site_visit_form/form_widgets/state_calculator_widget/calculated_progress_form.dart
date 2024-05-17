import 'package:flutter/material.dart';

import '../../../../app_config/index.dart';
import 'widgets/form_in_row.dart';

class CalculatedProgressForm extends StatelessWidget {
  final dynamic plinth;
  final dynamic rcc;
  final dynamic brickwork;
  final dynamic internalPlaster;
  final dynamic externalPlaster;
  final dynamic flooring;
  final dynamic electrification;
  final dynamic woodwork;
  final dynamic finishing;
  final dynamic total;
  final void Function(dynamic) callback;

  const CalculatedProgressForm({
    super.key,
    this.plinth,
    this.rcc,
    this.brickwork,
    this.internalPlaster,
    this.externalPlaster,
    this.flooring,
    this.electrification,
    this.woodwork,
    this.finishing,
    this.total,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    Controllers.calculatedProgressPlinth.text = plinth ?? "";
    Controllers.calculatedProgressRcc.text = rcc ?? "";
    Controllers.calculatedProgressBrickwork.text = brickwork ?? "";
    Controllers.calculatedProgressInternalPlaster.text = internalPlaster ?? "";
    Controllers.calculatedProgressExternalPlaster.text = externalPlaster ?? "";
    Controllers.calculatedProgressFlooring.text = flooring ?? "";
    Controllers.calculatedProgressElectrification.text = electrification ?? "";
    Controllers.calculatedProgressWoodwork.text = woodwork ?? "";
    Controllers.calculatedProgressFinishing.text = finishing ?? "";
    Controllers.calculatedProgressTotal.text = total ?? "";
    return Column(
      children: [
        FormInRow(
          title1: 'Plinth',
          controller1: Controllers.calculatedProgressPlinth,
          title2: "RCC",
          controller2: Controllers.calculatedProgressRcc,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Brickwork',
          controller1: Controllers.calculatedProgressBrickwork,
          title2: "Internal Plaster",
          controller2: Controllers.calculatedProgressInternalPlaster,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'External Plaster',
          controller1: Controllers.calculatedProgressExternalPlaster,
          title2: "Flooring",
          controller2: Controllers.calculatedProgressFlooring,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Electrification',
          controller1: Controllers.calculatedProgressElectrification,
          title2: "Woodwork",
          controller2: Controllers.calculatedProgressWoodwork,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Finishing',
          controller1: Controllers.calculatedProgressFinishing,
          title2: "Total",
          controller2: Controllers.calculatedProgressTotal,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  formValueChange() {
    List controllerValues = [
      Controllers.calculatedProgressPlinth.text,
      Controllers.calculatedProgressRcc.text,
      Controllers.calculatedProgressBrickwork.text,
      Controllers.calculatedProgressInternalPlaster.text,
      Controllers.calculatedProgressExternalPlaster.text,
      Controllers.calculatedProgressFlooring.text,
      Controllers.calculatedProgressElectrification.text,
      Controllers.calculatedProgressWoodwork.text,
      Controllers.calculatedProgressFinishing.text,
      Controllers.calculatedProgressTotal.text,
    ];
    callback(controllerValues);
  }
}
