import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/profile/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart';

import 'games_page.dart';

class GamesButton extends StatelessWidget {
  final int userId;

  const GamesButton({Key key, this.userId = -1}) : super(key: key);

  @override
  Widget build(context) {
    return FutureBuilder(
      future: userId != -1
          ? UserApi.getUserGamesById(userId)
          : UserApi.getUserGames(),
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
            var games = <GameResult>[];
            if (iterableParsedJson.isNotEmpty) {
              games = List<GameResult>.from(
                  iterableParsedJson.map((game) => userId != -1 ? GameByUserResult.fromJson(game) : GameResult.fromJson(game)));
            }
            log("games length = ${games.length}");
            return CustomButton(
              text: "игры",
              count: games.length,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return GamesPage(games: games);
                  }),
                );
              },
            );
          }
        }
        return CustomButton(text: "игры");
      },
    );
  }
}
