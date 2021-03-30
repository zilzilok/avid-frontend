import 'package:avid_frontend/screens/auth/components/auth_exception.dart';
import 'package:avid_frontend/screens/auth/components/auth_utils.dart';

class ApiInfo {
  static const String BASE_URL = "avid-rest-api.herokuapp.com";

  static Future<Map<String, String>> defaultAuthorizationHeader() async {
    var authEntry;
    try {
      authEntry = await authorizationEntry();
    } catch (e) {
      throw e;
    }

    var headers = {
      "content-type": "application/json",
    };
    headers.addAll(authEntry);

    return headers;
  }

  static Future<Map<String, String>> authorizationEntry() async {
    String jwt = await AuthUtils.checkAndGetJwt();
    if (jwt == null) {
      throw AuthException("Incorrect jwt.");
    }

    return {"Authorization": "Bearer " + jwt};
  }
}
