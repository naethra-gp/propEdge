import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proequity/app_widgets/alert_widget.dart';

import '../../../app_services/sqlite/comments_services.dart';
import '../../../app_theme/custom_theme.dart';
import '../../../app_widgets/index.dart';

class CriticalComments extends StatefulWidget {
  final VoidCallback buttonSubmitted;
  final String propId;
  const CriticalComments(
      {super.key, required this.buttonSubmitted, required this.propId});

  @override
  State<CriticalComments> createState() => _CriticalCommentsState();
}

class _CriticalCommentsState extends State<CriticalComments> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CommentsServices commentsServices = CommentsServices();
  TextEditingController controller = TextEditingController();
  AlertService alertService = AlertService();
  List comments = [];

  @override
  void initState() {
    getComments();
    super.initState();
  }

  Future<void> getComments() async {
    comments = await commentsServices.read(widget.propId);
    controller.text = comments[0]['Comment'].toString();
    setState(() {});
  }

  @override
  void dispose() {
    Fluttertoast.cancel();

    // TODO: implement dispose
    super.dispose();
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
              CustomTextFormField(
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
                textInputAction: TextInputAction.done,
              ),
              CustomTheme.defaultSize,
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
                      alertService.successToast("Comments Saved");
                      widget.buttonSubmitted();
                    } else {
                      alertService.errorToast("Comments Failure!");
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
