import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proequity/app_config/app_constants.dart';
import '../../../../app_theme/custom_theme.dart';
import '../../../../app_widgets/app_common/app_bar.dart';

class UploadViewWidget extends StatelessWidget {
  final List mapDetails;
  final List sketchDetails;
  final List photographDetails;
  const UploadViewWidget({
    super.key,
    required this.mapDetails,
    required this.sketchDetails,
    required this.photographDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: <Widget>[
              if (mapDetails.isNotEmpty) ...[
                const Text(
                  Constants.locationMapTitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTheme.defaultHeight10,
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: mapDetails.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    final item = mapDetails[index];
                    return listOfPhotos(item, context);
                  },
                ),
              ],
              CustomTheme.defaultSize,
              sketchDetails.isNotEmpty
                  ? const Text(
                      Constants.propertySketchTitle,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              CustomTheme.defaultSize,
              sketchDetails.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sketchDetails.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        final item = sketchDetails[index];
                        return listOfPhotos(item, context);
                      },
                    )
                  : Container(),
              photographDetails.isNotEmpty
                  ? const Text(
                      Constants.photographTitle,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              CustomTheme.defaultSize,
              photographDetails.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: photographDetails.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        final item = photographDetails[index];
                        return listOfPhotos(item, context);
                      })
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget listOfPhotos(list, BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: const AppBarWidget(
                  title: "View Photos",
                  action: false,
                ),
                body: Hero(
                  tag: "preview",
                  child: Center(
                    // child: validURL
                    //     ? Image.network(list['ImagePath'], fit: BoxFit.cover)
                    //     : Image.file(File(list['ImagePath']),
                    //         fit: BoxFit.cover),
                    child: Uri.parse(list['ImagePath']).isAbsolute
                        ? Image.network(list['ImagePath'], fit: BoxFit.cover)
                        : Image.file(File(list['ImagePath']),
                            fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        );
      },
      leading: Container(
        height: 70,
        width: 70,
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
        ),
        // child: validURL
        //     ? Image.network(
        //         list['ImagePath'],
        //         fit: BoxFit.cover,
        //         height: 50,
        //         width: 50,
        //       )
        //     : Image.file(
        //         File(list['ImagePath']),
        //         fit: BoxFit.cover,
        //         height: 50,
        //         width: 50,
        //       ),
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
      title: Text(
        list['ImageName'].toString(),
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        list['ImageDesc'].toString(),
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}
