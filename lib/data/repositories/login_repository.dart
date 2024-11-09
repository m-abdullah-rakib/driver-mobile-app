import 'package:driver_app/data/data_providers/login_api.dart';

import '../models/request/login_request.dart';
import '../models/response/login_response.dart';

class LoginRepository {
  final LoginAPI loginAPI = LoginAPI();

  Future driverLogin(LoginRequest loginRequest) async {
    var rawResponse = await loginAPI.driverLoginAPICall(loginRequest);
    if (rawResponse.statusCode == 200) {
      final LoginResponse loginResponse =
          LoginResponse.fromJson(rawResponse.data);

      return loginResponse;
    } else {
      return rawResponse;
    }
  }
}
