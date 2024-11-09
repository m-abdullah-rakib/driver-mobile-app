import 'package:dio/dio.dart';

import '../constants/rest_api_call.dart';

class GetAuthenticatedUserAPI {
  final dio = Dio();

  Future getAuthenticatedUserAPICall(String token) async {
    var authHeader = <String, String>{};
    authHeader['Authorization'] = token;

    var response = await dio.get(
      RestAPICall.baseURL + RestAPICall.getAuthenticatedUserEndPoint,
      options: Options(headers: authHeader),
    );

    return response;
  }
}
