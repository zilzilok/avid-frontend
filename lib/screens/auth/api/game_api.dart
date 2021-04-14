import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/screens/auth/api/api_info.dart';
import 'package:avid_frontend/screens/auth/api/user_api.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GameApi {
  static Future<List<SearchGameResult>> getSearchedGamesJson(
      String search) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    Uri uri = Uri.https(ApiInfo.BASE_URL, "/games/all",
        {"title": search.trim(), "byUser": "true"});

    var res = await http.get(
      uri,
      headers: headers,
    );

    if (res.statusCode != HttpStatus.ok) {
      return null;
    }

    var body = utf8.decode(res.bodyBytes);
    log("GameApi.getSearchedGamesJson: response statusCode = ${res.statusCode}");
    log("GameApi.getSearchedGamesJson: response body = $body");

    Iterable iterableParsedJson = json.decode(body);

    if (iterableParsedJson.isNotEmpty) {
      return List<SearchGameResult>.from(
          iterableParsedJson.map((game) => SearchGameResult.fromJson(game)));
    }
    return List.empty();
  }

  static Future<List<SearchGameResult>> getRecommendedGamesJson() async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    Uri uri = Uri.https(
        ApiInfo.BASE_URL, "/games/all", {"limit": "3", "byUser": "true"});

    var res = await http.get(
      uri,
      headers: headers,
    );

    if (res.statusCode != HttpStatus.ok) {
      return List.empty();
    }

    var body = utf8.decode(res.bodyBytes);
    log("GameApi.getRecommendedGamesJson: response statusCode = ${res.statusCode}");
    log("GameApi.getRecommendedGamesJson: response body = $body");

    Iterable iterableParsedJson = json.decode(body);
    log(iterableParsedJson.toString());

    if (res.statusCode == HttpStatus.ok && iterableParsedJson.isNotEmpty) {
      return List<SearchGameResult>.from(
          iterableParsedJson.map((game) => SearchGameResult.fromJson(game)));
    }
    return List.empty();
  }

  static Future<Response> getReviews(String alias) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    Uri uri = Uri.https(ApiInfo.BASE_URL, "/games/owners", {"alias": alias});

    var res = await http.get(
      uri,
      headers: headers,
    );
    log("GameApi.getReviews: response statusCode = ${res.statusCode}");
    log("GameApi.getReviews: response body = ${res.body}");

    return res;
  }
}

class GameDto {
  final String alias;
  final String title;
  final String imageURL;
  final String shortDescription;
  final String description;
  final int playersMin;
  final int playersMax;
  final int playtimeMin;
  final int playtimeMax;
  final int playersAgeMin;
  final int year;
  final double averageRating;

  GameDto({
    this.alias,
    this.title,
    this.imageURL,
    this.shortDescription,
    this.description,
    this.playersMin,
    this.playersMax,
    this.playtimeMin,
    this.playtimeMax,
    this.playersAgeMin,
    this.year,
    this.averageRating,
  });

  factory GameDto.fromJson(Map<String, dynamic> parsedJson) {
    return GameDto(
      alias: parsedJson["alias"],
      title: parsedJson["titles"][0],
      shortDescription: parsedJson["descriptionShort"],
      description: parsedJson["description"],
      imageURL: parsedJson["photoUrl"],
      year: parsedJson["year"],
      playersMin: parsedJson["playersMin"],
      playersMax: parsedJson["playersMax"],
      playtimeMin: parsedJson["playtimeMin"],
      playtimeMax: parsedJson["playtimeMax"],
      playersAgeMin: parsedJson["playersAgeMin"],
      averageRating: parsedJson["averageRating"],
    );
  }
}

class GameResult extends GameDto {
  final String review;
  final double rating;
  bool has;

  GameResult({
    String alias,
    String title,
    String imageURL,
    String shortDescription,
    String description,
    int playersMin,
    int playersMax,
    int playtimeMin,
    int playtimeMax,
    int playersAgeMin,
    int year,
    double averageRating,
    this.has,
    this.review,
    this.rating,
  }) : super(
          alias: alias,
          title: title,
          imageURL: imageURL,
          shortDescription: shortDescription,
          description: description,
          playersMin: playersMin,
          playersMax: playersMax,
          playtimeMin: playtimeMin,
          playtimeMax: playtimeMax,
          playersAgeMin: playersAgeMin,
          year: year,
          averageRating: averageRating,
        );

  factory GameResult.fromJson(Map<String, dynamic> parsedJson) {
    return GameResult(
      alias: parsedJson["game"]["alias"],
      title: parsedJson["game"]["titles"][0],
      shortDescription: parsedJson["game"]["descriptionShort"],
      description: parsedJson["game"]["description"],
      imageURL: parsedJson["game"]["photoUrl"],
      year: parsedJson["game"]["year"],
      playersMin: parsedJson["game"]["playersMin"],
      playersMax: parsedJson["game"]["playersMax"],
      playtimeMin: parsedJson["game"]["playtimeMin"],
      playtimeMax: parsedJson["game"]["playtimeMax"],
      playersAgeMin: parsedJson["game"]["playersAgeMin"],
      has: true,
      rating: parsedJson["rating"],
      averageRating: parsedJson["game"]["averageRating"],
      review: parsedJson["review"],
    );
  }
}

