import 'dart:async';

import 'package:avid_frontend/components/app_utils.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/auth_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/auth/components/fields/input_field.dart';
import 'package:avid_frontend/screens/auth/components/fields/password_field.dart';
import 'package:avid_frontend/screens/auth/components/validator.dart';
import 'package:avid_frontend/screens/main/app.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginFormPage extends StatefulWidget {
  @override
  _LoginFormPageState createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final _formkey = GlobalKey<FormState>();
  final double _buttonFontSize = 18;

  @override
  void dispose() {
    if (_passwordController != null) _passwordController.dispose();
    if (_loginController != null) _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            InputField(
              hintText: "логин",
              controller: _loginController,
              validator: Validator.login(),
            ),
            PasswordField(
              hintText: "пароль",
              controller: _passwordController,
              validator: Validator.passwordNotEmpty(),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedLoadingButton(
              height: _buttonFontSize + 40,
              controller: _btnController,
              borderRadius: 29,
              color: kPrimaryColor,
              errorColor: Colors.red,
              successColor: Colors.green,
              onPressed: () async {
                if (_formkey.currentState.validate()) {
                  var connectivityResult =
                      await Connectivity().checkConnectivity();
                  if (connectivityResult != ConnectivityResult.none) {
                    var username = _loginController.text;
                    var password = _passwordController.text;
                    var jwt = await AuthApi.attemptAuth(username, password);
                    if (jwt != null) {
                      _btnController.success();
                      Timer(Duration(seconds: 1), () {
                        _btnController.reset();
                        AuthUtils.saveJwt(jwt);
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AppScreen(),
                                type: PageTransitionType.fade));
                      });
                    } else {
                      _btnController.error();
                      AppUtils.displaySnackBar(context,
                          "Аккаунта с такими данными не было найдено.");
                      Timer(Duration(seconds: 1), () {
                        _btnController.reset();
                      });
                    }
                  } else {
                    _btnController.error();
                    AppUtils.displaySnackBar(
                        context, "Отсутствует подключение к интернету.");
                    Timer(Duration(seconds: 1), () {
                      _btnController.reset();
                    });
                  }
                } else {
                  _btnController.error();
                  Timer(Duration(seconds: 1), () {
                    _btnController.reset();
                  });
                }
              },
              child: Text(
                "войти",
                style: GoogleFonts.montserrat(
                  color: kWhiteColor,
                  fontSize: _buttonFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
