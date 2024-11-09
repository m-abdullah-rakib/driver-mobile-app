import 'expense_response.dart';
import 'income_response.dart';

class GetLedgersResponse {
  late List<GetLedgersResponseData>? data;

  GetLedgersResponse({required this.data});

  factory GetLedgersResponse.fromJson(Map<dynamic, dynamic> json) {
    return GetLedgersResponse(
        data:
            json['data'] != null ? getLedgersResponseData(json['data']) : null);
  }

  static getLedgersResponseData(json) {
    List<GetLedgersResponseData> getLedgersResponseDataList =
        List<GetLedgersResponseData>.from(
            json.map((value) => GetLedgersResponseData.fromJson(value)));
    return getLedgersResponseDataList;
  }
}

class GetLedgersResponseData {
  final int? id;
  final String? date;
  final int? amount;
  final String? remark;
  final String? invoiceFilePath;
  final num? lat;
  final num? long;
  final int? revenuePercentage;
  final int? userId;
  final int? carId;
  final String? type;
  final int? incomeId;
  final int? expenseId;
  final IncomeData? income;
  final ExpenseData? expense;

  GetLedgersResponseData({
    required this.id,
    required this.date,
    required this.amount,
    required this.remark,
    required this.invoiceFilePath,
    required this.lat,
    required this.long,
    required this.revenuePercentage,
    required this.userId,
    required this.carId,
    required this.type,
    required this.incomeId,
    required this.expenseId,
    required this.income,
    required this.expense,
  });

  factory GetLedgersResponseData.fromJson(dynamic json) {
    return GetLedgersResponseData(
      id: json['id'],
      date: json['date'],
      amount: json['amount'],
      remark: json['remark'],
      invoiceFilePath: json['invoice_file_path'],
      lat: json['lat'],
      long: json['long'],
      revenuePercentage: json['revenue_percentage'],
      userId: json['userId'],
      carId: json['carId'],
      type: json['type'],
      incomeId: json['incomeId'],
      expenseId: json['expenseId'],
      income:
          json['income'] != null ? IncomeData.fromJson(json['income']) : null,
      expense: json['expense'] != null
          ? ExpenseData.fromJson(json['expense'])
          : null,
    );
  }
}
