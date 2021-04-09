import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'api_info.dart';

class UserApi {
  static Future<int> updateUserInfo(String firstName, String secondName,
      String gender, String date, String fileName) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    Map<String, String> bodyMap = {
      "firstName": firstName,
      "secondName": secondName,
      "birthdate": date,
      "gender": gender,
    };

    String photoPath;
    if (fileName != null && fileName.isNotEmpty) {
      photoPath = await saveAvatar(fileName);
      if (photoPath != null) {
        bodyMap.addAll({"photoPath": photoPath});
      }
    }

    var res = await http.post(
      Uri.https(ApiInfo.BASE_URL, "/user/info/update"),
      headers: headers,
      body: jsonEncode(bodyMap),
    );
    log("UserApi.updateUserInfo: response statusCode = ${res.statusCode}");
    log("UserApi.updateUserInfo: response body = ${res.body}");

    return res.statusCode;
  }

  static Future<String> saveAvatar(String fileName) async {
    var authEntry = await ApiInfo.authorizationEntry();

    var request = http.MultipartRequest(
        'POST', Uri.https(ApiInfo.BASE_URL, "/user/storage/upload"));
    request.files.add(await http.MultipartFile.fromPath('file', fileName));
    request.headers.addAll(authEntry);
    var res = await http.Response.fromStream(await request.send());
    log("UserApi.saveAvatar: response statusCode = ${res.statusCode}");
    log("UserApi.saveAvatar: response body = ${res.body}");

    if (res.statusCode == HttpStatus.ok) {
      return res.body;
    }
    return null;
  }

  static Future<Response> getUser() async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    var res = await http.get(
      Uri.https(ApiInfo.BASE_URL, "/user"),
      headers: headers,
    );
    log("UserApi.getUser: response statusCode = ${res.statusCode}");
    log("UserApi.getUser: response body = ${res.body}");

    return res;
  }

  static Future<int> addGame(String alias, String review, double rating) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    Response res = await http.post(
      Uri.https(ApiInfo.BASE_URL, "user/games/add", {
        "alias": alias,
        "rating": rating.toString(),
        "review": review.trim(),
      }),
      headers: headers,
    );
    log("UserApi.addGame: response statusCode = ${res.statusCode}");
    log("UserApi.addGame: response body = ${res.body}");

    return res.statusCode;
  }

  static Future<int> removeGame(String alias) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    var res = await http.get(
      Uri.https(ApiInfo.BASE_URL, "user/games/remove", {"alias": alias}),
      headers: headers,
    );
    log("UserApi.removeGame: response statusCode = ${res.statusCode}");
    log("UserApi.removeGame: response body = ${res.body}");

    return res.statusCode;
  }

  static Future<Response> getUserGames() async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    Uri uri = Uri.https(ApiInfo.BASE_URL, "/user/games");

    var res = await http.get(
      uri,
      headers: headers,
    );
    log("UserApi.getUserGames: response statusCode = ${res.statusCode}");
    log("UserApi.getUserGames: response body = ${res.body}");

    return res;
  }
}
