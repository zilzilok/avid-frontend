import 'package:avid_frontend/res/constants.dart';
import 'package:avid_frontend/screens/auth/api/game_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewListTile extends StatelessWidget {
  const ReviewListTile({
    Key key,
    @required this.review,
  }) : super(key: key);

  final ReviewResult review;

  @override
  Widget build(BuildContext context) {
    var imageRadius = 30.0;
    var date = review.creatingDate.toString();
    date = date.substring(0, date.lastIndexOf(":"));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) {
          //   }),
          // );
        },
        child: Container(
          // height: size.width * 0.33,
          decoration: BoxDecoration(
              color: kLightGreyColor,
              borderRadius: BorderRadius.all(Radius.circular(22))),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: imageRadius,
                      backgroundColor: kPrimaryLightColor,
                      // TODO: Временно, чтоб избежать большого количества запросов на aws s3
                      child: review.owner.photoPath != null && review.owner.photoPath.isNotEmpty /*false*/
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(imageRadius),
                              child: Image.network(
                                review.owner.photoPath,
                                width: 2 * imageRadius,
                                height: 2 * imageRadius,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: kLightGreyColor,
                                borderRadius:
                                    BorderRadius.circular(imageRadius - 1),
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
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.owner.username,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(date,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            review.owner.gender == "MALE"
                                ? "оставил отзыв:"
                                : "оставила отзыв:",
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      review.review,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SmoothStarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  rating: review.rating,
                  size: imageRadius,
                  color: kPrimaryColor,
                  borderColor: kPrimaryColor,
                  isReadOnly: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
