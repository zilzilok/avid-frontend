import 'package:avid_frontend/components/rounded_button.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/login/login_screen.dart';
import 'package:avid_frontend/screens/auth/reg/main/reg_screen.dart';
import 'package:avid_frontend/screens/welcome/components/welcome_bg.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class WelcomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            RoundedButton(
              width: size.width * 0.8,
              text: "войти в аккаунт",
              bgColor: kWhiteColor,
              textColor: kPrimaryColor,
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: LoginScreen(),
                        type: PageTransitionType.rightToLeftWithFade));
              },
            ),
            SizedBox(height: size.height * 0.03),
            RoundedButton(
              text: "зарегистрироваться",
              width: size.width * 0.8,
              bgColor: kPrimaryColor,
              borderColor: kWhiteColor,
              textColor: kWhiteColor,
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: RegScreen(),
                        type: PageTransitionType.rightToLeftWithFade));
              },
            ),
            SizedBox(height: size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
