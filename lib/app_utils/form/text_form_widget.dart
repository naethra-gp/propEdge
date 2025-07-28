import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_theme/custom_theme.dart';

//Global Text Form Field
class CustomTextFormField extends StatelessWidget {
  // LOCAL VARIABLE DECLARATION
  final String title;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData? prefixIcon;
  final Color? iconColor;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final FormFieldSetter? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final bool required;
  final bool? readOnly;
  final bool? autofocus;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool suffixIconTrue;
  final IconData? suffixIcon;
  final String? suffixText;
  final VoidCallback? suffixIconOnPressed;
  final String? helperText;
  final String? errorText;
  final TextStyle? helperStyle;
  final bool? obscureText;
  final bool? enabled;
  final String? obscuringCharacter;
  final String? counterText;
  final int errorMaxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String? initialValue;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  final InputDecoration? decoration;

  const CustomTextFormField(
      {super.key,
      required this.title,
      this.keyboardType,
      this.textInputAction,
      this.prefixIcon,
      this.controller,
      this.validator,
      this.onSaved,
      this.onFieldSubmitted,
      this.required = false,
      this.readOnly,
      this.onTap,
      this.inputFormatters,
      this.autofocus,
      this.suffixIconTrue = false,
      this.suffixIcon,
      this.suffixText,
      this.suffixIconOnPressed,
      this.helperText,
      this.helperStyle,
      this.obscureText,
      this.errorMaxLines = 2,
      this.obscuringCharacter,
      this.maxLength,
      this.counterText,
      this.onChanged,
      this.focusNode,
      this.enabled,
      this.initialValue,
      this.hintText,
      this.errorText,
      this.textCapitalization,
      this.iconColor,
      this.maxLines = 1,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        required
            ? RichText(
                text: TextSpan(
                  text: title,
                  style: CustomTheme.formLabelStyle,
                  children: const [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
              )
            : RichText(
                text: TextSpan(
                  text: title,
                  style: CustomTheme.formLabelStyle,
                ),
              ),
        const SizedBox(height: 5),
        //Global Text Form Field
        TextFormField(
          initialValue: initialValue,
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
          textInputAction: textInputAction ?? TextInputAction.next,
          maxLength: maxLength,
          obscureText: obscureText ?? false,
          obscuringCharacter: obscuringCharacter ?? '*',
          autofocus: autofocus ?? false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          textCapitalization: textCapitalization ?? TextCapitalization.words,
          readOnly: readOnly ?? false,
          enabled: enabled,
          onSaved: onSaved,
          onTap: onTap,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          onFieldSubmitted: onFieldSubmitted,
          focusNode: focusNode,
          maxLines: maxLines,
          style: CustomTheme.formFieldStyle,
          // style: CustomTheme.formFieldStyle,
          decoration: decoration ??
              InputDecoration(
                hintText: hintText ?? title,
                counterText: counterText ?? '',
                errorMaxLines: errorMaxLines,
                helperText: helperText,
                filled: readOnly == true ? true : false,
                fillColor: Colors.grey[100],
                errorText: errorText,
                errorStyle: CustomTheme.errorStyle,
                helperStyle: helperStyle,
                hintStyle: CustomTheme.formHintStyle,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(color: Color(0xff1980e3)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 1.5),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Color(0xff1980e3)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(10.0),
                isDense: false,
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon,
                        color: iconColor ?? Theme.of(context).primaryColor)
                    : null,
                suffixIcon: (suffixIconTrue && suffixText == null)
                    ? IconButton(
                        onPressed: suffixIconOnPressed,
                        icon: Icon(
                          suffixIcon,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : suffixText != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            constraints: const BoxConstraints(
                              maxHeight: 100.0,
                              maxWidth: 100.0,
                            ),
                            child: TextButton(
                              onPressed: suffixIconOnPressed,
                              child: Text(
                                suffixText.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.red),
                              ),
                            ),
                          )
                        : null,
              ),
        ),
      ],
    );
  }
}
