import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:proequity/app_theme/custom_theme.dart';

import '../../../app_services/sqlite/sqlite_services.dart';
import '../../../app_widgets/alert_widget.dart';
import '../../../app_widgets/index.dart';

class BoundaryForm extends StatefulWidget {
  final VoidCallback buttonSubmitted;
  final String propId;
  const BoundaryForm(
      {super.key, required this.buttonSubmitted, required this.propId});

  @override
  State<BoundaryForm> createState() => _BoundaryFormState();
}

class _BoundaryFormState extends State<BoundaryForm> {
  TextEditingController eastCtrl = TextEditingController();
  TextEditingController westCtrl = TextEditingController();
  TextEditingController southCtrl = TextEditingController();
  TextEditingController northCtrl = TextEditingController();

  BoundaryServices boundaryServices = BoundaryServices();

  List _bd = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () {
      getBoundaryDetails(widget.propId);
    });
    super.initState();
  }

  getBoundaryDetails(String id) async {
    _bd = await boundaryServices.read(id);
    eastCtrl.text = _bd[0]['East'] ?? '';
    westCtrl.text = _bd[0]['West'];
    southCtrl.text = _bd[0]['South'];
    northCtrl.text = _bd[0]['North'];
    setState(() {});
  }

  @override
  void dispose() {
    Fluttertoast.cancel();
    eastCtrl.dispose();
    westCtrl.dispose();
    southCtrl.dispose();
    northCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomTheme.defaultSize,
                CustomTextFormField(
                  title: 'East',
                  controller: eastCtrl,
                ),
                CustomTheme.defaultSize,
                CustomTextFormField(
                  title: 'West',
                  controller: westCtrl,
                ),
                CustomTheme.defaultSize,
                CustomTextFormField(
                  title: 'South',
                  controller: southCtrl,
                ),
                CustomTheme.defaultSize,
                CustomTextFormField(
                  title: 'North',
                  controller: northCtrl,
                  textInputAction: TextInputAction.done,
                ),
                CustomTheme.defaultSize,
                AppButton(
                    title: "Save & Next",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        List<String> request = [
                          "AsPerSite",
                          eastCtrl.text,
                          westCtrl.text,
                          southCtrl.text,
                          northCtrl.text,
                          'N',
                          widget.propId.toString()
                        ];
                        var result = await boundaryServices.update(request);
                        if (result == 1) {
                          AlertService().successToast("Saved");
                          widget.buttonSubmitted();
                        } else {
                          AlertService().errorToast("Failure!");
                        }
                      } else {
                        AlertService()
                            .errorToast("Please enter valid details!");
                      }
                    }),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )
    );
  }
}
