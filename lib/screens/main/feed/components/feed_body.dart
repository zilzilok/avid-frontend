import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/feed/components/feed_bg.dart';
import 'package:avid_frontend/screens/main/search/components/reviews/review_game_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedBody extends StatefulWidget {
  @override
  State<FeedBody> createState() => _FeedBodyState();
}

class _FeedBodyState extends State<FeedBody> {
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
    return FeedBackground(
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
                height: size.width * 0.1,
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
                            "Новости",
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
                                child: FutureBuilder(
                                  future: UserApi.getUserFriendsUpdates(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var res = snapshot.data as Response;
                                      if (res.statusCode ==
                                              HttpStatus.forbidden ||
                                          res.statusCode ==
                                              HttpStatus.unauthorized) {
                                        AuthUtils.deleteJwt();
                                        Phoenix.rebirth(context);
                                      }
                                      if (res.statusCode == HttpStatus.ok) {
                                        var body = utf8.decode(res.bodyBytes);
                                        Iterable iterableParsedJson =
                                            json.decode(body);
                                        var reviews = <ReviewGameResult>[];
                                        if (iterableParsedJson.isNotEmpty) {
                                          reviews = List<ReviewGameResult>.from(
                                              iterableParsedJson.map((review) =>
                                                  ReviewGameByUserResult
                                                      .fromJson(review)));
                                        }
                                        log("reviews length = ${reviews.length}");
                                        return reviews.length > 0
                                            ? ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: reviews.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: ReviewGameListTile(
                                                        review: reviews[index]),
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                kPrimaryColor),
                                      ),
                                      width: 40,
                                      height: 40,
                                    );
                                  },
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
