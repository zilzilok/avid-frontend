import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'api_info.dart';

class UserApi {
  static Future<String> saveAvatar(String fileName) async {
    var authEntry = await ApiInfo.authorizationEntry();

    var request = http.MultipartRequest(
        'POST', Uri.https(ApiInfo.BASE_URL, "/user/storage/update"));
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

  //TODO: пока только отзывы
  static Future<Response> getUserUpdates() async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    Uri uri = Uri.https(ApiInfo.BASE_URL, "/user/games", {"sort": "desc"});

    var res = await http.get(
      uri,
      headers: headers,
    );
    log("UserApi.getUserUpdates: response statusCode = ${res.statusCode}");
    log("UserApi.getUserUpdates: response body = ${res.body}");

    return res;
  }

  static Future<Response> getUserFriends() async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    var res = await http.get(
      Uri.https(ApiInfo.BASE_URL, "/user/friends"),
      headers: headers,
    );
    log("UserApi.getUserFriends: response statusCode = ${res.statusCode}");
    log("UserApi.getUserFriends: response body = ${res.body}");

    return res;
  }

  static Future<List<SearchUserResult>> getSearchedUsersJson(String search) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    Uri uri = Uri.https(ApiInfo.BASE_URL, "/user/all",
        {"startsWith": search.trim(), "byUser": "true"});

    var res = await http.get(
      uri,
      headers: headers,
    );

    if (res.statusCode != HttpStatus.ok) {
      return null;
    }

    var body = utf8.decode(res.bodyBytes);
    log("UserApi.getSearchedUsersJson: response statusCode = ${res.statusCode}");
    log("UserApi.getSearchedUsersJson: response body = $body");

    Iterable iterableParsedJson = json.decode(body);

    if (iterableParsedJson.isNotEmpty) {
      return List<SearchUserResult>.from(
          iterableParsedJson.map((game) => SearchUserResult.fromJson(game)));
    }
    return List.empty();
  }

  static Future<int> addFriend(int id) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    Response res = await http.get(
      Uri.https(ApiInfo.BASE_URL, "user/friends/add/$id"),
      headers: headers,
    );
    log("UserApi.addFriend: response statusCode = ${res.statusCode}");
    log("UserApi.addFriend: response body = ${res.body}");

    return res.statusCode;
  }

  static Future<int> removeFriend(int id) async {
    var headers = await ApiInfo.defaultAuthorizationHeader();

    var res = await http.get(
      Uri.https(ApiInfo.BASE_URL, "user/friends/remove/$id"),
      headers: headers,
    );
    log("UserApi.removeFriend: response statusCode = ${res.statusCode}");
    log("UserApi.removeFriend: response body = ${res.body}");

    return res.statusCode;
  }
}

class UserDto {
  String username;
  int id;
  String email;
  String firstName;
  String secondName;
  String birthdate;
  String photoPath;
  String gender;
  bool active;

  UserDto({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.secondName,
    this.birthdate,
    this.photoPath,
    this.gender,
    this.active,
  });

  factory UserDto.fromJson(Map<String, dynamic> parsedJson) {
    return UserDto(
      id: parsedJson["id"],
      username: parsedJson["username"],
      email: parsedJson["email"],
      firstName: parsedJson["firstName"],
      secondName: parsedJson["secondName"],
      birthdate: parsedJson["birthdate"],
      photoPath: parsedJson["photoPath"],
      gender: parsedJson["gender"],
      active: parsedJson["active"],
    );
  }
}

class UserResult extends UserDto {
  bool has;

  UserResult({
    String username,
    int id,
    String email,
    String firstName,
    String secondName,
    String birthdate,
    String photoPath,
    String gender,
    bool active,
    this.has,
  }) : super(
          id: id,
          username: username,
          email: email,
          firstName: firstName,
          secondName: secondName,
          birthdate: birthdate,
          photoPath: photoPath,
          gender: gender,
          active: active,
        );

  factory UserResult.fromJson(Map<String, dynamic> parsedJson) {
    return UserResult(
      id: parsedJson["id"],
      username: parsedJson["username"],
      email: parsedJson["email"],
      firstName: parsedJson["firstName"],
      secondName: parsedJson["secondName"],
      birthdate: parsedJson["birthdate"],
      photoPath: parsedJson["photoPath"],
      gender: parsedJson["gender"],
      active: parsedJson["active"],
      has: true,
    );
  }
}

class SearchUserResult extends UserResult {
  SearchUserResult({
    String username,
    int id,
    String email,
    String firstName,
    String secondName,
    String birthdate,
    String photoPath,
    String gender,
    bool active,
    bool has,
  }) : super(
          id: id,
          username: username,
          email: email,
          firstName: firstName,
          secondName: secondName,
          birthdate: birthdate,
          photoPath: photoPath,
          gender: gender,
          active: active,
          has: has,
        );

  factory SearchUserResult.fromJson(Map<String, dynamic> parsedJson) {
    return SearchUserResult(
      id: parsedJson["friend"]["id"],
      username: parsedJson["friend"]["username"],
      email: parsedJson["friend"]["email"],
      firstName: parsedJson["friend"]["firstName"],
      secondName: parsedJson["friend"]["secondName"],
      birthdate: parsedJson["friend"]["birthdate"],
      photoPath: parsedJson["friend"]["photoPath"],
      gender: parsedJson["friend"]["gender"],
      active: parsedJson["friend"]["active"],
      has: parsedJson["has"],
    );
  }
}
