import 'package:flutter/material.dart';

import '../../../app_config/app_constants.dart';

class LoginHeaderBg extends StatelessWidget {
  const LoginHeaderBg({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.3,
      child: Container(
        height: 600,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Constants.loginBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            Constants.appLogo,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
