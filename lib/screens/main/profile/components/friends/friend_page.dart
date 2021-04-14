
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/main/profile/components/friends/friends_button.dart';
import 'package:avid_frontend/screens/main/profile/components/games/games_button.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_bg.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_info.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_updates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendPage extends StatelessWidget {
  final int userId;

  const FriendPage({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: FriendPageBody(
          userId: userId,
        ),
      ),
    );
  }
}

class FriendPageBody extends StatefulWidget {
  final int userId;

  const FriendPageBody({Key key, this.userId}) : super(key: key);

  @override
  State<FriendPageBody> createState() => _FriendPageBodyState(userId);
}

class _FriendPageBodyState extends State<FriendPageBody> {
  final int userId;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _FriendPageBodyState(this.userId);

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
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_sharp,
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
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: size.height * 0.01),
                          Text(
                            "Профиль $userId",
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
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05),
                                child: Column(
                                  children: [
                                    ProfileInfo(
                                      userId: userId,
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    FriendsButton(
                                      userId: userId,
                                      parentRefreshController:
                                          _refreshController,
                                    ),
                                    GamesButton(userId: userId),
                                    Padding(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 5),
                                      child: Text(
                                        "Последние действия",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    ProfileUpdates(userId: userId,),
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
}
