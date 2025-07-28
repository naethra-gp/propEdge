import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prop_edge/app_utils/alert_service2.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import '../../../../../app_utils/app/app_bar.dart';

class ListImageWidget extends StatelessWidget {
  final dynamic list;
  final Function(bool) onDelete;
  const ListImageWidget(
      {super.key, required this.list, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        side: BorderSide(color: Colors.black54),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) {
                      return ViewImageWidget(
                        imagePath: list['ImagePath'],
                      );
                    },
                  ),
                );
              },
              child: Container(
                height: 60,
                width: 60,
                alignment: Alignment.center,
                child: Uri.parse(list['ImagePath']).isAbsolute
                    ? Image.network(
                        list['ImagePath'],
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      )
                    : Image.file(
                        File(list['ImagePath']),
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      ),
              ),
            ),
            SizedBox(width: 5),
            SizedBox(
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      list['ImageName'].toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    list['ImageDesc'].toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red.shade700),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                icon: Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () async {
                  AlertService alertService = AlertService();
                  bool? confirm = await alertService.confirmAlert(
                    context,
                    null,
                    'Do you want delete this photo?',
                  );
                  if (confirm!) {
                    onDelete(confirm);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ViewImageWidget extends StatelessWidget {
  final String imagePath;
  const ViewImageWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarWidget(title: "View Photos", action: false),
        body: Hero(
          tag: "preview",
          child: Center(
            child: Uri.parse(imagePath).isAbsolute
                ? Image.network(imagePath, fit: BoxFit.cover)
                : Image.file(File(imagePath), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
