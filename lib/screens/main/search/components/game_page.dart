import 'dart:io';

import 'package:avid_frontend/components/app_utils.dart';
import 'package:avid_frontend/components/rounded_button.dart';
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';
import 'package:avid_frontend/screens/main/search/components/search_bg.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';

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

  _GamePageState(this.game);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SearchBackground(
        child: SafeArea(
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
                              height: size.height * 0.3,
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
                                      text: "добавлена",
                                      borderColor: kPrimaryColor,
                                      bgColor: kWhiteColor,
                                      textColor: kPrimaryColor,
                                      onPressed: () async {
                                        setState(() {
                                          game.has = false;
                                        });
                                        var connectivityResult =
                                            await Connectivity()
                                                .checkConnectivity();
                                        if (connectivityResult !=
                                            ConnectivityResult.none) {
                                          var statusCode =
                                              await UserApi.removeGame(
                                                  game.alias);
                                          if (statusCode ==
                                                  HttpStatus.forbidden ||
                                              statusCode ==
                                                  HttpStatus.unauthorized) {
                                            AuthUtils.deleteJwt();
                                            Phoenix.rebirth(context);
                                          }
                                          if (statusCode != HttpStatus.ok) {
                                            setState(() {
                                              game.has = true;
                                            });
                                            AppUtils.displaySnackBar(context,
                                                "Ошибка удаления игры.");
                                          }
                                        } else {
                                          setState(() {
                                            game.has = true;
                                          });
                                          AppUtils.displaySnackBar(context,
                                              "Отсутствует подключение к интернету.");
                                        }
                                      },
                                    )
                                  : RoundedButton(
                                      widthPc: 0.8,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13, horizontal: 20),
                                      text: "добавить игру",
                                      onPressed: () async {
                                        setState(() {
                                          game.has = true;
                                        });
                                        var connectivityResult =
                                            await Connectivity()
                                                .checkConnectivity();
                                        if (connectivityResult !=
                                            ConnectivityResult.none) {
                                          var statusCode =
                                              await UserApi.addGame(game.alias);

                                          if (statusCode ==
                                                  HttpStatus.forbidden ||
                                              statusCode ==
                                                  HttpStatus.unauthorized) {
                                            AuthUtils.deleteJwt();
                                            Phoenix.rebirth(context);
                                          }

                                          if (statusCode != HttpStatus.ok) {
                                            setState(() {
                                              game.has = false;
                                            });
                                            AppUtils.displaySnackBar(context,
                                                "Ошибка добавления игры.");
                                          }
                                        } else {
                                          setState(() {
                                            game.has = false;
                                          });
                                          AppUtils.displaySnackBar(context,
                                              "Отсутствует подключение к интернету.");
                                        }
                                      },
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
                                        child: Text.rich(
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
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: size.height * 0.01),
                                        child: Text.rich(
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
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: size.height * 0.01),
                                        child: Text(
                                          "Описание:",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
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
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }
}
