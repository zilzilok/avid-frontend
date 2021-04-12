
import 'package:avid_frontend/components/app_utils.dart';
import 'package:avid_frontend/components/rounded_button.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/profile/components/friends/friends_button.dart';
import 'package:avid_frontend/screens/main/profile/components/games/games_button.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_bg.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_info.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_update_page.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_updates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileBody extends StatefulWidget {
  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ProfileBackground(
      child: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          header: MaterialClassicHeader(
            backgroundColor: kWhiteColor,
            color: kPrimaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, right: 5, bottom: 10),
                width: size.width,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _buildPopupMenuButton(),
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
                    child: Align(
                      alignment: Alignment.center,
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
                          Expanded(
                            child: SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: size.width * 0.05),
                                child: Column(
                                  children: [
                                    ProfileInfo(),
                                    SizedBox(height: size.height * 0.02),
                                    RoundedButton(
                                      bgColor: kWhiteColor,
                                      borderColor: kPrimaryColor,
                                      textColor: kPrimaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 15),
                                      text: "редактировать профиль",
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return ProfileUpdatePage();
                                          }),
                                        );
                                      },
                                    ),
                                    FriendsButton(parentRefreshController: _refreshController),
                                    GamesButton(),
                                    // CustomButton(
                                    //   text: "клубы",
                                    //   onPressed: () {},
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        "Последние действия",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    ProfileUpdates(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildPopupMenuButton() {
    return PopupMenuButton(
      enableFeedback: true,
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
            child: ListTile(
              trailing: Icon(
                Icons.exit_to_app,
                color: kPrimaryColor,
              ),
              title: Text(
                'Выйти',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                ),
              ),
            ),
            value: 'exit')
      ],
      offset: Offset(20, 20),
      onSelected: (String value) {
        if (value == 'exit') {
          AppUtils.confirmDialog(
              context, "вы уверены что хотите выйти из аккаунта?", () {
            AuthUtils.deleteJwt();
            Phoenix.rebirth(context);
          });
        }
      },
      icon: Icon(
        Icons.menu,
        size: 40,
        color: kWhiteColor,
      ),
    );
  }
}
