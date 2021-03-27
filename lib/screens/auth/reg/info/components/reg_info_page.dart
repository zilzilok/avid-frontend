import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/components/fields/avatar_field.dart';
import 'package:avid_frontend/screens/auth/components/fields/date_field.dart';
import 'package:avid_frontend/screens/auth/components/fields/gender_field.dart';
import 'package:avid_frontend/screens/auth/components/fields/input_field.dart';
import 'package:avid_frontend/screens/auth/components/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              validator: Validator.login(),
            ),
            InputField(
              hintText: "фамилия",
              controller: _secondNameController,
              validator: Validator.email(),
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
                log(_firstNameController.text);
                log(_secondNameController.text);
                log(_genderController.text);
                log(_dateController.text);
                log(_imageController.text);
                _btnController.reset();
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
