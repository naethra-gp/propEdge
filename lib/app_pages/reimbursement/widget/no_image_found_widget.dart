import 'package:flutter/material.dart';

import '../../../app_theme/index.dart';

class NoImageFoundWidget extends StatelessWidget {
  const NoImageFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      child: Image.asset(
        "assets/images/img_1.png",
        height: MediaQuery.of(context).size.height * 0.2,
        fit: BoxFit.cover,
      ),
    );
  }
}
