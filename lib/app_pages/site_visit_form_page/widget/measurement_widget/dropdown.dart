import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final List list;
  final String selectedValue;
  final String label;
  final Function(dynamic) onValueChanged;
  const DropdownWidget({
    super.key,
    required this.list,
    required this.selectedValue,
    required this.label,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: DropdownSearch(
        popupProps: PopupProps.menu(
          itemBuilder: (context, item, isSelected) {
            return ListTile(
              title: Text(
                item.toString(),
                style: TextStyle(color: Colors.black),
              ),
            );
          },
        ),
        selectedItem: selectedValue,
        items: list.map((e) => e['Name']).toList(),
        onChanged: onValueChanged,
      ),
    );
  }
}
