import 'package:flutter/material.dart';

import '../../../../../app_config/index.dart';
import '../../../../../app_widgets/index.dart';

class TextFormWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Function(String) callback;

  const TextFormWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: CustomTextFormField(
        title: title,
        decoration: AppStaticFunctions.calculatorStyle("Plinth"),
        keyboardType: TextInputType.number,
        controller: controller,
        onChanged: (String value) {
          callback(value);
        },
      ),
    );
  }
}
