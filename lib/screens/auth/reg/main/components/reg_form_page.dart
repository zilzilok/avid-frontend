import 'dart:async';
import 'dart:io';

import 'package:avid_frontend/components/app_utils.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/auth_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/auth/components/fields/input_field.dart';
import 'package:avid_frontend/screens/auth/components/fields/password_field.dart';
import 'package:avid_frontend/screens/auth/components/validator.dart';
import 'package:avid_frontend/screens/auth/reg/info/reg_info_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegFormPage extends StatefulWidget {
  @override
  _RegFormPage createState() => _RegFormPage();
}

class _RegFormPage extends State<RegFormPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _mPasswordController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final _formkey = GlobalKey<FormState>();
  final double _buttonFontSize = 18;

  @override
  void dispose() {
    if (_passwordController != null) _passwordController.dispose();
    if (_mPasswordController != null) _mPasswordController.dispose();
    if (_loginController != null) _loginController.dispose();
    if (_emailController != null) _emailController.dispose();
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
            InputField(
              hintText: "почта",
              controller: _emailController,
              validator: Validator.email(),
            ),
            PasswordField(
              hintText: "придумайте пароль",
              controller: _passwordController,
              validator: Validator.passwordNotEmpty(),
            ),
            PasswordField(
              hintText: "повторите пароль",
              controller: _mPasswordController,
              validator: (String matchingPassword) {
                if (matchingPassword.isEmpty) {
                  return "пароль не может быть пустым";
                }
                if (_passwordController.text != matchingPassword) {
                  return "пароли не совпадают";
                }
                return null;
              },
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
                    var username = _loginController.text.trim();
                    var email = _emailController.text.trim();
                    var password = _passwordController.text;
                    var matchingPassword = _mPasswordController.text;
                    var statusCode = await AuthApi.attemptRegister(
                        username, email, password, matchingPassword);
                    if (statusCode == HttpStatus.ok) {
                      _btnController.success();
                      var jwt = await AuthApi.attemptAuth(username, password);
                      AuthUtils.saveJwt(jwt);
                      Timer(Duration(seconds: 1), () {
                        _btnController.reset();
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            PageTransition(
                                child: RegInfoScreen(),
                                type: PageTransitionType.fade));
                      });
                    } else if (statusCode == HttpStatus.conflict) {
                      _btnController.error();
                      AppUtils.displaySnackBar(context,
                          "Аккаунт с такой почтой или логином уже существует.");
                      Timer(Duration(seconds: 1), () {
                        _btnController.reset();
                      });
                    } else {
                      _btnController.error();
                      AppUtils.displaySnackBar(context, "Ошибка регистрации!");
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
                "создать аккаунт",
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
