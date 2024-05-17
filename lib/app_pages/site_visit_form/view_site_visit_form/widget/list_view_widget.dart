import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewWidget extends StatelessWidget {
  final String label;
  final String value;
  const ListViewWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
      Expanded(flex:2,child:Text(
        label.toString(),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[850],
          fontWeight: FontWeight.normal,
        ),
      )),
      Expanded(flex:1,child:Text(
        maxLines: 10,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        value.toString() == "" ? "-" : value.toString(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey[850],
        ),
      ),
      )]);
  }
}
