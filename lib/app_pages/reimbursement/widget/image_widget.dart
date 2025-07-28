import 'package:flutter/material.dart';

import '../../../app_theme/index.dart';

class ImageWidget extends StatelessWidget {
  final Widget child;
  const ImageWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}
