import 'dart:io';

import 'package:avid_frontend/components/app_utils.dart';
import 'package:avid_frontend/components/rounded_button.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/search/components/reviews/reviews_button.dart';
import 'package:avid_frontend/screens/main/search/components/search_bg.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class GamePage extends StatefulWidget {
  final GameResult game;

  const GamePage({
    Key key,
    @required this.game,
  }) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState(game);
}

class _GamePageState extends State<GamePage> {
  final GameResult game;
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 5.0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _GamePageState(this.game);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SearchBackground(
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
                        child: Container(
                          width: size.width * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: size.height * 0.02),
                              Container(
                                height: size.height * 0.25,
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.02),
                                child: Hero(
                                  tag: game.alias,
                                  child: Image.network(
                                    game.imageURL,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              Text(
                                game.title,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                  fontSize: 20,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.02),
                                child: game.has
                                    ? RoundedButton(
                                        widthPc: 0.8,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 13, horizontal: 20),
                                        text: "убрать из библиотеки",
                                        borderColor: kPrimaryColor,
                                        bgColor: kWhiteColor,
                                        textColor: kPrimaryColor,
                                        onPressed: _confirmDialog,
                                      )
                                    : RoundedButton(
                                        widthPc: 0.8,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 13, horizontal: 20),
                                        text: "добавить в библиотеку",
                                        onPressed: _reviewDialog,
                                      ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: size.height * 0.01),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: size.height * 0.01),
                                          child: ReviewsButton(
                                            game: game,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text.rich(
                                              TextSpan(
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 16),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: "Рейтинг:\t",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: game.averageRating
                                                          .toString()),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              game.averageRating == 5.0
                                                  ? Icons.star
                                                  : (game.averageRating == 0.0
                                                      ? Icons.star_border
                                                      : Icons.star_half),
                                              color: kPrimaryColor,
                                            ),
                                          ],
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "Год создания:\t",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: game.year.toString()),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "Возрастное ограничение:\t",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                  text:
                                                      "${game.playersAgeMin}+"),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "Время игры:\t",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                  text:
                                                      "${game.playtimeMin}-${game.playtimeMax} минут"),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: "Количество игроков:\t",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                  text: game.playersMin
                                                      .toString()),
                                              TextSpan(text: "-"),
                                              TextSpan(
                                                  text: game.playersMax
                                                      .toString()),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "Описание:",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(_parseHtmlString(game.description),
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16)),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _confirmDialog() {
    AppUtils.confirmDialog(
        context,
        "Вы уверены что хотите убрать игру из ващей библиотеки?",
        _removePressed);
  }

  _removePressed() async {
    setState(() {
      game.has = false;
    });
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      var statusCode = await UserApi.removeGame(game.alias);
      if (statusCode == HttpStatus.forbidden ||
          statusCode == HttpStatus.unauthorized) {
        AuthUtils.deleteJwt();
        Phoenix.rebirth(context);
      }
      if (statusCode != HttpStatus.ok) {
        setState(() {
          game.has = true;
        });
        AppUtils.displaySnackBar(context, "Ошибка удаления игры.");
      }
    } else {
      setState(() {
        game.has = true;
      });
      AppUtils.displaySnackBar(context, "Отсутствует подключение к интернету.");
    }
  }

  _reviewDialog() {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.8;
    double height = size.height * 0.4;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var mediaQuery = MediaQuery.of(context);
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: mediaQuery.viewInsets,
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        spreadRadius: 1.0,
                        color: Colors.black54,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 30.0,
                      )
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(22)),
                    color: const Color.fromRGBO(240, 240, 240, 1.0),
                  ),
                  height: height,
                  width: width,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: height,
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Оставьте отзыв и оценку",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                  alignment: Alignment.center,
                                ),
                                SmoothStarRating(
                                  allowHalfRating: true,
                                  onRated: (rating) {
                                    _rating = rating;
                                  },
                                  starCount: 5,
                                  rating: 5,
                                  size: 35.0,
                                  color: kPrimaryColor,
                                  borderColor: kPrimaryColor,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: TextField(
                                      controller: _reviewController,
                                      maxLines: null,
                                      maxLength: 100,
                                      keyboardType: TextInputType.text,
                                      style:
                                          GoogleFonts.montserrat(fontSize: 16),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kWhiteColor, width: 1.0),
                                        ),
                                        hintMaxLines: 1,
                                        hintText: "Отзыв об игре",
                                        hintStyle: GoogleFonts.montserrat(
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: kPrimaryColor,
                                        side: BorderSide.none,
                                        padding: EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(22),
                                            bottomRight: Radius.circular(22),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Подтвердить",
                                        style: GoogleFonts.montserrat(
                                          color: kWhiteColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _addPressed();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            height: 26,
                            alignment: Alignment.topRight,
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.black87,
                                size: 19,
                              ),
                              backgroundColor:
                                  Color.fromRGBO(240, 240, 240, 0.8),
                              elevation: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _addPressed() async {
    setState(() {
      game.has = true;
    });
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      var statusCode =
          await UserApi.addGame(game.alias, _reviewController.text, _rating);

      if (statusCode == HttpStatus.forbidden ||
          statusCode == HttpStatus.unauthorized) {
        AuthUtils.deleteJwt();
        Phoenix.rebirth(context);
      }

      if (statusCode != HttpStatus.ok) {
        setState(() {
          game.has = false;
        });
        AppUtils.displaySnackBar(context, "Ошибка добавления игры.");
      }
    } else {
      setState(() {
        game.has = false;
      });
      AppUtils.displaySnackBar(context, "Отсутствует подключение к интернету.");
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }
}
