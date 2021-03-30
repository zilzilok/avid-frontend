import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:avid_frontend/screens/auth/components/fields/date_field.dart';
import 'package:avid_frontend/screens/main/profile/components/user_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double imageRadius = size.width / 7;
    return FutureBuilder(
      future: UserApi.getProfileJson(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = UserDao.fromJson(snapshot.data);
          int years = user.birthdate != null && user.birthdate.isNotEmpty
              ? _countYears(user.birthdate)
              : -1;
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: imageRadius,
                  backgroundColor: kPrimaryLightColor,
                  // TODO: Временно, чтоб избежать большого количества запросов на aws s3
                  child: /*user.photoPath != null && user.photoPath.isNotEmpty*/ false
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(imageRadius),
                          child: Image.network(
                            user.photoPath,
                            width: 2 * imageRadius,
                            height: 2 * imageRadius,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                    decoration: BoxDecoration(
                      color: kLightGreyColor,
                      borderRadius: BorderRadius.circular(imageRadius - 1),
                    ),
                    width: 2 * (imageRadius - 1),
                    height: 2 * (imageRadius - 1),
                    child: Icon(
                      CupertinoIcons.person,
                      size: imageRadius,
                      color: kWhiteColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          user.username,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                style: GoogleFonts.montserrat(fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: user.firstName != null
                                          ? user.firstName
                                          : ""),
                                  TextSpan(text: " "),
                                  TextSpan(
                                      text: user.secondName != null
                                          ? user.secondName
                                          : ""),
                                ],
                              ),
                            ),
                            Text(
                              years != -1
                                  ? years.toString() +
                                      " " +
                                      _russianYearWord(years)
                                  : "",
                              style: GoogleFonts.montserrat(fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
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

int _countYears(String date) {
  DateTime dateTime = DateField.SQL_DATE_FORMAT.parse(date);
  var day = dateTime.day;
  var year = dateTime.year;
  var month = dateTime.month;

  DateTime now = DateTime.now();

  var res = now.year - year - 1;

  if (now.month >= month) {
    if (now.month > month) {
      res++;
    } else if (now.day >= day) {
      res++;
    }
  }

  return res;
}

String _russianYearWord(int year) {
  if (year >= 11 && year <= 14) {
    return "лет";
  }
  int num = year % 10;
  if (num == 1) {
    return "год";
  }

  if (num >= 2 && num <= 4) {
    return "года";
  }

  return "лет";
}
