import 'dart:convert';
import 'dart:io';

import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/profile/components/friends/friend_list_tile.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_bg.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendsPage extends StatelessWidget {
  final List<UserResult> friends;
  final RefreshController parentRefreshController;
  final int userId;

  const FriendsPage({
    Key key,
    @required this.friends,
    this.parentRefreshController,
    this.userId = -1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: userId != -1
            ? FriendFriendsPageBody(
                friends: friends,
          userId: userId,
              )
            : FriendsPageBody(
                friends: friends,
                parentRefreshController: parentRefreshController,
              ),
      ),
    );
  }
}

class FriendFriendsPageBody extends StatefulWidget {
  final List<UserResult> friends;
  final int userId;

  const FriendFriendsPageBody({Key key, this.friends, this.userId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _FriendFriendsPageBodyState(friends, userId);
}

class _FriendFriendsPageBodyState extends State<FriendFriendsPageBody> {
  final List<UserResult> friends;
  final int userId;

  _FriendFriendsPageBodyState(this.friends, this.userId);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ProfileBackground(
      child: SafeArea(
        child: Column(
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
                          userId == -1 ? "Друзья" : "Друзья $userId",
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
                              child: friends.length > 0
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: friends.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: FriendListTile(
                                              friend: friends[index]),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        "Нет друзей",
                                        style: GoogleFonts.montserrat(
                                          color: kPrimaryColor,
                                          fontSize: 20,
                                        ),
                                      ),
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
    );
  }
}

class FriendsPageBody extends StatefulWidget {
  final List<UserResult> friends;
  final RefreshController parentRefreshController;

  const FriendsPageBody({
    Key key,
    @required this.friends,
    this.parentRefreshController,
  }) : super(key: key);

  @override
  _FriendsPageBodyState createState() =>
      _FriendsPageBodyState(friends, parentRefreshController);
}

class _FriendsPageBodyState extends State<FriendsPageBody> {
  List<UserResult> friends;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final RefreshController parentRefreshController;

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    var res = await UserApi.getUserFriends();
    if (res.statusCode == HttpStatus.forbidden ||
        res.statusCode == HttpStatus.unauthorized) {
      AuthUtils.deleteJwt();
      Phoenix.rebirth(context);
    }
    setState(() {
      if (res.statusCode == HttpStatus.ok) {
        var body = utf8.decode(res.bodyBytes);
        Iterable iterableParsedJson = json.decode(body);
        friends = List<UserResult>.from(
            iterableParsedJson.map((friend) => UserResult.fromJson(friend)));
      }
    });
    parentRefreshController.requestRefresh();
    parentRefreshController.refreshCompleted();

    _refreshController.refreshCompleted();
  }

  _FriendsPageBodyState(this.friends, this.parentRefreshController);

  @override
  Widget build(BuildContext context) {
    return ProfileBackground(
      child: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          header: MaterialClassicHeader(
            backgroundColor: kWhiteColor,
            color: kPrimaryColor,
          ),
          child: SearchBar<SearchUserResult>(
            placeHolder: _friendsPlaceHolder(),
            cancellationWidget: Icon(
              Icons.close,
              color: kWhiteColor,
            ),
            searchBarPadding: EdgeInsets.symmetric(horizontal: 10.0),
            icon: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
            minimumChars: 1,
            hintText: "Логин, имя или фамилию",
            hintStyle:
                GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
            textStyle:
                GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
            searchBarStyle: SearchBarStyle(
              backgroundColor: kWhiteColor,
              borderRadius: const BorderRadius.all(const Radius.circular(29)),
            ),
            onSearch: UserApi.getSearchedUsersJson,
            onItemFound: (SearchUserResult user, int index) {
              return FriendListTile(friend: user);
            },
            mainAxisSpacing: 10,
            onError: (error) {
              return Center(
                child: Text(
                  "Ошибка: $error",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: kWhiteColor,
                    fontSize: 20,
                  ),
                ),
              );
            },
            emptyWidget: Center(
              child: Text(
                "Ничего не найдено",
                style: GoogleFonts.montserrat(
                  color: kWhiteColor,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _friendsPlaceHolder() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
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
                      "Друзья",
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
                          child: friends.length > 0
                              ? ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: friends.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: FriendListTile(
                                          friend: friends[index]),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    "У вас нет друзей",
                                    style: GoogleFonts.montserrat(
                                      color: kPrimaryColor,
                                      fontSize: 20,
                                    ),
                                  ),
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
    );
  }
}
