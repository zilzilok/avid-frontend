import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;

  CustomButton({
    Key key,
    this.bgColor = kWhiteColor,
    this.textColor = kPrimaryColor,
    this.onPressed,
    this.borderColor = kPrimaryColor,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              bottom: BorderSide(width: 1, color: borderColor),
            ),
          ),
          child: Stack(
            children: [
              TextButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    style: GoogleFonts.montserrat(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: onPressed,
              ),
              Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                FontAwesomeIcons.chevronRight,
                color: borderColor,
              ),
                  ))
            ],
          )),
    );
  }
}
