class CohortResponse {
  late List<CohortResponseData>? data;

  CohortResponse({required this.data});

  factory CohortResponse.fromJson(Map<dynamic, dynamic> json) {
    return CohortResponse(
        data: json['data'] != null ? cohortResponseData(json['data']) : null);
  }

  static cohortResponseData(json) {
    List<CohortResponseData> cohortResponseDataList =
        List<CohortResponseData>.from(
            json.map((value) => CohortResponseData.fromJson(value)));
    return cohortResponseDataList;
  }
}

class CohortResponseData {
  final String month;
  final String start;
  final String end;

  CohortResponseData({
    required this.month,
    required this.start,
    required this.end,
  });

  factory CohortResponseData.fromJson(dynamic json) {
    return CohortResponseData(
      month: json['month'],
      start: json['start'],
      end: json['end'],
    );
  }
}
