import 'package:dio/dio.dart';

import '../constants/rest_api_call.dart';

class CohortAPI {
  final dio = Dio();

  Future cohortAPICall(String token, String year) async {
    var authHeader = <String, String>{};
    authHeader['Authorization'] = token;

    var response = await dio.get(
      RestAPICall.baseURL + RestAPICall.cohortEndPoint + year,
      options: Options(headers: authHeader),
    );

    return response;
  }
}
