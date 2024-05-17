import 'dart:io';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:proequity/app_widgets/alert_widget.dart';
import '../../../app_config/index.dart';
import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_theme/theme_files/app_color.dart';
import '../../../app_widgets/index.dart';
import 'upload_photos/upload_form_dialog.dart';

class UploadPictures extends StatefulWidget {
  final VoidCallback buttonSubmitted;
  final String propId;
  const UploadPictures({
    super.key,
    required this.buttonSubmitted,
    required this.propId,
  });

  @override
  State<UploadPictures> createState() => _UploadPicturesState();
}

class _UploadPicturesState extends State<UploadPictures> {
  CustomSegmentedController<int> controller = CustomSegmentedController();
  UploadLocationMapService locationMapService = UploadLocationMapService();
  SketchService sketchService = SketchService();
  PhotographService photographService = PhotographService();
  AlertService alertService = AlertService();

  List locationPhotos = [];
  List sketchPhotos = [];
  List photographPhotos = [];
  bool validURL = false;
  @override
  void initState() {
    controller.value = 1;
    getControllerBased();
    super.initState();
  }

  getControllerBased() {
    if (controller.value == 1) {
      getLocationMapDetails(Constants.locationMapTitle);
    } else if (controller.value == 2) {
      getLocationMapDetails(Constants.propertySketchTitle);
    } else if (controller.value == 3) {
      getLocationMapDetails(Constants.photographTitle);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  getLocationMapDetails(String title) async {
    if (title == Constants.locationMapTitle) {
      locationPhotos = await locationMapService.read(widget.propId);
      print("location pp" + locationPhotos.length.toString());
    } else if (title == Constants.propertySketchTitle) {
      sketchPhotos = await sketchService.read(widget.propId);
      if (sketchPhotos.isNotEmpty) {
        validURL = Uri.parse(sketchPhotos[0]['ImagePath']).isAbsolute;
      }
    } else if (title == Constants.photographTitle) {
      photographPhotos = await photographService.read(widget.propId);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CustomSlidingSegmentedControl<int>(
                initialValue: 1,
                padding: 15,
                curve: Curves.easeInCirc,
                controller: controller,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                duration: const Duration(milliseconds: 100),
                innerPadding: const EdgeInsets.all(10.0),
                onValueChanged: (int index) {
                  controller.value = index;
                  getControllerBased();
                  setState(() {});
                },
                children: {
                  1: getTitle('Location Map', 1),
                  2: getTitle('Sketch', 2),
                  3: getTitle('Photograph', 3),
                },
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                thumbDecoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      blurRadius: 2.0,
                      // spreadRadius: 1.0,
                      offset: const Offset(0.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
            CustomTheme.defaultSize,
            if (controller.value == 1) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (locationPhotos.isNotEmpty) {
                        AlertService()
                            .errorToast(Constants.limitExistsErrorMessage);
                      } else {
                        showUploadPictures(context, Constants.locationMapTitle);
                      }
                    },
                    child: const Text(
                      "Upload ${Constants.locationMapTitle}",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              CustomTheme.defaultSize,
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: locationPhotos.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        final item = locationPhotos[index];
                        return listOfPhotos(item, Constants.locationMapTitle);
                      },
                    ),
                  ],
                ),
              ),
            ],
            if (controller.value == 2) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (sketchPhotos.length > 15) {
                        AlertService().errorToast(Constants.maxUploadMessage);
                      } else {
                        showUploadPictures(
                            context, Constants.propertySketchTitle);
                      }
                    },
                    child: const Text(
                      "Upload ${Constants.propertySketchTitle}",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              CustomTheme.defaultSize,
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: sketchPhotos.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        final item = sketchPhotos[index];
                        return listOfPhotos(
                            item, Constants.propertySketchTitle);
                      },
                    ),
                  ],
                ),
              ),
            ],
            if (controller.value == 3) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (photographPhotos.length > 15) {
                        AlertService().errorToast(Constants.maxUploadMessage);
                      } else {
                        showUploadPictures(context, Constants.photographTitle);
                      }
                    },
                    child: const Text(
                      "Upload ${Constants.photographTitle}",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              CustomTheme.defaultSize,
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: photographPhotos.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        final item = photographPhotos[index];
                        return listOfPhotos(item, Constants.photographTitle);
                      },
                    ),
                  ],
                ),
              ),
              CustomTheme.defaultSize,
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: AppButton(
                  title: "Final Submit",
                  onPressed: () async {
                    String msg =
                        "Please review your forms before final submission because once you submit,you won't be able to edit the form";

                    PropertyLocationServices pls = PropertyLocationServices();
                    LocationDetailServices lds = LocationDetailServices();
                    CommentsServices ccs = CommentsServices();

                    List pl = await pls.getPropertyLocation(widget.propId);
                    List ld = await lds.read(widget.propId);
                    List cc = await ccs.read(widget.propId);
                    List lms = await locationMapService.read(widget.propId);
                    List ss = await sketchService.read(widget.propId);
                    List ps = await photographService.read(widget.propId);

                    if (pl[0]['PropertyAddressAsPerSite'].toString().isEmpty) {
                      AlertService()
                          .errorToast("Address is mandatory in Property Tab");
                    } else if ((ld[0]['Latitude'].toString().isEmpty ||
                            ld[0]['Latitude'].toString() == '0') &&
                        (ld[0]['Longitude'].toString().isEmpty ||
                            ld[0]['Longitude'].toString() == '0')) {
                      AlertService()
                          .errorToast("Lat & Lon is mandatory in Location Tab");
                    } else if (cc[0]['Comment'].toString().isEmpty) {
                      AlertService()
                          .errorToast("Comment is mandatory in Comment Tab");
                    } else if (lms.isEmpty) {
                      AlertService().errorToast(
                          "Location Photo is mandatory in Location Tab");
                    } else if (ss.isEmpty) {
                      AlertService().errorToast(
                          "Sketch Photo is mandatory in Sketch Tab");
                    } else if (ps.isEmpty) {
                      AlertService().errorToast(
                          "Photograph Photo is mandatory in Photograph Tab");
                    } else {
                      AlertService().hideLoading();
                      alertService.confirmFinalSubmit(
                          context, msg, "Submit", "Review", () async {
                        Navigator.pushNamed(context, "siteVisitForm",
                            arguments: widget.propId.toString());
                      }, () async {
                        PropertyListServices service = PropertyListServices();
                        List request = [
                          Constants.status[2],
                          "N",
                          widget.propId.toString()
                        ];
                        var result = await service.updateLocalStatus(request);
                        if (result == 1) {
                          AlertService().successToast("Status Updated");
                        } else {
                          AlertService().errorToast("Status update Failure!");
                        }
                        Navigator.pushReplacementNamed(context, 'mainPage',
                            arguments: 2);
                      });
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget getTitle(String title, int index) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight:
            index == controller.value ? FontWeight.bold : FontWeight.w600,
        color: index == controller.value ? Colors.white : Colors.black45,
      ),
    );
  }

  void showUploadPictures(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UploadDialog(
          propId: widget.propId,
          title: title,
        );
      },
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      useRootNavigator: false,
      routeSettings: const RouteSettings(name: 'full_screen_dialog'),
    ).then(
      (val) {
        if (val.toString() != "null" && val) {
          getControllerBased();
        }
        // Navigator.pop(context);
      },
    );
  }

  Widget listOfPhotos(list, String title) {
    print("listt" + list.toString());
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
      trailing: IconButton(
        icon: const Icon(
          Icons.delete_outline_outlined,
          size: 25,
          color: Colors.redAccent,
        ),
        onPressed: () async {
          if (title == Constants.photographTitle) {
            AlertService().confirm(
              context,
              "Remove this ${Constants.photographTitle} ?",
              null,
              null,
              () async {
                List updateReq = [
                  "N",
                  "true",
                  "N",
                  list['primaryId'].toString()
                ];
                int result = await photographService.updateIsActive(updateReq);
                print("result $result");
                if (result == 1) {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  getLocationMapDetails(Constants.photographTitle);
                }
              },
            );
          } else if (title == Constants.propertySketchTitle) {
            AlertService().confirm(
              context,
              "Remove this ${Constants.propertySketchTitle} ?",
              null,
              null,
              () async {
                List updateReq = [
                  "N",
                  "true",
                  "N",
                  list['primaryId'].toString()
                ];
                int result = await sketchService.updateIsActive(updateReq);
                if (result == 1) {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  getLocationMapDetails(Constants.propertySketchTitle);
                }
              },
            );
          } else {
            AlertService().confirm(
              context,
              "Remove this ${Constants.locationMapTitle} ?",
              null,
              null,
              () async {
                List updateReq = [
                  "N",
                  "true",
                  "N",
                  list['primaryId'].toString()
                ];
                int result = await locationMapService.updateIsActive(updateReq);
                if (result == 1) {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  getLocationMapDetails(Constants.locationMapTitle);
                }
              },
            );
          }
        },
      ),
    );
  }
}
