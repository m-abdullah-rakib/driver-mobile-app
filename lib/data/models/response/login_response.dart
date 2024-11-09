class LoginResponse {
  late LoginResponseData? data;

  LoginResponse({required this.data});

  factory LoginResponse.fromJson(Map<dynamic, dynamic> json) {
    return LoginResponse(
        data: json['data'] != null
            ? LoginResponseData.fromJson(json['data'])
            : null);
  }
}

class LoginResponseData {
  final String token;

  LoginResponseData({required this.token});

  factory LoginResponseData.fromJson(dynamic json) {
    return LoginResponseData(token: json['token']);
  }
}
