import 'dart:async';
import 'dart:convert';
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
import 'package:avid_frontend/screens/main/profile/components/profile_bg.dart';
import 'package:avid_frontend/screens/main/profile/components/user_dto.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ProfileUpdatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _secondNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _imageController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ProfileBackground(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, right: 5, bottom: 10),
                width: size.width,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_sharp,
                      size: size.width * 0.1,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: SafeArea(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: size.width * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: size.height * 0.01),
                            Text(
                              "Редактирование профиля",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Expanded(
                              child: SingleChildScrollView(
                                child: _buildProfileInfo(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder _buildProfileInfo() {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: UserApi.getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var res = snapshot.data as Response;
          if (res.statusCode == HttpStatus.forbidden ||
              res.statusCode == HttpStatus.unauthorized) {
            AuthUtils.deleteJwt();
            Phoenix.rebirth(context);
          }
          if (res.statusCode == HttpStatus.ok) {
            var user = UserDao.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
            _imageController.text = user.photoPath;
            _firstNameController.text = user.firstName;
            _secondNameController.text = user.secondName;
            _dateController.text = user.birthdate;
            _genderController.text = user.gender == "MALE" ? "муж." : "жен.";

            return Form(
              key: _formkey,
              child: Column(
                children: [
                  AvatarField(imageController: _imageController, network: true,),
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
                          var statusCode = await UserApi.updateUserInfo(
                              firstName, secondName, gender, date, fileName);

                          if (statusCode == HttpStatus.forbidden ||
                              statusCode == HttpStatus.unauthorized) {
                            AuthUtils.deleteJwt();
                            Phoenix.rebirth(context);
                          }

                          if (statusCode == HttpStatus.ok) {
                            _btnController.success();
                            Timer(Duration(seconds: 1), () {
                              _btnController.reset();
                              Navigator.pop(context);
                            });
                          } else {
                            _btnController.error();
                            AppUtils.displaySnackBar(
                                context, "Ошибка обновления информации!");
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
                      "обновить",
                      style: GoogleFonts.montserrat(
                        color: kWhiteColor,
                        fontSize: _buttonFontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            );
          }
        }
        return SizedBox(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
          width: 40,
          height: 40,
        );
      },
    );
  }
}
