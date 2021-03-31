import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/main/search/components/search_bg.dart';
import 'package:avid_frontend/screens/main/search/components/search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'category_button.dart';

class SearchBody extends StatelessWidget {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SearchBackground(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.01),
                  SearchField(
                    controller: _searchController,
                    hintText: "Настольная игра или клуб",
                    onPressed: () {

                    },
                  ),
                  SizedBox(height: size.height * 0.03),
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
                  SizedBox(height: size.height * 0.03),
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
                      margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
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
    );
  }
}
