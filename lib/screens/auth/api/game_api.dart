import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/screens/auth/api/api_info.dart';
import 'package:http/http.dart' as http;

class GameApi {
  static Future<List<SearchGameResult>> getSearchedGamesJson(
      String search) async {
    var headers;
    try {
      headers = await ApiInfo.defaultAuthorizationHeader();
    } catch (e) {
      throw e;
    }

    Uri uri = Uri.https(ApiInfo.BASE_URL, "/games/all",
        {"title": search.trim(), "byUser": "true"});
    log(uri.toString());

    var res = await http.get(
      uri,
      headers: headers,
    );
    var body = utf8.decode(res.bodyBytes);
    log(body);

    Iterable iterableParsedJson = json.decode(body);

    if (res.statusCode == HttpStatus.ok && iterableParsedJson.isNotEmpty) {
      return List<SearchGameResult>.from(
          iterableParsedJson.map((game) => SearchGameResult.fromJson(game)));
    }
    return List.empty();
  }

  static Future<List<SearchGameResult>> getRecommendedGamesJson() async {
    var headers;
    try {
      headers = await ApiInfo.defaultAuthorizationHeader();
    } catch (e) {
      throw e;
    }

    Uri uri = Uri.https(
        ApiInfo.BASE_URL, "/games/all", {"limit": "3", "byUser": "true"});
    log(uri.toString());

    var res = await http.get(
      uri,
      headers: headers,
    );
    var body = utf8.decode(res.bodyBytes);
    log(body);

    Iterable iterableParsedJson = json.decode(body);

    if (res.statusCode == HttpStatus.ok && iterableParsedJson.isNotEmpty) {
      return List<SearchGameResult>.from(
          iterableParsedJson.map((game) => SearchGameResult.fromJson(game)));
    }
    return List.empty();
  }
}

class SearchGameResult {
  final String alias;
  final String title;
  final String imageURL;
  final String shortDescription;
  final String description;
  final int playersMin;
  final int playersMax;
  final int year;
  bool has;

  SearchGameResult({
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
