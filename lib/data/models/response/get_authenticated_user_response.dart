class GetAuthenticatedUserResponse {
  late GetAuthenticatedUserData? data;

  GetAuthenticatedUserResponse({required this.data});

  factory GetAuthenticatedUserResponse.fromJson(Map<dynamic, dynamic> json) {
    return GetAuthenticatedUserResponse(
        data: json['data'] != null
            ? GetAuthenticatedUserData.fromJson(json['data'])
            : null);
  }
}

class GetAuthenticatedUserData {
  final int id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String dateOfBirth;
  final String image;
  final String driverLicense;
  final int revenuePercentage;
  final String? drivingLicenceExpiryDate;
  final String? drivingLicenceNumber;
  final String? rouloFilePath;
  final String? kbNumber;
  final String? kbExpiryDate;
  final String? professionalDriverLicense;
  final String? status;
  final GetAuthenticatedUserDataCar? car;

  GetAuthenticatedUserData({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.dateOfBirth,
    required this.image,
    required this.driverLicense,
    required this.revenuePercentage,
    required this.drivingLicenceExpiryDate,
    required this.drivingLicenceNumber,
    required this.rouloFilePath,
    required this.kbNumber,
    required this.kbExpiryDate,
    required this.professionalDriverLicense,
    required this.status,
    required this.car,
  });

  factory GetAuthenticatedUserData.fromJson(dynamic json) {
    return GetAuthenticatedUserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      dateOfBirth: json['date_of_birth'],
      image: json['image'],
      driverLicense: json['driver_license'],
      revenuePercentage: json['revenue_percentage'],
      drivingLicenceExpiryDate: json['driving_licence_expiry_date'],
      drivingLicenceNumber: json['driving_licence_number'],
      rouloFilePath: json['roulo_file_path'],
      kbNumber: json['kb_number'],
      kbExpiryDate: json['kb_expiry_date'],
      professionalDriverLicense: json['professional_driver_license'],
      status: json['status'],
      car: json['car'] != null
          ? GetAuthenticatedUserDataCar.fromJson(json['car'])
          : null,
    );
  }
}

class GetAuthenticatedUserDataCar {
  final int? id;
  final String model;
  final String license;
  final String image;
  final String status;
  final String? licenseExpiryDate;
  final String? insuranceNumber;
  final String? insuranceExpiryDate;
  final String? fitnessExpiryDate;
  final String? nccLicenseExpiryDate;
  final String? plateNumber;
  final int userId;

  GetAuthenticatedUserDataCar(
      {required this.id,
      required this.model,
      required this.license,
      required this.image,
      required this.status,
      required this.licenseExpiryDate,
      required this.insuranceNumber,
      required this.insuranceExpiryDate,
      required this.fitnessExpiryDate,
      required this.nccLicenseExpiryDate,
      required this.plateNumber,
      required this.userId});

  factory GetAuthenticatedUserDataCar.fromJson(dynamic json) {
    return GetAuthenticatedUserDataCar(
      id: json['id'],
      model: json['model'],
      license: json['license'],
      image: json['image'],
      status: json['status'],
      licenseExpiryDate: json['license_expiry_date'],
      insuranceNumber: json['insurance_number'],
      insuranceExpiryDate: json['insurance_expiry_date'],
      fitnessExpiryDate: json['fitness_expiry_date'],
      nccLicenseExpiryDate: json['ncc_license_expiry_date'],
      plateNumber: json['plate_number'],
      userId: json['userId'],
    );
  }
}
