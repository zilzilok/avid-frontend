import 'dart:io';

import 'package:avid_frontend/components/app_utils.dart';
import 'package:avid_frontend/components/rounded_button.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/profile/components/friends/friend_page.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendListTile extends StatefulWidget {
  const FriendListTile({
    Key key,
    @required this.friend,
  }) : super(key: key);

  final UserResult friend;

  @override
  _FriendListTileState createState() => _FriendListTileState(friend);
}

class _FriendListTileState extends State<FriendListTile> {
  _FriendListTileState(this.friend);

  final UserResult friend;

  @override
  Widget build(BuildContext context) {
    double imageRadius = 30;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return FriendPage(userId: friend.id,);
            }),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: kLightGreyColor,
              borderRadius: BorderRadius.all(Radius.circular(22))),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: imageRadius,
                  backgroundColor: kPrimaryLightColor,
                  // TODO: Временно, чтоб избежать большого количества запросов на aws s3
                  child: friend.photoPath != null && friend.photoPath.isNotEmpty /*false*/
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(imageRadius),
                          child: Image.network(
                            friend.photoPath,
                            width: 2 * imageRadius,
                            height: 2 * imageRadius,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: kLightGreyColor,
                            borderRadius:
                                BorderRadius.circular(imageRadius - 1),
                          ),
                          width: 2 * (imageRadius - 1),
                          height: 2 * (imageRadius - 1),
                          child: Icon(
                            CupertinoIcons.person,
                            size: imageRadius,
                            color: kWhiteColor,
                          ),
                        ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          friend.username,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                style: GoogleFonts.montserrat(fontSize: 18),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: friend.firstName != null
                                          ? friend.firstName
                                          : ""),
                                  TextSpan(text: " "),
                                  TextSpan(
                                      text: friend.secondName != null
                                          ? friend.secondName
                                          : ""),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: friend.has
                        ? RoundedButton(
                            bgColor: kWhiteColor,
                            borderColor: kPrimaryColor,
                            textColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            text: "удалить",
                            onPressed: _confirmDialog,
                          )
                        : RoundedButton(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            text: "добавить",
                            onPressed: _addPressed,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _confirmDialog() {
    AppUtils.confirmDialog(context,
        "Вы уверены что хотите убрать из друзей ${friend.username}?", _removePressed);
  }

  _removePressed() async {
    setState(() {
      friend.has = false;
    });
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      var statusCode = await UserApi.removeFriend(friend.id);
      if (statusCode == HttpStatus.forbidden ||
          statusCode == HttpStatus.unauthorized) {
        AuthUtils.deleteJwt();
        Phoenix.rebirth(context);
      }
      if (statusCode != HttpStatus.ok) {
        setState(() {
          friend.has = true;
        });
        AppUtils.displaySnackBar(context, "Ошибка удаления друга.");
      }
    } else {
      setState(() {
        friend.has = true;
      });
      AppUtils.displaySnackBar(context, "Отсутствует подключение к интернету.");
    }
  }

  _addPressed() async {
    setState(() {
      friend.has = true;
    });
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      var statusCode =
      await UserApi.addFriend(friend.id);

      if (statusCode == HttpStatus.forbidden ||
          statusCode == HttpStatus.unauthorized) {
        AuthUtils.deleteJwt();
        Phoenix.rebirth(context);
      }

      if (statusCode != HttpStatus.ok) {
        setState(() {
          friend.has = false;
        });
        AppUtils.displaySnackBar(context, "Ошибка добавления друга.");
      }
    } else {
      setState(() {
        friend.has = false;
      });
      AppUtils.displaySnackBar(context, "Отсутствует подключение к интернету.");
    }
  }
}
