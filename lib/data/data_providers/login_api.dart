import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/rest_api_call.dart';
import '../models/request/login_request.dart';

class LoginAPI {
  final dio = Dio();

  Future driverLoginAPICall(LoginRequest loginRequest) async {
    var response = await dio.post(
      RestAPICall.baseURL + RestAPICall.loginEndPoint,
      data: jsonEncode(loginRequest.toJson()),
      options: Options(
        validateStatus: (status) {
          return status == 200 || status == 401;
        },
      ),
    );

    return response;
  }
}
