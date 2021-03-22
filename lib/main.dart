import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/auth/login/login_screen.dart';
import 'package:avid_frontend/screens/main/app.dart';
import 'package:avid_frontend/screens/other/load/load_screen.dart';
import 'package:avid_frontend/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'file:///C:/sharaga/java/avid/avid_frontend/lib/screens/other/error/error_screen.dart';

void main() {
  runApp(Phoenix(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: kPrimaryAccentColor,
        primarySwatch: kPrimaryColor,
        scaffoldBackgroundColor: kWhiteColor,
      ),
      home: FutureBuilder(
        future: AuthUtils.checkJwt,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case JwtStatus.CORRECT:
                return AppScreen();
              case JwtStatus.INCORRECT:
                return LoginScreen();
              default:
                return WelcomeScreen();
            }
          } else if (snapshot.hasError) {
            return ErrorScreen(
              title: "Ошибка!",
              message: "Возможно отсутствует подключение к интернету.",
            );
          } else {
            return LoadScreen();
          }
        },
      ),
    );
  }
}
