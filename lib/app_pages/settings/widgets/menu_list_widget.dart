import 'package:flutter/material.dart';

class MenuListWidget extends StatelessWidget {
  final int themeValue;
  final IconData leadingIcon;
  final Widget trailing;
  final String title;

  const MenuListWidget({
    super.key,
    required this.themeValue,
    required this.leadingIcon,
    required this.trailing,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            themeValue == 1 ? Colors.white70 : Theme.of(context).primaryColor,
        child: Icon(
          leadingIcon,
          color:
              themeValue != 1 ? Colors.white : Theme.of(context).primaryColor,
        ),
      ),
      title: Text(title,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: 14, fontWeight: FontWeight.w800)),
      trailing: trailing,
    );
  }
}
