import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proequity/app_config/app_constants.dart';
import 'package:proequity/app_theme/custom_theme.dart';
import '../../app_model/reimbursement_req_model.dart';
import '../../app_services/sqlite/reimbursement_services.dart';
import '../../app_theme/theme_files/app_color.dart';
import '../../app_widgets/alert_widget.dart';
import '../../app_widgets/index.dart';
import 'package:intl/intl.dart';

class ReimbursementForm extends StatefulWidget {
  final dynamic args;
  const ReimbursementForm({super.key, required this.args});

  @override
  State<ReimbursementForm> createState() => _ReimbursementFormState();
}

class _ReimbursementFormState extends State<ReimbursementForm> {
  String title = "New";
  String buttonLabel = "New";

  final _formKey = GlobalKey<FormState>();
  final ReimbursementRequestModel _requestModel = ReimbursementRequestModel();

  ReimbursementServices services = ReimbursementServices();
  AlertService alertService = AlertService();
  TextEditingController expenseDateCtrl = TextEditingController();
  TextEditingController noOfDatesCtrl = TextEditingController();
  TextEditingController expenseCtrl = TextEditingController();
  TextEditingController travelCtrl = TextEditingController();
  TextEditingController totalAmtCtrl = TextEditingController();
  TextEditingController commentsCtrl = TextEditingController();
  TextEditingController billNameCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String photoLocation = '';
  bool validURL = false;

