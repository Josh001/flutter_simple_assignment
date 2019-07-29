import 'package:dio/dio.dart';
import 'package:erply_app_assignment/constants/app_constants.dart';
import 'package:erply_app_assignment/model/auth_response_model.dart';
import 'package:erply_app_assignment/model/user_login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility.dart';

abstract class IAuthService {
  Future<dynamic> isUserSessionActive();
}

class AuthService implements IAuthService {
  Response response;
  Dio dio = new Dio(BaseOptions(baseUrl: KAUTHBaseAPI));

  Future<bool> isUserSessionActive() async {
    var sharedPref = await SharedPreferences.getInstance();
    var currentJwt = sharedPref.get(KCurrentJwtKey);
    var currentJwtExp = sharedPref.get(KCurrentJwtExpKey);
    if (currentJwt == null) return false;
    if (DateTime.now().difference(DateTime.parse(currentJwtExp)) >
        Duration(seconds: 0)) return false;
    return true;
  }

  Future<String> getCurrentUserJwt() async {
    var shPref = await SharedPreferences.getInstance();
    var currentJwt = shPref.get(KCurrentJwtKey);
    return currentJwt;
  }

  Future<AuthResponseModel> authenticateUser(UserLoginModel user) async {
    var formData = {
      "parameters[email]": user.userEmail,
      "parameters[password]": user.password
    };

    AuthResponseModel authResponseModel;
    try {
      var coded = Utility.encodeMap(formData);

      response = await dio.post(KLoginAPI + "?$coded", data: null);

      print(response.data);
      var error = response.data["error"];
      var result = response.data["result"];

      var jwtToken = result != null ? result["jwt"] : "";
      var errorMessage = error["message"] != null ? error["message"] : "";
      var isSuccess = error["code"] == null ? true : false;

      authResponseModel = AuthResponseModel(jwtToken, errorMessage, isSuccess);
    } on Exception catch (e) {
      print(e.toString());
      authResponseModel = AuthResponseModel(null, KGenericError, false);
    }
    return authResponseModel;
  }

  void persistJwtToken(String jwt) async {
    var sharedPref = await SharedPreferences.getInstance();
    var today = DateTime.now();
    sharedPref.setString(KCurrentJwtKey, jwt);
    sharedPref.setString(
        KCurrentJwtExpKey, today.add(Duration(hours: 23)).toString());
  }
}
