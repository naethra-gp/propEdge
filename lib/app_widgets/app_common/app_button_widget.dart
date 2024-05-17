/* ===============================================================
| Project :
| Page    : APP_BUTTON.DART
| Date    : 02-02-2024
|
*  ===============================================================*/

// Dependencies
import 'package:flutter/material.dart';
import 'package:proequity/app_pages/app_global/app_text_styles.dart';

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
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppStyles.buttonStyle,
        child: Text(title,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
      ),
    );
  }
}
