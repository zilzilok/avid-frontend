import 'dart:convert';

import 'package:avid_frontend/screens/auth/api/auth_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthUtils {
  static final _storage = FlutterSecureStorage();

  static Future<String> getJwt() async {
    var jwt = await _storage.read(key: "jwt");
    return jwt;
  }

  static Future<JwtStatus> get checkJwt async {
    var jwt = await getJwt();
    if (jwt == null) {
      return JwtStatus.FIRST_VISIT;
    }

    var attemptRes = await AuthApi.attempt(jwt);
    return attemptRes ? JwtStatus.CORRECT : JwtStatus.INCORRECT;
  }

  static void saveJwt(String jwtJsoned) {
    String jwt = jsonDecode(jwtJsoned)["token"];
    _storage.write(key: "jwt", value: jwt);
  }

  static void deleteJwt() {
    _storage.write(key: "jwt", value: null);
  }
}

enum JwtStatus {
  FIRST_VISIT,
  INCORRECT,
  CORRECT,
}
