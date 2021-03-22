import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorBody extends StatelessWidget {
  final String title;
  final String message;

  ErrorBody({
    Key key,
    this.title = "Ошибка!",
    this.message = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/icons/launch_icon.png",
                width: size.width * 0.5,
                height: size.width * 0.5,
              ),
              Text(
                title,
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
              Flexible(
                  child: Text(
                message,
                style: GoogleFonts.montserrat(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
