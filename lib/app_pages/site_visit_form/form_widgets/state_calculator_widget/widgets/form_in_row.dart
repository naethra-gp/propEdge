import 'package:flutter/material.dart';

import 'text_form_widget.dart';

class FormInRow extends StatelessWidget {
  final String title1;
  final String title2;
  final TextEditingController controller1;
  final TextEditingController controller2;

  final Function(String) callback;

  const FormInRow({
    super.key,
    required this.title1,
    required this.title2,
    required this.controller1,
    required this.controller2,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormWidget(
          title: title1,
          controller: controller1,
          callback: (String value) {
            callback(controller1.text);
          },
        ),
        const SizedBox(width: 10),
        TextFormWidget(
          title: title2,
          controller: controller2,
          callback: (String value) {
            callback(controller2.text);
          },
        ),
      ],
    );
  }
}
