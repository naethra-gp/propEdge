import 'package:flutter/material.dart';

class GlobalAlertWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Widget buttonWidget;
  const GlobalAlertWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.buttonWidget,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  image,
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
              Text(
                title.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16),
              Text(
                description.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30),
              buttonWidget
            ],
          ),
        ),
      ),
    );
  }
}
