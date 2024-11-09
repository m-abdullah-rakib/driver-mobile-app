class FreeCarsResponse {
  late List<FreeCarResponseData>? data;

  FreeCarsResponse({required this.data});

  factory FreeCarsResponse.fromJson(Map<dynamic, dynamic> json) {
    return FreeCarsResponse(
        data: json['data'] != null
            ? getFreeCarsResponseData(json['data'])
            : null);
  }

  static getFreeCarsResponseData(json) {
    List<FreeCarResponseData> freeCarResponseDataList =
        List<FreeCarResponseData>.from(
            json.map((value) => FreeCarResponseData.fromJson(value)));
    return freeCarResponseDataList;
  }
}

class FreeCarResponseData {
  final int? id;
  final String? model;
  final String? license;
  final String? image;
  final String? status;
  final int? userId;

  FreeCarResponseData({
    required this.id,
    required this.model,
    required this.license,
    required this.image,
    required this.status,
    required this.userId,
  });

  factory FreeCarResponseData.fromJson(dynamic json) {
    return FreeCarResponseData(
      id: json['id'],
      model: json['model'],
      license: json['license'],
      image: json['image'],
      status: json['status'],
      userId: json['userId'],
    );
  }
}
