import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/reg/info/components/reg_info_bg.dart';
import 'package:avid_frontend/screens/auth/reg/info/components/reg_info_page.dart';
import 'package:flutter/material.dart';

class RegInfoBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RegInfoBackground(
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              RegInfoFormPage(),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
