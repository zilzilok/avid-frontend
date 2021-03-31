import 'package:avid_frontend/components/custom_button.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_bg.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ProfileBackground(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5, right: 5, bottom: 10),
              width: size.width,
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.bars,
                    size: size.width * 0.1,
                    color: kWhiteColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "Профиль",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ProfileInfo(),
                        SizedBox(height: size.height * 0.02),
                        CustomButton(
                          text: "друзья",
                          onPressed: () {},
                        ),
                        CustomButton(
                          text: "клубы",
                          onPressed: () {},
                        ),
                        // RoundedButton(
                        //   text: "Выйти из аккаунта",
                        //   onPressed: () {
                        //     AuthUtils.deleteJwt();
                        //     Phoenix.rebirth(context);
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
