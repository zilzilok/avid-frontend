import 'package:avid_frontend/res/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppUtils {
  static void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
        ),
      );

  static void displaySnackBar(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              message,
              style: GoogleFonts.montserrat(
                color: kWhiteColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: kPrimaryLightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(29), topRight: Radius.circular(29)),
            ),
            duration: const Duration(milliseconds: 1500)),
      );
}
