import 'package:flutter/material.dart';
import 'package:prop_edge/app_theme/app_color.dart';

class SearchWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Iterable<Widget>? trailing;

  const SearchWidget({
    super.key,
    this.hintText,
    this.controller,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SearchBar(
      hintText: hintText,
      controller: controller,
      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      backgroundColor: WidgetStateProperty.all(Colors.white),
      elevation: WidgetStateProperty.all(0),
      side: WidgetStateProperty.all(BorderSide(color: theme.primaryColor)),
      hintStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: WidgetStateProperty.all(
        const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      leading: IconButton(
        padding: EdgeInsets.zero,
        onPressed: null,
        icon: const Icon(Icons.search),
      ),
      trailing: [
        controller?.text != ''
            ? IconButton(
                onPressed: () {
                  controller?.text = '';
                  FocusScope.of(context).unfocus();
                },
                icon: const Icon(
                  Icons.close,
                  size: 22,
                  color: AppColors.blackLight,
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
