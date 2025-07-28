import 'package:flutter/material.dart';

class CenterHeading extends StatelessWidget {
  const CenterHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: const Text(
        "Reimbursement Details",
        style: TextStyle(
          fontSize: 18,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
