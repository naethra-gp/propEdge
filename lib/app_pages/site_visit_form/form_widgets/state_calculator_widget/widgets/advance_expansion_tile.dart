import 'package:advance_expansion_tile/advance_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proequity/app_theme/theme_files/app_color.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color? leadingIconColor;
  final IconData? leadingIcon;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.children,
    this.leadingIconColor, this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AdvanceExpansionTileState> globalKey = GlobalKey();
    return AdvanceExpansionTile(
      key: globalKey,
      maintainState: false,
      textColor: leadingIconColor,
      iconColor: leadingIconColor,
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: leadingIconColor ?? AppColors.primary,
        ),
        child: Icon(
          leadingIcon ?? FontAwesome.bars_progress_solid,
          color: Colors.white,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          title,
          overflow: TextOverflow.clip,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD1DCFF),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      children: children,
      onTap: () {},
    );
  }
}
