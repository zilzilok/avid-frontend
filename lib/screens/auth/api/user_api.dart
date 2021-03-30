import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'api_info.dart';

class UserApi {
  static Future<int> updateUserInfo(String firstName, String secondName,
      String gender, String date, String fileName) async {
    var headers;
    try {
      headers = await ApiInfo.defaultAuthorizationHeader();
    } catch (e) {
      throw e;
    }

    Map<String, String> bodyMap = {
      "firstName": firstName,
      "secondName": secondName,
      "birthdate" : date,
      "gender": gender,
    };

    String photoPath;
    if (fileName != null && fileName.isNotEmpty) {
      photoPath = await saveAvatar(fileName);
      if (photoPath != null) {
        bodyMap.addAll({"photoPath" : photoPath});
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
    var authEntry;
    try {
      authEntry = await ApiInfo.authorizationEntry();
    } catch (e) {
      throw e;
    }

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
}
