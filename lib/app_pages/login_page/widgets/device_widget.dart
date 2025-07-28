import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:prop_edge/app_utils/alert_service.dart';

import '../../../app_utils/alert_service2.dart';

class DeviceWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value) onSaved;

  const DeviceWidget({
    super.key,
    required this.controller,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextFormField(
      readOnly: true,
      controller: controller,
      keyboardType: TextInputType.text,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: theme.primaryColor,
        fontSize: 16,
      ),
      onSaved: (value) {
        onSaved(value.toString());

        // loginRequestModel.iMEINumber = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Device ID is mandatory!';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Device ID',
        contentPadding: EdgeInsets.only(top: 13),
        labelStyle: TextStyle(color: theme.primaryColor),
        prefixIcon: Icon(
          LineAwesome.mobile_alt_solid,
          color: theme.primaryColor,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            Clipboard.setData(
              ClipboardData(text: controller.text),
            ).then((_) {
              AlertService().toast('Copied to clipboard');
            });
          },
          icon: Icon(
            Icons.copy_outlined,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme.primaryColor.withAlpha(128),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme.primaryColor.withAlpha(128),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        hintStyle: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
