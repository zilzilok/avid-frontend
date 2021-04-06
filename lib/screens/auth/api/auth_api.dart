import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:avid_frontend/screens/auth/api/api_info.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static Future<String> attemptAuth(String username, String password) async {
    var res = await http.post(
      Uri.https(ApiInfo.BASE_URL, "/auth"),
      headers: {
        "content-type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );
    log("AuthApi.attemptAuth: response statusCode = ${res.statusCode}");
    log("AuthApi.attemptAuth: response body = ${res.body}");

    if (res.statusCode == HttpStatus.ok) {
      return res.body;
    }
    return null;
  }

  static Future<int> attemptRegister(String username, String email,
      String password, String matchingPassword) async {
    var res = await http.post(
      Uri.https(ApiInfo.BASE_URL, "/registration"),
      headers: {
        "content-type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "matchingPassword": matchingPassword,
      }),
    );
    log("AuthApi.attemptRegister: response statusCode = ${res.statusCode}");
    log("AuthApi.attemptRegister: response body = ${res.body}");

    return res.statusCode;
  }

  static Future<bool> attempt(String jwt) async {
    var res = await http.get(
      Uri.https(ApiInfo.BASE_URL, "/users"),
      headers: {
        "content-type": "application/json",
        "authorization": "Bearer $jwt",
      },
    );
    log("AuthApi.attempt: response statusCode = ${res.statusCode}");

    return res.statusCode == HttpStatus.ok;
  }
}
