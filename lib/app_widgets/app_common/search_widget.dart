import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Iterable<Widget>? trailing;

  const SearchWidget(
      {super.key, this.hintText, this.controller, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      backgroundColor: MaterialStateProperty.all(Colors.white),
      shadowColor: MaterialStateProperty.all(const Color(0xff1980e3)),
      elevation: MaterialStateProperty.all(5.0),
      shape: MaterialStateProperty.all(
        const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      side: MaterialStateProperty.all(
        const BorderSide(
          color: Color(0xff1980e3),
        ),
      ),
      hintText: hintText,
      hintStyle: MaterialStateProperty.all(
        const TextStyle(color: Colors.grey),
      ),
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.search),
      ),
      trailing: [
        controller?.text != ''
            ? IconButton(
                onPressed: () {
                  controller?.text = '';
                  FocusScope.of(context).unfocus();
                },
                icon: const Icon(Icons.close),
              )
            : const SizedBox()
      ],
      // trailing: trailing,
    );
  }
}
