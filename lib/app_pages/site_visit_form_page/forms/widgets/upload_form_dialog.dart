import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prop_edge/app_utils/alert_service.dart';

import '../../../../app_config/app_constants.dart';
import '../../../../app_services/local_db/local_services/local_services.dart';
import '../../../../app_storage/local_storage.dart';
import '../../../../app_theme/app_color.dart';
import '../../../../app_theme/custom_theme.dart';
import '../../../../app_utils/app/app_bar.dart';
import '../../../../app_utils/app/app_button_widget.dart';
import '../../../../app_utils/form/text_form_widget.dart';

class UploadDialog extends StatefulWidget {
  final String propId;
  final String title;
  const UploadDialog({super.key, required this.propId, required this.title});

  @override
  State<UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  TextEditingController imageNameCtrl = TextEditingController();
  TextEditingController imageOrderCtrl = TextEditingController();
  TextEditingController imageDescCtrl = TextEditingController();

  String photoLocation = '';
  List photoLocationList = [];
  LocationMapService locationMapService = LocationMapService();
  PlanService planService = PlanService();
  PhotographService photographService = PhotographService();
  AlertService alertService = AlertService();
  var result;

  @override
  void initState() {
    checkPermission();
    DateTime now = DateTime.now();
    String fileName =
        "${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_${now.second}_${now.millisecond}";
    imageNameCtrl.text =
        "${widget.title.toString().replaceAll(" ", "_")}_$fileName";
    imageDescCtrl.text = fileName;
    // print("pp" + photoLocationList.length.toString());

    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    imageNameCtrl.dispose();
    imageOrderCtrl.dispose();
    imageDescCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBarWidget(
              title: 'Uploads ${widget.title}',
              action: false,
            ),
            CustomTheme.defaultSize,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  CustomTextFormField(
                    title: "Image Name",
                    controller: imageNameCtrl,
                  ),
                  CustomTheme.defaultSize,
                  CustomTextFormField(
                    title: "Image Description",
                    controller: imageDescCtrl,
                  ),
                  CustomTheme.defaultSize,
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Select Upload Option",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                      // style: CustomTheme.formLabelStyle,
                    ),
                  ),
                  CustomTheme.defaultSize,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.title == Constants.propertyPlanTitle ||
                          widget.title == Constants.photographTitle) ...[
                        actionButton(
                            widget.title, Icons.camera_alt_outlined, "Camera"),
                        actionButton(widget.title,
                            Icons.photo_camera_back_outlined, "Gallery")
                      ] else if (photoLocationList.isEmpty &&
                          widget.title == Constants.locationMapTitle) ...[
                        actionButton(
                            widget.title, Icons.camera_alt_outlined, "Camera"),
                        actionButton(widget.title,
                            Icons.photo_camera_back_outlined, "Gallery"),
                      ],
                    ],
                  ),
                  CustomTheme.defaultSize,
                  if (photoLocationList.isNotEmpty) ...[
                    CustomTheme.defaultSize,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your Photo",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            photoLocationList = [];
                            imageCache.clear();
                            setState(() {});
                          },
                          child: const Text(
                            "Remove All",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: photoLocationList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  )),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 5),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: Image.file(
                                        File(photoLocationList[index]),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        imageNameCtrl.text,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            photoLocationList.removeAt(index);
                                          },
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10),
                    ),
                  ],
                  const SizedBox(height: 10),
                  AppButton(
                    title: "Upload",
                    onPressed: () async {
                      if (widget.title.toString() ==
                          Constants.propertyPlanTitle) {
                        propertyUpload(context);
                      } else if (widget.title.toString() ==
                          Constants.locationMapTitle) {
                        locationMapUpload(context);
                      } else if (widget.title.toString() ==
                          Constants.photographTitle) {
                        photographUpload(context);
                      }
                    },
                  ),
                  CustomTheme.defaultSize,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      var request = await Permission.camera.request();
      if (request == PermissionStatus.granted) {
        alertService.errorToast('Request Denied!');
      }
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  /// ACTION BUTTON CAMERA/GALLERY
  Widget actionButton(String title, IconData icon, String label) {
    return ElevatedButton(
      onPressed: () async {
        if (label == "Camera") {
          uploadAction(title, ImageSource.camera);
        } else {
          uploadAction(title, ImageSource.gallery);
        }
      },
      style: ButtonStyle(
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                // letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// UPLOAD ACTION [CAMERA or GALLERY]
  uploadAction(String folder, ImageSource src) async {
    final ImagePicker picker = ImagePicker();
    if (src == ImageSource.camera) {
      XFile? photo = await picker.pickImage(source: src);
      if (photo != null) {
        _cropImage(folder, File(photo.path));
      }
    } else if (src == ImageSource.gallery &&
        (folder == Constants.propertyPlanTitle ||
            folder == Constants.photographTitle)) {
      final ImagePicker picker = ImagePicker();
      List<XFile> photos = [];
      List<String> imagePaths = [];
      photos = await picker.pickMultiImage();
      if (photos.length <= 1) {
        _cropImage(folder, File(photos[0].path));
      } else {
        for (int i = 0; i < photos.length; i++) {
          imagePaths.add(photos[i].path);
        }
        compress(folder, imagePaths);
      }
    } else if (src == ImageSource.gallery &&
        folder == Constants.locationMapTitle) {
      final ImagePicker picker = ImagePicker();
      XFile? photo = await picker.pickImage(source: src);
      if (photo != null) {
        _cropImage(folder, File(photo.path));
      }
    }
  }

  _cropImage(String type, pickedFile) async {
    late String path;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: 'Crop your Photo',
          statusBarColor: AppColors.primary,
          activeControlsWidgetColor: AppColors.primary,
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop your Photo',
        ),
      ],
    );
    if (croppedFile != null) {
      path = croppedFile.path;
      compress(type, [path]);
    }
  }

  compress(title, List<String> file) async {
    for (int j = 0; j < file.length; j++) {
      var img = File(file[j]);
      var result = await FlutterImageCompress.compressAndGetFile(
        img.absolute.path,
        '${img.path}_$title.jpg',
        quality: 50,
      );
      if (result != null) {
        var newPath = result.path;
        final file1 = File(newPath);
        File tmpFile = File(newPath);
        int sizeInBytes = file1.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb < 1) {
          // Directory cf = Directory('${Constants.folder.path}/$title/${widget.propId}/');
          // print("cf: $cf");
          // if (!await Directory(cf.path).exists()) {
          //   await cf.create(recursive: true);
          // }
          var cf =
              await LocalStorage.getSiteVisitFolder("$title/${widget.propId}");
          Random random = Random();
          int randomNumber = random.nextInt(100) + 1;
          final String fileName = imageNameCtrl.text + randomNumber.toString();
          final String fileExtension = extension(file1.path);

          if (cf != null) {
            tmpFile = await tmpFile.copy('${cf.path}$fileName$fileExtension');
            photoLocation = "${cf.path}$fileName$fileExtension";
            photoLocationList.add(photoLocation);
            setState(() {});
          } else {
            alertService.errorToast("Folder not found!");
          }
        } else {
          alertService.errorToast("File size must be < 1 MB.");
        }
      }
    }
  }

  locationMapUpload(context) async {
    if (photoLocationList.isEmpty) {
      alertService.errorToast("Kindly upload a picture!");
      return;
    } else {
      for (int i = 0; i < photoLocationList.length; i++) {
        var request = {
          "propId": widget.propId,
          "id": "0",
          "imagePath": photoLocationList[i].toString(),
          "imageName": imageNameCtrl.text.toString(),
          "imageDesc": imageDescCtrl.text.toString(),
          "isDeleted": false,
          "isActive": "Y",
        };
        result = await locationMapService.insertViaApp(request);
        if (!mounted) return;
      }
      dialogClose(context, result);
    }
  }

  propertyUpload(context) async {
    if (photoLocationList.isEmpty) {
      alertService.errorToast("Please Upload Picture");
      return false;
    } else {
      for (int i = 0; i < photoLocationList.length; i++) {
        var request = {
          "propId": widget.propId,
          "id": "0",
          "imagePath": photoLocationList[i].toString(),
          "imageName": imageNameCtrl.text.toString(),
          "imageDesc": imageDescCtrl.text.toString(),
          "isDeleted": false,
          "isActive": "Y",
        };
        result = await planService.insertViaApp(request);
        // if (!mounted) return;
      }
      dialogClose(context, result);
    }
  }

  photographUpload(context) async {
    if (photoLocationList.isEmpty) {
      alertService.errorToast("Please Upload Picture");
      return;
    } else {
      for (int i = 0; i < photoLocationList.length; i++) {
        var request = {
          "propId": widget.propId,
          "id": "0",
          "imagePath": photoLocationList[i].toString(),
          "imageName": imageNameCtrl.text.toString(),
          "imageDesc": imageDescCtrl.text.toString(),
          "isDeleted": false,
          "isActive": "Y",
        };
        result = await photographService.insertViaApp(request);
        if (!mounted) return;
      }
      dialogClose(context, result);
    }
  }

  dialogClose(BuildContext context, result) {
    if (result == true) {
      alertService.successToast("File saved successfully.");
      Navigator.pop(context, true);
    } else {
      alertService.errorToast("File saved failed!");
    }
  }
}
