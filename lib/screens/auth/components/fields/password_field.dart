import 'package:avid_frontend/components/text_field_container.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordField extends StatefulWidget {
  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final Function validator;

  const PasswordField({
    Key key,
    this.controller,
    this.validator,
    this.hintText = "Пароль",
    this.errorText = "Пароль должен содержать минимум 8 символов",
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState(
      this.hintText, this.errorText, this.controller, this.validator);
}

class _PasswordFieldState extends State<PasswordField> {
  final String hintText;
  final String errorText;
  final controller;
  final validator;
  bool _passwordVisible;

  _PasswordFieldState(
      this.hintText, this.errorText, this.controller, this.validator);

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: TextInputType.text,
        obscureText: !_passwordVisible,
        enableSuggestions: false,
        // cursorColor: kPrimaryColor,
        controller: controller,
        validator: validator,
        style: GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: kPrimaryLightColor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: kPrimaryColor)),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: kPrimaryColor)),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: kPrimaryAccentColor)),
          errorStyle: GoogleFonts.montserrat(fontSize: 14),
          hintText: hintText,
          hintStyle:
              GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
          suffixIcon: InkWell(
            child: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: kPrimaryColor,
            ),
            onTap: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
