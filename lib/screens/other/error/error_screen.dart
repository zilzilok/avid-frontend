import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/other/error/components/error_body.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;

  ErrorScreen({
    Key key,
    this.title = "Ошибка!",
    this.message = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ErrorBody(
        title: title,
        message: message,
      ),
    );
  }
}
