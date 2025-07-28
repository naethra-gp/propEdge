import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class OnlineOfflineWidget extends StatelessWidget {
  final bool hasInternet;
  const OnlineOfflineWidget({super.key, required this.hasInternet});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: hasInternet ? Colors.green : Colors.redAccent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              hasInternet ? Bootstrap.wifi : Bootstrap.wifi_off,
              color: hasInternet ? Colors.green : Colors.redAccent,
            ),
            SizedBox(width: 5),
            Text(
              hasInternet ? "You're in Online." : "You're in Offline.",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: hasInternet ? Colors.green : Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
