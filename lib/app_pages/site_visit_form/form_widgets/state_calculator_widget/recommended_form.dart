import 'package:flutter/material.dart';

import '../../../../app_config/index.dart';
import 'widgets/form_in_row.dart';

class RecommendedForm extends StatelessWidget {
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

  const RecommendedForm({
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
    Controllers.recommendedPlinth.text = plinth ?? "";
    Controllers.recommendedRcc.text = rcc ?? "";
    Controllers.recommendedBrickwork.text = brickwork ?? "";
    Controllers.recommendedInternalPlaster.text = internalPlaster ?? "";
    Controllers.recommendedExternalPlaster.text = externalPlaster ?? "";
    Controllers.recommendedFlooring.text = flooring ?? "";
    Controllers.recommendedElectrification.text = electrification ?? "";
    Controllers.recommendedWoodwork.text = woodwork ?? "";
    Controllers.recommendedFinishing.text = finishing ?? "";
    Controllers.recommendedTotal.text = total ?? "";

    return Column(
      children: [
        FormInRow(
          title1: 'Plinth',
          controller1: Controllers.recommendedPlinth,
          title2: "RCC",
          controller2: Controllers.recommendedRcc,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Brickwork',
          controller1: Controllers.recommendedBrickwork,
          title2: "Internal Plaster",
          controller2: Controllers.recommendedInternalPlaster,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'External Plaster',
          controller1: Controllers.recommendedExternalPlaster,
          title2: "Flooring",
          controller2: Controllers.recommendedFlooring,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Electrification',
          controller1: Controllers.recommendedElectrification,
          title2: "Woodwork",
          controller2: Controllers.recommendedWoodwork,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Finishing',
          controller1: Controllers.recommendedFinishing,
          title2: "Total",
          controller2: Controllers.recommendedTotal,
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
      Controllers.recommendedPlinth.text,
      Controllers.recommendedRcc.text,
      Controllers.recommendedBrickwork.text,
      Controllers.recommendedInternalPlaster.text,
      Controllers.recommendedExternalPlaster.text,
      Controllers.recommendedFlooring.text,
      Controllers.recommendedElectrification.text,
      Controllers.recommendedWoodwork.text,
      Controllers.recommendedFinishing.text,
      Controllers.recommendedTotal.text,
    ];
    callback(controllerValues);
  }
}
