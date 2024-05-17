import 'package:advance_expansion_tile/advance_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../app_theme/custom_theme.dart';

class CaseExpansionWidget extends StatelessWidget {
  final Color? leadingIconColor;
  final IconData? leadingIcon;
  final Color? iconColor;
  final dynamic item;
  const CaseExpansionWidget({
    super.key,
    this.leadingIconColor,
    this.leadingIcon,
    this.iconColor,
    this.item,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AdvanceExpansionTileState> globalKey = GlobalKey();

    return AdvanceExpansionTile(
      key: globalKey,
      maintainState: false,
      textColor: leadingIconColor,
      iconColor: leadingIconColor,
      tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: leadingIconColor,
        ),
        child: Icon(
          leadingIcon ?? LineAwesome.building,
          color: Colors.white,
        ),
      ),
      title: Text(
        "${item['ApplicationNumber'].toString()} - ${item['CustomerName'].toString()}",
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        "${item['ColonyName'] == '' ? 'NIL' : item['ColonyName']} - ${item['LocationName'].toString()}",
        overflow: TextOverflow.clip,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      decoration: CustomTheme.decoration,
      children: [
        rowDetails("Application Number", item['ApplicationNumber'].toString()),
        CustomTheme.defaultHeight10,
        rowDetails("Colony Name", item['ColonyName'].toString()),
        CustomTheme.defaultHeight10,
        rowDetails("Date Of Visit", item['DateOfVisit'].toString()),
        CustomTheme.defaultHeight10,
        rowDetails("Institute Name", item['InstituteName'].toString()),
        CustomTheme.defaultHeight10,
        rowDetails("Location Name", item['LocationName'].toString()),
        CustomTheme.defaultHeight10,
        rowDetails("Customer Name", item['CustomerName'].toString()),
        CustomTheme.defaultHeight10,
        rowDetails("Contact Person Name", item['ContactPersonName'].toString()),
        CustomTheme.defaultHeight10,
        rowDetails("Contact Person Number", item['ContactPersonNumber'].toString()),
        CustomTheme.defaultHeight10,

      ],
    );
  }
  Widget rowDetails(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Text(
          value.toString() == "" ? "-" : value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

}
