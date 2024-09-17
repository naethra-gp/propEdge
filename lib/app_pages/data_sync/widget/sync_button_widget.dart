import 'package:flutter/material.dart';

class SyncButtonWidget extends StatelessWidget {
  final IconData icons;
  final String label;
  final GestureTapCallback onTap;
  const SyncButtonWidget({
    super.key,
    required this.icons,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashFactory: InkRipple.splashFactory,
      splashColor: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icons, size: 22, color: label == "Upload" ? Colors.green : Colors.redAccent,),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: label == "Upload" ? Colors.green : Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}
