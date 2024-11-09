class DriverOverviewResponse {
  late DriverOverviewResponseData? data;

  DriverOverviewResponse({required this.data});

  factory DriverOverviewResponse.fromJson(Map<dynamic, dynamic> json) {
    return DriverOverviewResponse(
        data: json['data'] != null
            ? DriverOverviewResponseData.fromJson(json['data'])
            : null);
  }
}

class DriverOverviewResponseData {
  late Expense? expense;
  late Income? income;

  DriverOverviewResponseData({
    required this.expense,
    required this.income,
  });

  factory DriverOverviewResponseData.fromJson(Map<dynamic, dynamic> json) {
    return DriverOverviewResponseData(
      expense:
          json['expense'] != null ? Expense.fromJson(json['expense']) : null,
      income: json['income'] != null ? Income.fromJson(json['income']) : null,
    );
  }
}

class Expense {
  final num? total;

  Expense({required this.total});

  factory Expense.fromJson(dynamic json) {
    return Expense(total: json['total']);
  }
}

class Income {
  final num? total;
  final num? driverIncome;
  final num? avgRevenuePercentage;

  Income({
    required this.total,
    required this.driverIncome,
    required this.avgRevenuePercentage,
  });

  factory Income.fromJson(dynamic json) {
    return Income(
      total: json['total'],
      driverIncome: json['driver_income'],
      avgRevenuePercentage: json['avg_revenue_percentage'],
    );
  }
}
