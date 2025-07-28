import 'package:flutter/material.dart';

class RowDetailsWidget extends StatelessWidget {
  final String label;
  final String value;

  const RowDetailsWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 3,
            child: Column(
              children: [
                Text(
                  getEmptyToNil(value),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getEmptyToNil(String value) {
    if (value == '' || value.toLowerCase() == 'null') {
      return '-';
    }
    return value;
  }
}
