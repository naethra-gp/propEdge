import 'package:flutter/material.dart';

import '../../../app_services/local_db/local_services/comment_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_utils/alert_service.dart';
import '../../../app_utils/app/app_button_widget.dart';
import '../../../app_utils/form/text_form_widget.dart';

class CommentsForm extends StatefulWidget {
  final VoidCallback buttonClicked;
  final String propId;
  const CommentsForm(
      {super.key, required this.buttonClicked, required this.propId});

  @override
  State<CommentsForm> createState() => _CommentsFormState();
}

class _CommentsFormState extends State<CommentsForm> {
  /// GLOBAL DECLARATION
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CommentsServices commentsServices = CommentsServices();
  TextEditingController controller = TextEditingController();
  AlertService alertService = AlertService();
  List comments = [];

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  /// Initial Fetch of Comment Details
  fetchDetails() async {
    List a = await commentsServices.read(widget.propId);
    controller.text = a[0]['Comment'].toString().trim();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomTheme.defaultSize,

              /// Comment - Field
              CustomTextFormField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.none,
                required: true,
                title: 'Critical Comments',
                controller: controller,
                maxLength: 2000,
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.toString().trim().isEmpty) {
                    return 'Comments is Mandatory!';
                  }
                  return null;
                },
              ),
              CustomTheme.defaultSize,

              /// Save Comment Details
              AppButton(
                title: "Save & Next",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    List<String> request = [
                      controller.text.toString().trim(),
                      'N',
                      widget.propId.toString()
                    ];
                    var result = await commentsServices.update(request);
                    if (result == 1) {
                      alertService.successToast("Comments saved successfully.");
                      widget.buttonClicked();
                    } else {
                      alertService.errorToast("Comments saved failed!");
                    }
                  }
                },
              ),
              CustomTheme.defaultSize,
            ],
          ),
        ),
      ),
    );
  }
}