class GameByUserResult extends GameResult {
  GameByUserResult({
    String alias,
    String title,
    String imageURL,
    String shortDescription,
    String description,
    int playersMin,
    int playersMax,
    int playtimeMin,
    int playtimeMax,
    int playersAgeMin,
    int year,
    double averageRating,
    bool has,
    String review,
    double rating,
  }) : super(
          alias: alias,
          title: title,
          imageURL: imageURL,
          shortDescription: shortDescription,
          description: description,
          playersMin: playersMin,
          playersMax: playersMax,
          playtimeMin: playtimeMin,
          playtimeMax: playtimeMax,
          playersAgeMin: playersAgeMin,
          year: year,
          averageRating: averageRating,
          has: has,
          review: review,
          rating: rating,
        );

  factory GameByUserResult.fromJson(Map<String, dynamic> parsedJson) {
    return GameByUserResult(
      alias: parsedJson["userGame"]["game"]["alias"],
      title: parsedJson["userGame"]["game"]["titles"][0],
      shortDescription: parsedJson["userGame"]["game"]["descriptionShort"],
      description: parsedJson["userGame"]["game"]["description"],
      imageURL: parsedJson["userGame"]["game"]["photoUrl"],
      year: parsedJson["userGame"]["game"]["year"],
      playersMin: parsedJson["userGame"]["game"]["playersMin"],
      playersMax: parsedJson["userGame"]["game"]["playersMax"],
      playtimeMin: parsedJson["userGame"]["game"]["playtimeMin"],
      playtimeMax: parsedJson["userGame"]["game"]["playtimeMax"],
      playersAgeMin: parsedJson["userGame"]["game"]["playersAgeMin"],
      has: parsedJson["has"],
      rating: parsedJson["userGame"]["rating"],
      averageRating: parsedJson["userGame"]["game"]["averageRating"],
      review: parsedJson["userGame"]["review"],
    );
  }
}

class SearchGameResult extends GameResult {
  SearchGameResult({
    String alias,
    String title,
    String imageURL,
    String shortDescription,
    String description,
    int playersMin,
    int playersMax,
    int playtimeMin,
    int playtimeMax,
    int playersAgeMin,
    int year,
    bool has,
    double averageRating,
  }) : super(
          alias: alias,
          title: title,
          imageURL: imageURL,
          shortDescription: shortDescription,
          description: description,
          playersMin: playersMin,
          playersMax: playersMax,
          playtimeMin: playtimeMin,
          playtimeMax: playtimeMax,
          playersAgeMin: playersAgeMin,
          year: year,
          has: has,
          averageRating: averageRating,
        );

  factory SearchGameResult.fromJson(Map<String, dynamic> parsedJson) {
    return SearchGameResult(
      alias: parsedJson["boardGame"]["alias"],
      title: parsedJson["boardGame"]["titles"][0],
      shortDescription: parsedJson["boardGame"]["descriptionShort"],
      description: parsedJson["boardGame"]["description"],
      imageURL: parsedJson["boardGame"]["photoUrl"],
      year: parsedJson["boardGame"]["year"],
      playersMin: parsedJson["boardGame"]["playersMin"],
      playersMax: parsedJson["boardGame"]["playersMax"],
      playtimeMin: parsedJson["boardGame"]["playtimeMin"],
      playtimeMax: parsedJson["boardGame"]["playtimeMax"],
      playersAgeMin: parsedJson["boardGame"]["playersAgeMin"],
      has: parsedJson["has"],
      averageRating: parsedJson["boardGame"]["averageRating"],
    );
  }
}

class ReviewResult {
  final UserDto owner;
  final String review;
  final double rating;
  final DateTime creatingDate;

  ReviewResult({
    this.owner,
    this.review,
    this.rating,
    this.creatingDate,
  });

  factory ReviewResult.fromJson(Map<String, dynamic> parsedJson) {
    return ReviewResult(
      owner: UserDto.fromJson(parsedJson["owner"]),
      review: parsedJson["review"],
      rating: parsedJson["rating"],
      creatingDate: DateTime.parse(parsedJson["creatingDateTime"]).toLocal(),
    );
  }
}

class ReviewGameResult {
  final GameResult game;
  final UserDto owner;
  final DateTime creatingDate;

  ReviewGameResult({
    this.game,
    this.owner,
    this.creatingDate,
  });

  factory ReviewGameResult.fromJson(Map<String, dynamic> parsedJson) {
    return ReviewGameResult(
      creatingDate: DateTime.parse(parsedJson["creatingDateTime"]).toLocal(),
      owner: UserDto.fromJson(parsedJson["owner"]),
      game: GameResult.fromJson(parsedJson),
    );
  }
}

class ReviewGameByUserResult extends ReviewGameResult {
  ReviewGameByUserResult({
    GameResult game,
    UserDto owner,
    DateTime creatingDate,
  }) : super(
          game: game,
          owner: owner,
          creatingDate: creatingDate,
        );

  factory ReviewGameByUserResult.fromJson(Map<String, dynamic> parsedJson) {
    return ReviewGameByUserResult(
      creatingDate:
          DateTime.parse(parsedJson["userGame"]["creatingDateTime"]).toLocal(),
      owner: UserDto.fromJson(parsedJson["userGame"]["owner"]),
      game: GameByUserResult.fromJson(parsedJson),
    );
  }
}
