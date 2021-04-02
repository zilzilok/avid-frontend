import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final double widthPc;
  final EdgeInsetsGeometry padding;

  RoundedButton({
    Key key,
    this.bgColor = kPrimaryColor,
    this.textColor = Colors.white,
    this.onPressed,
    this.borderColor,
    this.text,
    this.widthPc = 0.7,
    this.padding = const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * widthPc,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: bgColor,
          padding: padding,
          side: borderColor != null
              ? BorderSide(color: borderColor, width: 1)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(29))),
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
