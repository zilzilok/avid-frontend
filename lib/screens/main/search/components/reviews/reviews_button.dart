import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/profile/components/custom_button.dart';
import 'package:avid_frontend/screens/main/search/components/reviews/reviews_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart';

class ReviewsButton extends StatelessWidget {
  const ReviewsButton({
    Key key,
    @required this.game,
  }) : super(key: key);

  final GameResult game;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GameApi.getReviews(game.alias),
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
            var reviews = <ReviewResult>[];
            if (iterableParsedJson.isNotEmpty) {
              reviews = List<ReviewResult>.from(iterableParsedJson
                  .map((game) => ReviewResult.fromJson(game)));
            }
            log("games length = ${reviews.length}");
            return CustomButton(
              count: reviews.length,
              text: "отзывы пользователей",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ReviewsPage(title: game.title, reviews: reviews);
                  }),
                );
              },
            );
          }
        }
        return CustomButton(text: "отзывы пользователей");
      },
    );
  }
}
