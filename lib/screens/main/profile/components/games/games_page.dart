import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:avid_frontend/screens/main/profile/components/profile_bg.dart';
import 'package:avid_frontend/screens/main/search/components/game_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GamesPage extends StatelessWidget {
  final List<GameResult> games;

  const GamesPage({
    Key key,
    @required this.games,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ProfileBackground(
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
                            SizedBox(height: size.height * 0.01),
                            Text(
                              "Мои игры",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Expanded(
                              child: games.length > 0
                                  ? ListView.builder(
                                      itemCount: games.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child:
                                              GameListTile(game: games[index]),
                                        );
                                      },
                                    )
                                  : Center(
                                    child: Text(
                                        "У вас нет игр",
                                        style: GoogleFonts.montserrat(
                                          color: kPrimaryColor,
                                          fontSize: 20,
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
}