  @override
  void initState() {
    title = widget.args['primaryId'] == null ? "New" : "Update";
    buttonLabel = widget.args['primaryId'] == null ? "Save" : "Update";
    if (widget.args['primaryId'] != null) {
      expenseDateCtrl.text = widget.args['ExpenseDate'] ?? "";
      noOfDatesCtrl.text = widget.args['NoOfDays'].toString();
      expenseCtrl.text = widget.args['NatureOfExpense'].toString();
      travelCtrl.text = widget.args['TravelAllowance'].toString();
      totalAmtCtrl.text = widget.args['TotalAmount'].toString();
      commentsCtrl.text = widget.args['ExpenseComment'] ?? "";
      billNameCtrl.text = widget.args['BillName'] ?? "";
      _requestModel.id = widget.args['Id'];
      photoLocation = widget.args['BillPath'].toString();
      validURL = Uri.parse(photoLocation).isAbsolute;
    }
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    expenseDateCtrl.dispose();
    noOfDatesCtrl.dispose();
    expenseCtrl.dispose();
    travelCtrl.dispose();
    totalAmtCtrl.dispose();
    commentsCtrl.dispose();
    billNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        String fd = DateFormat('dd-MMM-yyyy').format(picked);
        selectedDate = picked;
        expenseDateCtrl.text = fd;
        // expenseDateCtrl.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "$title Reimbursement",
        action: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                CustomTheme.defaultHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: CustomTextFormField(
                        title: "Expense Date",
                        controller: expenseDateCtrl,
                        required: true,
                        focusNode: AlwaysDisabledFocusNode(),
                        // readOnly: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mandatory field!";
                          }
                          return null;
                        },
                        onTap: () => _selectDate(context),
                        onSaved: (value) {
                          _requestModel.expenseComment = expenseDateCtrl.text;
                        },
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: CustomTextFormField(
                        title: "Number Of Days",
                        controller: noOfDatesCtrl,
                        maxLength: 2,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        required: true,
                        onSaved: (value) {
                          _requestModel.noOfDays = value;
                        },
                        validator: (value) {
                          if (value.toString().trim().isEmpty) {
                            return "Mandatory field!";
                          }
                          if (value == "00" || value == "0") {
                            return "Invalid value!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                CustomTheme.defaultSize,
                CustomTextFormField(
                  title: "Nature Of Expense",
                  controller: expenseCtrl,
                  required: true,
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Mandatory field!";
                    }
                    if (value == "00" || value == "0") {
                      return "Invalid value!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _requestModel.natureOfExpense = value;
                  },
                ),
                CustomTheme.defaultSize,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: CustomTextFormField(
                        title: "Travel Allowance",
                        controller: travelCtrl,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        required: true,
                        onChanged: (val) {
                          setState(() {
                            totalAmtCtrl.text = val;
                          });
                        },
                        onSaved: (value) {
                          _requestModel.travelAllowance = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mandatory field!";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: CustomTextFormField(
                        title: "Total Amount",
                        controller: totalAmtCtrl,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        required: true,
                        readOnly: true,
                        enabled: false,
                        onSaved: (value) {
                          _requestModel.totalAmount = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mandatory field!";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                CustomTheme.defaultSize,
                CustomTextFormField(
                  title: "Expense Comment",
                  controller: commentsCtrl,
                  onSaved: (value) {
                    _requestModel.expenseComment = value;
                  },
                  maxLines: 2,
                ),
                CustomTheme.defaultSize,
                CustomTextFormField(
                  title: "Bill Name",
                  controller: billNameCtrl,
                  required: true,
                  onSaved: (value) {
                    _requestModel.billName = value;
                  },
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Mandatory field!";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
                if (photoLocation.isEmpty) ...[
                  CustomTheme.defaultSize,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Upload Option",
                      style: CustomTheme.formLabelStyle,
                      // style: CustomTheme.formLabelStyle,
                    ),
                  ),
                  CustomTheme.defaultSize,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      actionButton(Icons.camera_alt_outlined, "Camera"),
                      actionButton(Icons.photo_camera_back_outlined, "Gallery"),
                    ],
                  ),
                ],
                if (photoLocation.isNotEmpty) ...[
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
                          photoLocation = '';
                          imageCache.clear();
                          setState(() {});
                        },
                        child: const Text(
                          "Remove",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (validURL) ...[
                    Container(
                      height: 300,
                      width: 600,
                      alignment: Alignment.center,
                      child: Image.network(
                        photoLocation,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                  if (!validURL) ...[
                    Container(
                      height: 300,
                      width: 600,
                      alignment: Alignment.center,
                      child: Image.file(
                        File(photoLocation.toString()),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ],
                CustomTheme.defaultSize,
                AppButton(
                  title: "$buttonLabel Details",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      dynamic response;
                      _formKey.currentState!.save();
                      _requestModel.id = _requestModel.id ?? "0";
                      _requestModel.expenseDate = expenseDateCtrl.text;
                      _requestModel.billPath = photoLocation;
                      _requestModel.isActive = "Y";
                      _requestModel.syncStatus = "N";
                      _requestModel.billBase64String = "";
                      if (buttonLabel == "Save") {
                        response =
                            services.insertFromApp(jsonEncode(_requestModel));
                      } else {
                        List request = [
                          _requestModel.id.toString(),
                          _requestModel.expenseDate.toString(),
                          _requestModel.natureOfExpense.toString(),
                          _requestModel.noOfDays.toString(),
                          _requestModel.travelAllowance.toString(),
                          _requestModel.totalAmount.toString(),
                          _requestModel.expenseComment.toString(),
                          _requestModel.billPath.toString(),
                          _requestModel.billName.toString(),
                          _requestModel.billBase64String.toString(),
                          _requestModel.isActive.toString(),
                          _requestModel.syncStatus.toString(),
                          widget.args['primaryId'].toString()
                        ];
                        response = services.updateFromApp(request);
                      }
                      if (response != 0) {
                        alertService.successToast(Constants.successMessage);
                          Navigator.pushReplacementNamed(context, "mainPage",
                              arguments: 3);
                      } else {
                        alertService.errorToast(Constants.errorMessage);
                      }
                    }
                  },
                ),
                CustomTheme.defaultSize,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, String label) {
    return ElevatedButton(
      onPressed: () async {
        if (label == "Camera") {
          uploadAction(ImageSource.camera);
        } else {
          uploadAction(ImageSource.gallery);
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
        padding: const EdgeInsets.all(5),
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
  uploadAction(ImageSource src) async {
    final ImagePicker picker = ImagePicker();
    XFile? photo = await picker.pickImage(source: src);
    if (photo != null) {
      _cropImage(File(photo.path));
    }
  }

  _cropImage(pickedFile) async {
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
      compress(File(path));
    }
  }

  compress(File file) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      '${file.path}_.jpg',
      quality: 50,
    );
    if (result != null) {
      var newPath = result.path;
      final file1 = File(newPath);
      File tmpFile = File(newPath);
      int sizeInBytes = file1.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      if (sizeInMb < 1) {
        if (await Permission.manageExternalStorage.request().isGranted ||
            await Permission.storage.request().isGranted) {
          final Directory createFolder =
              Directory('/storage/emulated/0/PropEdge/Reimbursement/');
          final checkPathExistence =
              await Directory(createFolder.path).exists();
          if (!checkPathExistence) {
            await createFolder.create(recursive: true);
          }

          DateTime now = DateTime.now();
          String fileName =
              "${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_${now.second}_${now.millisecond}";
          final String fileExtension = extension(file1.path);
          tmpFile =
              await tmpFile.copy('${createFolder.path}$fileName$fileExtension');
          photoLocation = "${createFolder.path}$fileName$fileExtension";
          validURL = false;
          setState(() {});
        }
      } else {
        AlertService().errorToast("File size must be < 1 MB.");
      }
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
