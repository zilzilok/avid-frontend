
import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:avid_frontend/screens/main/search/components/game_list_tile.dart';
import 'package:avid_frontend/screens/main/search/components/search_bg.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'category_button.dart';

class SearchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchBackground(
      child: SafeArea(
        child: SearchBar<SearchGameResult>(
            cancellationWidget: Icon(
              Icons.close,
              color: kWhiteColor,
            ),
            searchBarPadding: EdgeInsets.symmetric(horizontal: 10.0),
            placeHolder: SearchPlaceholder(),
            icon: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
            hintText: "Название настольной игры",
            hintStyle:
                GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
            textStyle:
                GoogleFonts.montserrat(fontSize: 16, color: kTextGreyColor),
            searchBarStyle: SearchBarStyle(
              backgroundColor: kWhiteColor,
              borderRadius: const BorderRadius.all(const Radius.circular(29)),
            ),
            onSearch: GameApi.getSearchedGamesJson,
            onItemFound: (SearchGameResult game, int index) {
              return GameListTile(game: game);
            },
            mainAxisSpacing: 10,
            onError: (error) {
              return Center(
                child: Text(
                  "Ошибка: $error",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: kWhiteColor,
                    fontSize: 20,
                  ),
                ),
              );
            },
            emptyWidget: Center(
              child: Text(
                "Ничего не найдено",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: kWhiteColor,
                  fontSize: 20,
                ),
              ),
            )),
      ),
    );
  }
}

class SearchPlaceholder extends StatelessWidget {
  const SearchPlaceholder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: CategoryButton(
                      text: "Популярные настольные игры",
                      onPressed: () {},
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: CategoryButton(
                      text: "Последние добавления",
                      onPressed: () {},
                    )),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
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
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.01),
                      Text(
                        "Ваши рекомендации",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Expanded(
                        child: FutureBuilder(
                          future: GameApi.getRecommendedGamesJson(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var games =
                                  snapshot.data as List<SearchGameResult>;
                              return ListView.builder(
                                  itemCount: games.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: GameListTile(game: games[index]),
                                    );
                                  });
                            }
                            return Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kPrimaryColor),
                                ),
                                width: 40,
                                height: 40,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
