import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

class PasswordWidget extends StatelessWidget {
  final bool hidePassword;
  final Function(String value) onSaved;
  final VoidCallback? onPressed;

  const PasswordWidget({
    super.key,
    required this.hidePassword,
    required this.onSaved,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextFormField(
      obscureText: hidePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: theme.primaryColor,
        fontSize: 16,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // Block spaces
      ],
      onSaved: (value) {
        onSaved(value.toString());

        // loginRequestModel.password = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is mandatory!';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.only(top: 13),
        hintStyle: TextStyle(color: theme.primaryColor),
        labelStyle: TextStyle(color: theme.primaryColor),
        prefixIcon: Icon(LineAwesome.lock_solid, color: theme.primaryColor),
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(
            hidePassword ? LineAwesome.eye : LineAwesome.eye_slash,
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
      ),
    );
  }
}
