import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:avid_frontend/screens/main/search/components/game_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameListTile extends StatelessWidget {
  const GameListTile({
    Key key,
    @required this.game,
  }) : super(key: key);

  final GameResult game;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return GamePage(game: game);
            }),
          );
        },
        child: Container(
          height: size.width * 0.33,
          decoration: BoxDecoration(
              color: kLightGreyColor,
              borderRadius: BorderRadius.all(Radius.circular(22))),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Hero(
                                tag: game.alias,
                                child: Image.network(game.imageURL),
                              ),
                            ),
                          ),
                        ),
                      ),
                      game.rating != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.supervised_user_circle_outlined,
                                      color: kPrimaryColor,
                                    ),
                                    Text(
                                      game.averageRating.toString(),
                                      style: GoogleFonts.montserrat(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.profile_circled,
                                      color: kPrimaryColor,
                                    ),
                                    Text(
                                      game.rating.toString(),
                                      style: GoogleFonts.montserrat(),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.supervised_user_circle_outlined,
                                  color: kPrimaryColor,
                                ),
                                Text(
                                  game.averageRating.toString(),
                                  style: GoogleFonts.montserrat(),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          game.shortDescription,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
