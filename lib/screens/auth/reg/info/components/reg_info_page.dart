import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/components/app_utils.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/auth/components/fields/avatar_field.dart';
import 'package:avid_frontend/screens/auth/components/fields/date_field.dart';
import 'package:avid_frontend/screens/auth/components/fields/gender_field.dart';
import 'package:avid_frontend/screens/auth/components/fields/input_field.dart';
import 'package:avid_frontend/screens/auth/components/validator.dart';
import 'package:avid_frontend/screens/auth/login/login_screen.dart';
import 'package:avid_frontend/screens/main/app.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegInfoFormPage extends StatefulWidget {
  @override
  _RegInfoFormPage createState() => _RegInfoFormPage();
}

class _RegInfoFormPage extends State<RegInfoFormPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _secondNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _imageController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  final _formkey = GlobalKey<FormState>();
  final double _buttonFontSize = 18;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_firstNameController != null) _firstNameController.dispose();
    if (_secondNameController != null) _secondNameController.dispose();
    if (_genderController != null) _genderController.dispose();
    if (_dateController != null) _dateController.dispose();
    if (_imageController != null) _imageController.dispose();
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
            AvatarField(imageController: _imageController),
            InputField(
              hintText: "имя",
              controller: _firstNameController,
              validator: Validator.notEmpty(),
            ),
            InputField(
              hintText: "фамилия",
              controller: _secondNameController,
              validator: Validator.notEmpty(),
            ),
            Text(
              "дата рождения",
              style:
                  GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
            ),
            DateField(dateController: _dateController),
            Text("пол",
                style: GoogleFonts.montserrat(
                    fontSize: 16, color: kTextGreyColor)),
            GenderField(genderController: _genderController),
            SizedBox(height: size.height * 0.03),
            RoundedLoadingButton(
              height: _buttonFontSize + 40,
              controller: _btnController,
              borderRadius: 29,
              color: kPrimaryColor,
              errorColor: Colors.red,
              successColor: Colors.green,
              onPressed: () async {
                var firstName = _firstNameController.text.trim();
                var secondName = _secondNameController.text.trim();
                var gender =
                    _genderController.text == "муж." ? "MALE" : "FEMALE";
                var date = _dateController.text;
                var fileName = _imageController.text;

                log(firstName);
                log(secondName);
                log(gender);
                log(date);
                log(fileName);

                if (_formkey.currentState.validate()) {
                  var connectivityResult =
                      await Connectivity().checkConnectivity();

                  if (connectivityResult != ConnectivityResult.none) {
                    var statusCode;
                    try{
                       statusCode = await UserApi.updateUserInfo(
                          firstName, secondName, gender, date, fileName);
                    }catch(e){
                      log(e.toString());
                      AuthUtils.deleteJwt();
                      Phoenix.rebirth(context);
                    }

                    if (statusCode == HttpStatus.ok) {
                      _btnController.success();
                      Timer(Duration(seconds: 1), () {
                        _btnController.reset();
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AppScreen(),
                                type: PageTransitionType.fade));
                      });
                    } else {
                      _btnController.error();
                      AppUtils.displaySnackBar(context, "Ошибка добавления информации!");
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
                  _btnController.reset();
                } else {
                  _btnController.error();
                  Timer(Duration(seconds: 1), () {
                    _btnController.reset();
                  });
                }
              },
              child: Text(
                "продолжить",
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
