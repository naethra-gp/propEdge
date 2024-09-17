import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../app_storage/secure_storage.dart';

class AlertService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  showLoading([String? title]) async {
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.fadingCircle;
    EasyLoading.instance.toastPosition = EasyLoadingToastPosition.center;
    EasyLoading.instance.animationStyle = EasyLoadingAnimationStyle.scale;
    return await EasyLoading.show(
      status: title ?? 'Please wait...',
      maskType: EasyLoadingMaskType.black,
      dismissOnTap: true,
    );
  }

  hideLoading() async {
    return await EasyLoading.dismiss();
  }

  // TOAST
  errorToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 12.0,
    );
  }

  successToast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 12.0);
  }

  toast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 12.0);
  }

  unAuthorizedAlert(String? title, String message) {
    return PanaraInfoDialog.showAnimatedGrow(
      navigatorKey.currentState!.overlay!.context,
      title: title.toString(),
      barrierDismissible: false,
      color: Theme.of(navigatorKey.currentState!.overlay!.context).primaryColor,
      message: message.toString(),
      buttonText: "Okay",
      onTapDismiss: () {
        BoxStorage secureStorage = BoxStorage();
        secureStorage.deleteUserDetails();
        Navigator.pushNamedAndRemoveUntil(
            navigatorKey.currentState!.overlay!.context,
            'login',
            (route) => false);
      },
      panaraDialogType: PanaraDialogType.error,
    );
  }

  confirmAlert(String message, VoidCallback confirmPressed) {
    return showDialog<String>(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Please Confirm',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            decoration: TextDecoration.underline,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
        ),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text(
                  "Cancel",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              TextButton(
                // style: TextButton.styleFrom(
                //   textStyle: Theme.of(context).textTheme.labelLarge,
                //   backgroundColor: Theme.of(context).primaryColor,
                //   foregroundColor: Colors.white,
                //   shape: const RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                //   ),
                // ),
                onPressed: confirmPressed,
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  confirm(ctx, String msg, String? confirmLabel, String? cancelLabel,
      VoidCallback onPressed) {
    return showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Confirm',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              decoration: TextDecoration.underline),
        ),
        content: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
        ),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text(
                  cancelLabel ?? 'No',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              SizedBox(
                height: 35,
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    confirmLabel ?? 'Yes',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  confirmFinalSubmit(ctx, String msg, String? confirmLabel, String? cancelLabel,
  VoidCallback reviewPressed, VoidCallback onPressed) {
    return showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Confirm',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              decoration: TextDecoration.underline),
        ),
        content: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
        ),
        actions: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                onPressed : reviewPressed,
                child: Text(
                  cancelLabel ?? 'No',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 35,
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    confirmLabel ?? 'Yes',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  alert(
    ctx,
    String msg,
  ) {
    return showDialog<String>(
      context: ctx,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Alert',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
              decoration: TextDecoration.underline),
        ),
        content: Text(
          msg,
          style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 14),
        ),
        actions: <Widget>[
          SizedBox(
            height: 35,
            child: TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Ok',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
