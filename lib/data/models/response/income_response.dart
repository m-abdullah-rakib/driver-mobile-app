import 'package:driver_app/data/models/response/Income_expense_base_response.dart';

class IncomeResponse {
  late IncomeResponseData? data;

  IncomeResponse({required this.data});

  factory IncomeResponse.fromJson(Map<dynamic, dynamic> json) {
    return IncomeResponse(
        data: json['data'] != null
            ? IncomeResponseData.fromJson(json['data'])
            : null);
  }
}

class IncomeResponseData extends IncomeExpenseBaseResponse {
  final IncomeData? income;

  IncomeResponseData(
    this.income, {
    required super.id,
    required super.date,
    required super.amount,
    required super.remark,
    required super.invoiceFilePath,
    required super.lat,
    required super.long,
    required super.userId,
    required super.carId,
    required super.type,
    required super.incomeId,
    required super.expenseId,
    required super.status,
  });

  factory IncomeResponseData.fromJson(dynamic json) {
    return IncomeResponseData(
      json['income'] != null ? IncomeData.fromJson(json['income']) : null,
      id: json['id'],
      date: json['date'],
      amount: json['amount'],
      remark: json['remark'],
      invoiceFilePath: json['invoice_file_path'],
      lat: json['lat'],
      long: json['long'],
      userId: json['userId'],
      carId: json['carId'],
      type: json['type'],
      incomeId: json['incomeId'],
      expenseId: json['expenseId'],
      status: json['status'],
    );
  }
}

class IncomeData {
  final int? id;
  final String? type;
  final int? tips;
  final int? offer;

  IncomeData({
    required this.id,
    required this.type,
    required this.tips,
    required this.offer,
  });

  factory IncomeData.fromJson(dynamic json) {
    return IncomeData(
      id: json['id'],
      type: json['type'],
      tips: json['tips'],
      offer: json['offer'],
    );
  }
}
