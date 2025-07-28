import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class DsListWidget extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData? leadingIcon;
  final bool upload;
  final VoidCallback? onPressed;

  const DsListWidget({
    super.key,
    required this.title,
    this.subTitle,
    this.leadingIcon,
    required this.upload,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(color: Colors.grey)
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        // leading: Container(
        //   padding: const EdgeInsets.all(10.0),
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     color: Theme.of(context).primaryColor,
        //   ),
        //   child: Icon(
        //     leadingIcon,
        //     color: Colors.white,
        //     size: 15,
        //   ),
        // ),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
        ),
        subtitle: subTitle != null
            ? Text(
                subTitle!,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      // color: Colors.white54
                    ),
              )
            : null,
        trailing: IconButton(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                upload ? Bootstrap.database_up : Bootstrap.database_down,
                size: 20,
                color: upload ? Colors.green : Colors.redAccent,
              ),
              SizedBox(height: 3),
              Text(
                upload ? "Upload" : "Download",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: upload ? Colors.green : Colors.redAccent,
                ),
              ),
            ],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
