class UploadImageResponse {
  final String data;

  UploadImageResponse({required this.data});

  factory UploadImageResponse.fromJson(Map<dynamic, dynamic> json) {
    return UploadImageResponse(
      data: json['data'],
    );
  }
}
