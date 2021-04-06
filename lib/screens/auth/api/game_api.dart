import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/screens/auth/api/api_info.dart';
import 'package:http/http.dart' as http;

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

    if (res.statusCode == HttpStatus.ok && iterableParsedJson.isNotEmpty) {
      return List<SearchGameResult>.from(
          iterableParsedJson.map((game) => SearchGameResult.fromJson(game)));
    }
    return List.empty();
  }
}

class GameResult {
  final String alias;
  final String title;
  final String imageURL;
  final String shortDescription;
  final String description;
  final int playersMin;
  final int playersMax;
  final int year;
  bool has;

  GameResult({
    this.description,
    this.playersMin,
    this.playersMax,
    this.year,
    this.alias,
    this.title,
    this.imageURL,
    this.shortDescription,
    this.has,
  });

  factory GameResult.fromJson(Map<String, dynamic> parsedJson) {
    return GameResult(
      alias: parsedJson["alias"],
      title: parsedJson["titles"][0],
      shortDescription: parsedJson["descriptionShort"],
      description: parsedJson["description"],
      imageURL: parsedJson["photoUrl"],
      year: parsedJson["year"],
      playersMin: parsedJson["playersMin"],
      playersMax: parsedJson["playersMax"],
      has: true,
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
    int year,
    bool has,
  }) : super(
          alias: alias,
          title: title,
          imageURL: imageURL,
          shortDescription: shortDescription,
          description: description,
          playersMin: playersMin,
          playersMax: playersMax,
          year: year,
          has: has,
        );

  factory SearchGameResult.fromJson(Map<String, dynamic> parsedJson) {
    return SearchGameResult(
      alias: parsedJson["boardGames"]["alias"],
      title: parsedJson["boardGames"]["titles"][0],
      shortDescription: parsedJson["boardGames"]["descriptionShort"],
      description: parsedJson["boardGames"]["description"],
      imageURL: parsedJson["boardGames"]["photoUrl"],
      year: parsedJson["boardGames"]["year"],
      playersMin: parsedJson["boardGames"]["playersMin"],
      playersMax: parsedJson["boardGames"]["playersMax"],
      has: parsedJson["has"],
    );
  }
}
