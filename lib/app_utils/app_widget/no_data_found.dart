import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/no-data-6-512.png",
          height: 200,
          width: 200,
          fit: BoxFit.fitHeight,
        ),
        const Text(
          'SORRY!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black54,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Text(
          'We Haven\'t Found Any Data.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
