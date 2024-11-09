class IncomeRequest {
  final String? type;
  final String? date;
  final num? amount;
  final num? tips;
  final String? remark;
  final num? offer;
  String? invoiceFilePath;
  final num? lat;
  final num? long;

  IncomeRequest(
    this.type,
    this.date,
    this.amount,
    this.tips,
    this.remark,
    this.offer,
    this.invoiceFilePath,
    this.lat,
    this.long,
  );

  Map<String, dynamic> toJson() => {
        'type': type,
        'date': date,
        'amount': amount,
        'tips': tips,
        'remark': remark,
        'offer': offer,
        'invoice_file_path': invoiceFilePath,
        'lat': lat,
        'long': long,
      };
}
