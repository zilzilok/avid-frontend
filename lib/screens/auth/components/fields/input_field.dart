import 'package:avid_frontend/components/text_field_container.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final Function validator;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const InputField({
    Key key,
    this.controller,
    this.validator,
    this.hintText,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        controller: controller,
        cursorColor: kPrimaryColor,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: kPrimaryLightColor)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: kPrimaryColor)),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: kPrimaryColor)),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(width: 1, color: kPrimaryAccentColor)),
          errorStyle: GoogleFonts.montserrat(fontSize: 14),
        ),
        style: GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
      ),
    );
  }
}
