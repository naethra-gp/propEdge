import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app_config/index.dart';
import '../../../../app_services/sqlite/sqlite_services.dart';
import '../../../../app_storage/local_storage.dart';
import '../../../../app_theme/custom_theme.dart';
import '../../../../app_theme/theme_files/app_color.dart';
import '../../../../app_widgets/alert_widget.dart';
import '../../../../app_widgets/index.dart';

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
  List photolocationList = [];
  UploadLocationMapService uploadLocationMapService =
      UploadLocationMapService();
  SketchService sketchService = SketchService();
  PhotographService photographService = PhotographService();
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
    // print("pp" + photolocationList.length.toString());

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
                    title: "Image Order",
                    controller: imageOrderCtrl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
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
                          color: Colors.black45),
                      // style: CustomTheme.formLabelStyle,
                    ),
                  ),
                  CustomTheme.defaultSize,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.title == Constants.propertySketchTitle ||
                          widget.title == Constants.photographTitle) ...[
                        actionButton(
                            widget.title, Icons.camera_alt_outlined, "Camera"),
                        actionButton(widget.title,
                            Icons.photo_camera_back_outlined, "Gallery")
                      ] else if (photolocationList.isEmpty &&
                          widget.title == Constants.locationMapTitle) ...[
                        actionButton(
                            widget.title, Icons.camera_alt_outlined, "Camera"),
                        actionButton(widget.title,
                            Icons.photo_camera_back_outlined, "Gallery"),
                      ],
                    ],
                  ),
                  CustomTheme.defaultSize,
                  if (photolocationList.isNotEmpty) ...[
                    CustomTheme.defaultSize,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your Photo",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            photolocationList = [];
                            imageCache.clear();
                            setState(() {});
                          },
                          child: const Text(
                            "Remove All",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: photolocationList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                              elevation: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: Image.file(
                                        File(photolocationList[index]),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text(imageDescCtrl.text),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () {
                                            photolocationList.removeAt(index);
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
                          const SizedBox(
                        height: 10,
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  AppButton(
                    title: "Upload",
                    onPressed: () async {
                      if (widget.title.toString() ==
                          Constants.propertySketchTitle) {
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
        AlertService().errorToast('Request Denied!');
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
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
            Icon(icon, size: 40),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Verdana",
                fontWeight: FontWeight.bold,
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
        (folder == Constants.propertySketchTitle ||
            folder == Constants.photographTitle)) {
      final ImagePicker picker = ImagePicker();
      List<XFile> photos = [];
      List<String> imagePaths = [];
      photos = await picker.pickMultiImage();
      if (photos.length <= 1) {
        _cropImage(folder, File(photos[0].path));
      } else {
        for (int i = 0; i < photos.length; i++) {
          imagePaths.add(photos[i].path); // Add image path to the list
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
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Crop your Photo',
        toolbarColor: AppColors.primary,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Crop your Photo',
      ),
    );
    if (croppedFile != null) {
      path = croppedFile.path;
      compress(type, [path]);
    }
  }

  compress(title, List<String> file) async {
    for (int j = 0; j < file.length; j++) {
      var img = File(file[j]);
      print("lengthFile -- $img");
      var result = await FlutterImageCompress.compressAndGetFile(
        img.absolute.path,
        '${img.path}_$title.jpg',
        quality: 50,
      );
//      print("result"+File(result!.path).toString());
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
            photolocationList.add(photoLocation);
            setState(() {});
          } else {
            AlertService().errorToast("Folder not found!");
          }
        } else {
          AlertService().errorToast("File size must be < 1 MB.");
        }
      }
    }
  }

  locationMapUpload(context) async {
    if (photolocationList.isEmpty) {
      AlertService().errorToast("Please Upload Picture");
      return;
    } else {
      for (int i = 0; i < photolocationList.length; i++) {
        var request = {
          "propId": widget.propId,
          "id": "0",
          "imagePath": photolocationList[i].toString(),
          "imageName": imageNameCtrl.text.toString(),
          "imageDesc": imageDescCtrl.text.toString(),
          "imageOrder": imageOrderCtrl.text.toString().isEmpty
              ? "0"
              : imageOrderCtrl.text.toString(),
          "isDeleted": false,
          "isActive": "Y",
        };
        result = await uploadLocationMapService.insertViaApp(request);
        if (!mounted) return;
      }
      dialogClose(context, result);
    }
  }

  propertyUpload(context) async {
    if (photolocationList.isEmpty) {
      AlertService().errorToast("Please Upload Picture");
      return false;
    } else {
      for (int i = 0; i < photolocationList.length; i++) {
        var request = {
          "propId": widget.propId,
          "id": "0",
          "imagePath": photolocationList[i].toString(),
          "imageName": imageNameCtrl.text.toString(),
          "imageDesc": imageDescCtrl.text.toString(),
          "imageOrder": imageOrderCtrl.text.toString().isEmpty
              ? "0"
              : imageOrderCtrl.text.toString(),
          "isDeleted": false,
          "isActive": "Y",
        };
        result = await sketchService.insertViaApp(request);
        // if (!mounted) return;
      }
      dialogClose(context, result);
    }
  }

  photographUpload(context) async {
    if (photolocationList.isEmpty) {
      AlertService().errorToast("Please Upload Picture");
      return;
    } else {
      for (int i = 0; i < photolocationList.length; i++) {
        var request = {
          "propId": widget.propId,
          "id": "0",
          "imagePath": photolocationList[i].toString(),
          "imageName": imageNameCtrl.text.toString(),
          "imageDesc": imageDescCtrl.text.toString(),
          "imageOrder": imageOrderCtrl.text.toString().isEmpty
              ? "0"
              : imageOrderCtrl.text.toString(),
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
      AlertService().successToast("Saved");
      Navigator.pop(context, true);
    } else {
      AlertService().errorToast("Failure!");
    }
  }
}
