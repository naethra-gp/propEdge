import 'package:flutter/material.dart';

import '../../../../app_config/index.dart';
import 'widgets/form_in_row.dart';

class CalculatedRecommendedForm extends StatelessWidget {
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

  const CalculatedRecommendedForm(
      {super.key,
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
      required this.callback,});

  @override
  Widget build(BuildContext context) {
    Controllers.calculatedRecommendPlinth.text = plinth ?? "";
    Controllers.calculatedRecommendRcc.text = rcc ?? "";
    Controllers.calculatedRecommendBrickwork.text = brickwork ?? "";
    Controllers.calculatedRecommendInternalPlaster.text = internalPlaster ?? "";
    Controllers.calculatedRecommendExternalPlaster.text = externalPlaster ?? "";
    Controllers.calculatedRecommendFlooring.text = flooring ?? "";
    Controllers.calculatedRecommendElectrification.text = electrification ?? "";
    Controllers.calculatedRecommendWoodwork.text = woodwork ?? "";
    Controllers.calculatedRecommendFinishing.text = finishing ?? "";
    Controllers.calculatedRecommendTotal.text = total ?? "";
    return Column(
      children: [
        FormInRow(
          title1: 'Plinth',
          controller1: Controllers.calculatedRecommendPlinth,
          title2: "RCC",
          controller2: Controllers.calculatedRecommendRcc,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Brickwork',
          controller1: Controllers.calculatedRecommendBrickwork,
          title2: "Internal Plaster",
          controller2: Controllers.calculatedRecommendInternalPlaster,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'External Plaster',
          controller1: Controllers.calculatedRecommendExternalPlaster,
          title2: "Flooring",
          controller2: Controllers.calculatedRecommendFlooring,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Electrification',
          controller1: Controllers.calculatedRecommendElectrification,
          title2: "Woodwork",
          controller2: Controllers.calculatedRecommendWoodwork,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Finishing',
          controller1: Controllers.calculatedRecommendFinishing,
          title2: "Total",
          controller2: Controllers.calculatedRecommendTotal,
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
      Controllers.calculatedRecommendPlinth.text,
      Controllers.calculatedRecommendRcc.text,
      Controllers.calculatedRecommendBrickwork.text,
      Controllers.calculatedRecommendInternalPlaster.text,
      Controllers.calculatedRecommendExternalPlaster.text,
      Controllers.calculatedRecommendFlooring.text,
      Controllers.calculatedRecommendElectrification.text,
      Controllers.calculatedRecommendWoodwork.text,
      Controllers.calculatedRecommendFinishing.text,
      Controllers.calculatedRecommendTotal.text,
    ];
    callback(controllerValues);
  }
}
