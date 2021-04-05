import 'package:avid_frontend/screens/auth/components/auth_utils.dart';

class ApiInfo {
  static const String BASE_URL = "avid-rest-api.herokuapp.com";

  static Future<Map<String, String>> defaultAuthorizationHeader() async {
    var authEntry = await authorizationEntry();

    var headers = {
      "content-type": "application/json; charset=utf-8",
    };
    headers.addAll(authEntry);

    return headers;
  }

  static Future<Map<String, String>> authorizationEntry() async {
    String jwt = await AuthUtils.getJwt();

    return {"Authorization": "Bearer " + jwt};
  }
}
