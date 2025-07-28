/* ===============================================================
| Project :
| Page    : APP_BUTTON.DART
| Date    : 02-02-2024
|
*  ===============================================================*/

// Dependencies
import 'package:flutter/material.dart';

// App Button Class
class AppButton extends StatelessWidget {
  // LOCAL VARIABLE DECLARATION
  final String title;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? width;

  const AppButton(
      {super.key,
      required this.title,
      this.onPressed,
      this.backgroundColor,
      this.width});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      width: width == null
          ? double.maxFinite
          : MediaQuery.of(context).size.width * width!,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Color(0xff1980e3),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          textStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        child: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
