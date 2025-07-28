import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

class UsernameWidget extends StatelessWidget {
  final Function(String value) onSaved;
  const UsernameWidget({super.key, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: theme.primaryColor,
        fontSize: 16,
      ),
      onSaved: (String? value) {
        onSaved(value.toString());
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Username is mandatory!';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Username',
        // label: Text("use"),
        contentPadding: EdgeInsets.only(top: 13),
        prefixIcon: Icon(LineAwesome.user_circle, color: theme.primaryColor),
        labelStyle: TextStyle(color: theme.primaryColor),
        hintStyle: TextStyle(color: theme.primaryColor),
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
      ),
    );
  }
}
