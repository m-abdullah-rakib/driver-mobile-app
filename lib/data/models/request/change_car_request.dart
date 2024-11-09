class ChangeCarRequest {
  late int? carId;

  ChangeCarRequest(this.carId);

  Map<String, dynamic> toJson() => {
        'carId': carId,
      };
}
