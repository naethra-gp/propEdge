import 'package:flutter/material.dart';

import '../../../../app_config/index.dart';
import 'widgets/form_in_row.dart';

class ProgressFormWidget extends StatelessWidget {
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
  const ProgressFormWidget({
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
    Controllers.progressPlinth.text = plinth ?? "";
    Controllers.progressRcc.text = rcc ?? "";
    Controllers.progressBrickwork.text = brickwork ?? "";
    Controllers.progressInternalPlaster.text = internalPlaster ?? "";
    Controllers.progressExternalPlaster.text = externalPlaster ?? "";
    Controllers.progressFlooring.text = flooring ?? "";
    Controllers.progressElectrification.text = electrification ?? "";
    Controllers.progressWoodwork.text = woodwork ?? "";
    Controllers.progressFinishing.text = finishing ?? "";
    Controllers.progressTotal.text = total ?? "";
    return Column(
      children: [
        FormInRow(
          title1: 'Plinth',
          controller1: Controllers.progressPlinth,
          title2: "RCC",
          controller2: Controllers.progressRcc,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Brickwork',
          controller1: Controllers.progressBrickwork,
          title2: "Internal Plaster",
          controller2: Controllers.progressInternalPlaster,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'External Plaster',
          controller1: Controllers.progressExternalPlaster,
          title2: "Flooring",
          controller2: Controllers.progressFlooring,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Electrification',
          controller1: Controllers.progressElectrification,
          title2: "Woodwork",
          controller2: Controllers.progressWoodwork,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
        FormInRow(
          title1: 'Finishing',
          controller1: Controllers.progressFinishing,
          title2: "Total",
          controller2: Controllers.progressTotal,
          callback: (String value) {
            formValueChange();
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }
  calculateTotal() {

  }

  formValueChange() {
    List controllerValues = [
      Controllers.progressPlinth.text,
      Controllers.progressRcc.text,
      Controllers.progressBrickwork.text,
      Controllers.progressInternalPlaster.text,
      Controllers.progressExternalPlaster.text,
      Controllers.progressFlooring.text,
      Controllers.progressElectrification.text,
      Controllers.progressWoodwork.text,
      Controllers.progressFinishing.text,
      Controllers.progressTotal.text,
    ];
    callback(controllerValues);
  }
}
