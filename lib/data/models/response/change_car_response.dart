class ChangeCarResponse {
  late String? data;

  ChangeCarResponse({required this.data});

  factory ChangeCarResponse.fromJson(Map<dynamic, dynamic> json) {
    return ChangeCarResponse(
      data: json['data'],
    );
  }
}
