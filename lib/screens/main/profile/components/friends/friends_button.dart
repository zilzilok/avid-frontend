import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/profile/components/custom_button.dart';
import 'package:avid_frontend/screens/main/profile/components/friends/friends_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FriendsButton extends StatelessWidget {
  final RefreshController parentRefreshController;
  final int userId;

  const FriendsButton({Key key, this.parentRefreshController, this.userId = -1})
      : super(key: key);

  @override
  Widget build(context) {
    return FutureBuilder(
      future: userId != -1
          ? UserApi.getUserFriendsById(userId)
          : UserApi.getUserFriends(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var res = snapshot.data as Response;
          if (res.statusCode == HttpStatus.forbidden ||
              res.statusCode == HttpStatus.unauthorized) {
            AuthUtils.deleteJwt();
            Phoenix.rebirth(context);
          }
          if (res.statusCode == HttpStatus.ok) {
            var body = utf8.decode(res.bodyBytes);
            Iterable iterableParsedJson = json.decode(body);
            var friends = <UserResult>[];
            if (iterableParsedJson.isNotEmpty) {
              friends = List<UserResult>.from(iterableParsedJson
                  .map((friend) => UserResult.fromJson(friend)));
            }
            log("friends length = ${friends.length}");
            return CustomButton(
              text: "друзья",
              count: friends.length,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return FriendsPage(
                      userId: userId,
                      friends: friends,
                      parentRefreshController: parentRefreshController,
                    );
                  }),
                );
              },
            );
          }
        }
        return CustomButton(text: "друзья");
      },
    );
  }
}
