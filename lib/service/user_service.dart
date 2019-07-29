import 'package:dio/dio.dart';
import 'package:erply_app_assignment/constants/app_constants.dart';
import 'package:erply_app_assignment/model/api_response.dart';
import 'package:erply_app_assignment/model/user_details_model.dart';

import 'auth_service.dart';

class UserService {
  Response response;
  APIResponse apiResponse = APIResponse();
  AuthService authService = AuthService();

  Dio dio = new Dio(BaseOptions(baseUrl: KBaseAPI));

  Future<APIResponse> sendUserDetails(UserDetailsModel userDetails) async {
    try {
      String jwtToken = await authService.getCurrentUserJwt();
      response = await dio.post('capture',
          data: userDetails.toJson(),
          options: Options(headers: {"AUTHORIZATION": jwtToken}));

      apiResponse.isSuccess = response.statusCode == 200;
      apiResponse.data = response.data;
      apiResponse.message = response.statusMessage;
    } on Exception catch (e) {
      apiResponse.isSuccess = false;
    }

    return apiResponse;
  }
}
