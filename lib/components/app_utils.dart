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

  static confirmDialog(BuildContext context, String text, Function confirmFunction) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.8;
    double height = size.height * 0.3;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var mediaQuery = MediaQuery.of(context);
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: mediaQuery.viewInsets,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 1.0,
                        color: Colors.black54,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 30.0,
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    color: const Color.fromRGBO(240, 240, 240, 1.0),
                  ),
                  height: height,
                  width: width,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: height,
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      text,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    // width: double.infinity,
                                    // height: ,
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: kPrimaryLightColor,
                                              side: BorderSide.none,
                                              padding: EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                  Radius.circular(22),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "Отмена",
                                              style: GoogleFonts.montserrat(
                                                color: kWhiteColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: kPrimaryColor,
                                              side: BorderSide.none,
                                              padding: EdgeInsets.all(0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                  Radius.circular(22),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "Подтвердить",
                                              style: GoogleFonts.montserrat(
                                                color: kWhiteColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              confirmFunction();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
