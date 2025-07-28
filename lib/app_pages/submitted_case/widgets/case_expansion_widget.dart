import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_theme/index.dart';
import '../../../app_utils/app_widget/row_detail_widget.dart';

class CaseExpansionWidget extends StatelessWidget {
  final List searchList;
  const CaseExpansionWidget({
    super.key,
    required this.searchList,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ExpansionTileGroup(
        toggleType: ToggleType.expandOnlyCurrent,
        spaceBetweenItem: 8,
        children: [
          for (var item in searchList) ...[
            ExpansionTileItem.outlined(
              decoration: BoxDecoration(
                boxShadow: [
                  const BoxShadow(
                    color: AppColors.primary,
                    blurRadius: 0.1,
                    spreadRadius: 0.1,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              title: _buildTitle(item),
              subtitle: _buildSubTitle(item),
              children: [
                RowDetailWidget(
                  title: "Application Number",
                  value: item['ApplicationNumber'].toString(),
                ),
                CustomTheme.defaultHeight10,
                RowDetailWidget(
                  title: "Colony Name",
                  value: item['ColonyName'].toString(),
                ),
                CustomTheme.defaultHeight10,
                RowDetailWidget(
                  title: "Date Of Visit",
                  value: item['DateOfVisit'].toString(),
                ),
                CustomTheme.defaultHeight10,
                RowDetailWidget(
                  title: "Institute Name",
                  value: item['InstituteName'].toString(),
                ),
                CustomTheme.defaultHeight10,
                RowDetailWidget(
                  title: "Location Name",
                  value: item['LocationName'].toString(),
                ),
                CustomTheme.defaultHeight10,
                RowDetailWidget(
                  title: "Customer Name",
                  value: item['CustomerName'].toString(),
                ),
                CustomTheme.defaultHeight10,
                RowDetailWidget(
                  title: "Contact Person Name",
                  value: item['ContactPersonName'].toString(),
                ),
                CustomTheme.defaultHeight10,
                RowDetailWidget(
                  title: "Contact Person Number",
                  value: maskNumber(item['ContactPersonNumber'].toString()),
                ),
                CustomTheme.defaultHeight10,
              ],
            ),
          ],
        ],
      ),
    );
  }

  maskNumber(String number) {
    if (number.length == 10) {
      return number.substring(0, 4) + ('*' * (number.length - 4));
    }
    return number;
  }

  Widget _buildTitle(item) {
    String a = item['ApplicationNumber'].toString();
    String b = item['CustomerName'].toString();
    return Text(
      "$a - $b",
      overflow: TextOverflow.clip,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }

  Widget _buildSubTitle(item) {
    String a = item['ColonyName'] == '' ? '' : "${item['ColonyName']},";
    String b = " ${item['LocationName'].toString().trim()}";
    return Text(
      "$a$b",
      overflow: TextOverflow.clip,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12,
        color: Colors.black54,
      ),
    );
  }
}
