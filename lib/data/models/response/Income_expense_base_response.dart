class IncomeExpenseBaseResponse {
  final int? id;
  final String? date;
  final int? amount;
  final String? remark;
  final String? invoiceFilePath;
  final double? lat;
  final double? long;
  final int? userId;
  final int? carId;
  final String? type;
  final int? incomeId;
  final int? expenseId;
  final String? status;

  IncomeExpenseBaseResponse({
    required this.id,
    required this.date,
    required this.amount,
    required this.remark,
    required this.invoiceFilePath,
    required this.lat,
    required this.long,
    required this.userId,
    required this.carId,
    required this.type,
    required this.incomeId,
    required this.expenseId,
    required this.status,
  });
}
