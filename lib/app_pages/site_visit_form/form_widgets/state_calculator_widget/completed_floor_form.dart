import 'package:flutter/material.dart';

import '../../../../app_config/index.dart';
import 'widgets/form_in_row.dart';

class CompletedFloorForm extends StatelessWidget {
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

  const CompletedFloorForm({
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
    Controllers.completedFloorPlinth.text = plinth ?? "";
    Controllers.completedFloorRcc.text = rcc ?? "";
    Controllers.completedFloorBrickwork.text = brickwork ?? "";
    Controllers.completedFloorInternalPlaster.text = internalPlaster ?? "";
    Controllers.completedFloorExternalPlaster.text = externalPlaster ?? "";
    Controllers.completedFloorFlooring.text = flooring ?? "";
    Controllers.completedFloorElectrification.text = electrification ?? "";
    Controllers.completedFloorWoodwork.text = woodwork ?? "";
    Controllers.completedFloorFinishing.text = finishing ?? "";
    Controllers.completedFloorTotal.text = total ?? "";
    return Column(
      children: [
        FormInRow(
          title1: 'Plinth',
          controller1: Controllers.completedFloorPlinth,
          title2: "RCC",
          controller2: Controllers.completedFloorRcc,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Brickwork',
          controller1: Controllers.completedFloorBrickwork,
          title2: "Internal Plaster",
          controller2: Controllers.completedFloorInternalPlaster,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'External Plaster',
          controller1: Controllers.completedFloorExternalPlaster,
          title2: "Flooring",
          controller2: Controllers.completedFloorFlooring,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Electrification',
          controller1: Controllers.completedFloorElectrification,
          title2: "Woodwork",
          controller2: Controllers.completedFloorWoodwork,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Finishing',
          controller1: Controllers.completedFloorFinishing,
          title2: "Total",
          controller2: Controllers.completedFloorTotal,
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
      Controllers.completedFloorPlinth.text,
      Controllers.completedFloorRcc.text,
      Controllers.completedFloorBrickwork.text,
      Controllers.completedFloorInternalPlaster.text,
      Controllers.completedFloorExternalPlaster.text,
      Controllers.completedFloorFlooring.text,
      Controllers.completedFloorElectrification.text,
      Controllers.completedFloorWoodwork.text,
      Controllers.completedFloorFinishing.text,
      Controllers.completedFloorTotal.text,
    ];
    callback(controllerValues);
  }
}
