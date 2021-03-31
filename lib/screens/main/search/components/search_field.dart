import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final Function onPressed;
  final TextEditingController controller;

  const SearchField({
    Key key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 10.0),
          filled: true,
          fillColor: kWhiteColor,
          hintText: hintText,
          hintStyle:
              GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: const BorderRadius.all(const Radius.circular(29)),
          ),
          suffixIcon: InkWell(
            child: Icon(
              Icons.search,
              color: kPrimaryColor,
              size: 32,
            ),
            onTap: onPressed,
          ),
        ),
        style: GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
      ),
    );
  }
}
