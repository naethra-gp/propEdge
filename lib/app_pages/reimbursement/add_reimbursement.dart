import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prop_edge/app_services/local_db/local_services/dropdown_services.dart';
import 'package:prop_edge/app_utils/alert_service.dart';
import 'package:prop_edge/app_utils/form/custom_single_dropdown.dart';

import '../../app_config/app_constants.dart';
import '../../app_model/reimbursement_req_model.dart';
import '../../app_services/local_db/local_services/local_reimbursement_services.dart';
import '../../app_storage/local_storage.dart';
import '../../app_theme/app_color.dart';
import '../../app_theme/custom_theme.dart';
import '../../app_utils/app/app_bar.dart';
import '../../app_utils/app/app_button_widget.dart';
import '../../app_utils/form/disabled_focus.dart';
import '../../app_utils/form/text_form_widget.dart';

class AddReimbursement extends StatefulWidget {
  final dynamic args;
  const AddReimbursement({super.key, this.args});

  @override
  State<AddReimbursement> createState() => _AddReimbursementState();
}

class _AddReimbursementState extends State<AddReimbursement> {
  LocalReimbursementServices services = LocalReimbursementServices();
  AlertService alertService = AlertService();
  DropdownServices dropdownServices = DropdownServices();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ReimbursementRequestModel _requestModel = ReimbursementRequestModel();
  String title = "New";
  String buttonLabel = "Save";
  DateTime selectedDate = DateTime.now();
  String photoLocation = '';
  bool validURL = false;
  List expenseList = [];

  TextEditingController expenseDateCtrl = TextEditingController();
  TextEditingController noOfDatesCtrl = TextEditingController();
  // TextEditingController expenseCtrl = TextEditingController();
  TextEditingController travelCtrl = TextEditingController();
  TextEditingController totalAmtCtrl = TextEditingController();
  TextEditingController commentsCtrl = TextEditingController();
  TextEditingController billNameCtrl = TextEditingController();

  String? expenseTxt;
  @override
  void initState() {
    // TODO: implement initState

    title = widget.args['primaryId'] == null ? "New" : "Update";
    buttonLabel = widget.args['primaryId'] == null ? "Save" : "Update";
    if (widget.args['primaryId'] != null) {
      expenseDateCtrl.text = widget.args['ExpenseDate'] ?? "";
      noOfDatesCtrl.text = widget.args['NoOfDays'].toString();
      travelCtrl.text = widget.args['TravelAllowance'].toString();
      totalAmtCtrl.text = widget.args['TotalAmount'].toString();
      commentsCtrl.text = widget.args['ExpenseComment'] ?? "";
      billNameCtrl.text = widget.args['BillName'] ?? "";
      _requestModel.id = widget.args['Id'];
      photoLocation = widget.args['BillPath'].toString();
      validURL = Uri.parse(photoLocation).isAbsolute;
    }
    setState(() {});
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    await fetchDropdown();
    if (widget.args['primaryId'] != null) {
      setState(() {
        expenseTxt = widget.args['NatureOfExpense'].toString();
      });
    }
  }

  fetchDropdown() async {
    expenseList = await dropdownServices.readByType('NatureOfExpense');
    debugPrint('--- expenLst $expenseList ------');
    setState(() {});
  }

  itemConvert(List list) {
    return list.map((e) {
      return DropdownMenuItem(
        value: e['Id'].toString(),
        child: Text(
          e['Name'].toString(),
          style: CustomTheme.formFieldStyle,
        ),
      );
    }).toList();
  }

  String? getExpenseName(String natureOfExpenseId) {
    try {
      var matchedExpense = expenseList.firstWhere(
        (expense) => expense['Id'].toString() == natureOfExpenseId,
      );
      return matchedExpense['Name'];
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    expenseDateCtrl.dispose();
    noOfDatesCtrl.dispose();
    // expenseCtrl.dispose();
    travelCtrl.dispose();
    totalAmtCtrl.dispose();
    commentsCtrl.dispose();
    billNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  CustomSingleDropdown(
                    title: 'Nature Of Expense',
                    required: true,
                    items: itemConvert(expenseList),
                    dropdownValue: expenseTxt,
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return 'Mandatory Field!';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        expenseTxt = value.toString();
                        _requestModel.natureOfExpense = value.toString();
                      });
                    },
                  ),
                  CustomTheme.defaultSize,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: CustomTextFormField(
                          title: "Allowance",
                          controller: travelCtrl,
                          textInputAction: TextInputAction.done,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
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
                            if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(value)) {
                              return "Invalid format!";
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
                          required: false,
                          readOnly: true,
                          enabled: false,
                          onSaved: (value) {
                            _requestModel.totalAmount = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTheme.defaultSize,
                  CustomTextFormField(
                    title: "Expense Comment",
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
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
                      ),
                    ),
                    CustomTheme.defaultSize,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        actionButton(Icons.camera_alt_outlined, "Camera"),
                        actionButton(
                            Icons.photo_camera_back_outlined, "Gallery"),
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
                        padding: EdgeInsets.all(0.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        height: 300,
                        // width: 600,
                        alignment: Alignment.center,
                        child: Image.network(
                          photoLocation,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                    if (!validURL) ...[
                      Container(
                        height: 200,
                        // width: 600,
                        padding: EdgeInsets.all(0.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Image.file(
                          File(photoLocation.toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                  CustomTheme.defaultSize,
                  AppButton(
                    title: "$buttonLabel Details",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        dynamic response;
                        _formKey.currentState!.save();
                        _requestModel.id = _requestModel.id ?? "0";
                        _requestModel.expenseDate = expenseDateCtrl.text;
                        _requestModel.billPath = photoLocation;
                        _requestModel.isActive = "Y";
                        _requestModel.syncStatus = "N";
                        _requestModel.billBase64String = "";
                        _requestModel.natureOfExpense = expenseTxt;
                        String message = '';
                        if (buttonLabel == "Save") {
                          response =
                              services.insertFromApp(jsonEncode(_requestModel));
                          message = "Your data saved successfully.";
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
                          message = "Your data updated successfully.";
                        }
                        if (response != 0) {
                          alertService.successToast(message);
                          await clearAllCache();
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                              context, "mainPage", arguments: 3, (r) => false);
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
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        backgroundColor:
            WidgetStatePropertyAll(AppColors.primary.withAlpha(220)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color: AppColors.primary.withAlpha(128),
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Icon(icon, size: 35, color: Colors.white),
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
      uiSettings: <PlatformUiSettings>[
        AndroidUiSettings(
          toolbarTitle: 'Crop your image',
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
        var cf = await LocalStorage.getReimbursementFolder();
        DateTime now = DateTime.now();
        String fileName =
            "${now.day}_${now.month}_${now.year}_${now.hour}_${now.minute}_${now.second}_${now.millisecond}";
        final String fileExtension = extension(file1.path);
        if (cf != null) {
          tmpFile = await tmpFile.copy('${cf.path}$fileName$fileExtension');
          photoLocation = "${cf.path}$fileName$fileExtension";
          validURL = false;
          setState(() {});
        }
      } else {
        AlertService().errorToast("Folder not found!");
      }
    } else {
      AlertService().errorToast("File size must be < 1 MB.");
    }
  }

  // Clear cache
  Future<void> clearAllCache() async {
    final tempDir = await getTemporaryDirectory();
    final cacheDir = await getApplicationCacheDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
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
      });
    }
  }
}
