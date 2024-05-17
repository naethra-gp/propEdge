import 'package:flutter/material.dart';

import '../../../../app_config/index.dart';
import 'widgets/form_in_row.dart';

class TotalFloorForm extends StatelessWidget {
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

  const TotalFloorForm({
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
    Controllers.totalFloorPlinth.text = plinth ?? "";
    Controllers.totalFloorRcc.text = rcc ?? "";
    Controllers.totalFloorBrickwork.text = brickwork ?? "";
    Controllers.totalFloorInternalPlaster.text = internalPlaster ?? "";
    Controllers.totalFloorExternalPlaster.text = externalPlaster ?? "";
    Controllers.totalFloorFlooring.text = flooring ?? "";
    Controllers.totalFloorElectrification.text = electrification ?? "";
    Controllers.totalFloorWoodwork.text = woodwork ?? "";
    Controllers.totalFloorFinishing.text = finishing ?? "";
    Controllers.totalFloorTotal.text = total ?? "";
    return Column(
      children: [
        FormInRow(
          title1: 'Plinth',
          controller1: Controllers.totalFloorPlinth,
          title2: "RCC",
          controller2: Controllers.totalFloorRcc,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Brickwork',
          controller1: Controllers.totalFloorBrickwork,
          title2: "Internal Plaster",
          controller2: Controllers.totalFloorInternalPlaster,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'External Plaster',
          controller1: Controllers.totalFloorExternalPlaster,
          title2: "Flooring",
          controller2: Controllers.totalFloorFlooring,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Electrification',
          controller1: Controllers.totalFloorElectrification,
          title2: "Woodwork",
          controller2: Controllers.totalFloorWoodwork,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Finishing',
          controller1: Controllers.totalFloorFinishing,
          title2: "Total",
          controller2: Controllers.totalFloorTotal,
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
      Controllers.totalFloorPlinth.text,
      Controllers.totalFloorRcc.text,
      Controllers.totalFloorBrickwork.text,
      Controllers.totalFloorInternalPlaster.text,
      Controllers.totalFloorExternalPlaster.text,
      Controllers.totalFloorFlooring.text,
      Controllers.totalFloorElectrification.text,
      Controllers.totalFloorWoodwork.text,
      Controllers.totalFloorFinishing.text,
      Controllers.totalFloorTotal.text,
    ];
    callback(controllerValues);
  }
}