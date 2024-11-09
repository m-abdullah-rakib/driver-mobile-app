class ExpenseRequest {
  final String? type;
  final String? date;
  final num? amount;
  final String? remark;
  final int? parkingDurationMin;
  String? fuelVendor;
  int? fuelVolume;
  final String? fuelDetails;
  String? invoiceFilePath;
  final int? carId;
  final num? lat;
  final num? long;

  ExpenseRequest(
    this.type,
    this.date,
    this.amount,
    this.remark,
    this.parkingDurationMin,
    this.fuelVendor,
    this.fuelVolume,
    this.fuelDetails,
    this.invoiceFilePath,
    this.carId,
    this.lat,
    this.long,
  );

  Map<String, dynamic> toJson() => {
        'type': type,
        'date': date,
        'amount': amount,
        'remark': remark,
        'parking_duration_min': parkingDurationMin,
        'fuel_vendor': fuelVendor,
        'fuel_volume': fuelVolume,
        'fuel_details': fuelDetails,
        'invoice_file_path': invoiceFilePath,
        'carId': carId,
        'lat': lat,
        'long': long,
      };
}
