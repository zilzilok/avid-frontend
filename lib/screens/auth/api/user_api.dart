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
    log(res.body);
    return res.statusCode;
  }

  static Future<String> saveAvatar(String fileName) async {
    var authEntry = await ApiInfo.authorizationEntry();

    var request = http.MultipartRequest(
        'POST', Uri.https(ApiInfo.BASE_URL, "/user/storage/upload"));
    request.files.add(await http.MultipartFile.fromPath('file', fileName));
    request.headers.addAll(authEntry);
    var res = await http.Response.fromStream(await request.send());

    if (res.statusCode == HttpStatus.ok) {
      return res.body;
    }
    return null;
  }

  static Future<Response> getProfileRequest() async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    var res = await http.get(
      Uri.https(ApiInfo.BASE_URL, "/user"),
      headers: headers,
    );
    log(res.body);

    return res;
  }

  static Future<int> addGame(String alias) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    var res = await http.get(
      Uri.https(ApiInfo.BASE_URL, "user/games/add", {"alias": alias}),
      headers: headers,
    );
    log(res.body);

    return res.statusCode;
  }

  static Future<int> removeGame(String alias) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    var res = await http.get(
      Uri.https(ApiInfo.BASE_URL, "user/games/remove", {"alias": alias}),
      headers: headers,
    );
    log(res.body);

    return res.statusCode;
  }
}
