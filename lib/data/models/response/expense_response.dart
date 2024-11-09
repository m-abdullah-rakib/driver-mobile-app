import 'package:driver_app/data/models/response/Income_expense_base_response.dart';

class ExpenseResponse {
  late ExpenseResponseData? data;

  ExpenseResponse({required this.data});

  factory ExpenseResponse.fromJson(Map<dynamic, dynamic> json) {
    return ExpenseResponse(
        data: json['data'] != null
            ? ExpenseResponseData.fromJson(json['data'])
            : null);
  }
}

class ExpenseResponseData extends IncomeExpenseBaseResponse {
  final ExpenseData? expense;

  ExpenseResponseData(
    this.expense, {
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

  factory ExpenseResponseData.fromJson(dynamic json) {
    return ExpenseResponseData(
      json['expense'] != null ? ExpenseData.fromJson(json['expense']) : null,
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

class ExpenseData {
  final int? id;
  final String? type;
  final int? parkingDurationMin;
  final String? fuelVendor;
  final int? fuelVolume;
  final String? fuelDetails;

  ExpenseData({
    required this.id,
    required this.type,
    required this.parkingDurationMin,
    required this.fuelVendor,
    required this.fuelVolume,
    required this.fuelDetails,
  });

  factory ExpenseData.fromJson(dynamic json) {
    return ExpenseData(
      id: json['id'],
      type: json['type'],
      parkingDurationMin: json['parking_duration_min'],
      fuelVendor: json['fuel_vendor'],
      fuelVolume: json['fuel_volume'],
      fuelDetails: json['fuel_details'],
    );
  }
}
