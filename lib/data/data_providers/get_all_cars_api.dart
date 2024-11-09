import 'package:dio/dio.dart';

import '../constants/rest_api_call.dart';

class GetAllCarsAPI {
  final dio = Dio();

  Future getAllCarsAPICall(String token) async {
    var authHeader = <String, String>{};
    authHeader['Authorization'] = token;

    Map<String, dynamic> queryParams = {
      'type': 'FREE',
      'status': 'ACTIVE',
    };

    var response = await dio.get(
      RestAPICall.baseURL + RestAPICall.getAllCarsEndPoint,
      options: Options(headers: authHeader),
      queryParameters: queryParams,
    );

    return response;
  }
}
