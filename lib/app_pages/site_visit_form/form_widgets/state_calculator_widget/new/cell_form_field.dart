import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CellFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final TapRegionCallback? onTapOutside;
  final Color? fillColor;

  const CellFormField({
    super.key,
    required this.controller,
    required this.readOnly,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTapOutside,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
      ],
      textInputAction: TextInputAction.done,
      maxLength: 3,
      decoration: InputDecoration(
        counterText: "",
        isCollapsed: true,
        contentPadding: const EdgeInsets.all(5.0),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor:fillColor,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTapOutside: onTapOutside,
    );
  }
}
