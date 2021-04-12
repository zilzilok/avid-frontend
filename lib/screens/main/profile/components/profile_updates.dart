import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/search/components/reviews/review_game_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

// TODO: Пока только отзывы в дальнейшем должны быть и другие события
class ProfileUpdates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserApi.getUserUpdates(),
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
            var reviews = <ReviewGameResult>[];
            if (iterableParsedJson.isNotEmpty) {
              reviews = List<ReviewGameResult>.from(iterableParsedJson
                  .map((game) => ReviewGameResult.fromJson(game)));
            }
            log("games length = ${reviews.length}");
            return reviews.length > 0
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ReviewGameListTile(review: reviews[index]),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      "Ничего не найдено",
                      style: GoogleFonts.montserrat(
                        color: kPrimaryColor,
                        fontSize: 20,
                      ),
                    ),
                  );
          }
        }
        return SizedBox(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
          width: 40,
          height: 40,
        );
      },
    );
  }
}
