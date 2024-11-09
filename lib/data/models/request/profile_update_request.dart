class ProfileUpdateRequest {
  late String email;
  late String name;
  late String phone;
  late String date_of_birth;
  late String image;
  late String driver_license;
  late String driving_licence_number;
  late String roulo_file_path;
  late String kb_number;
  late String kb_expiry_date;
  late String professional_driver_license;

  ProfileUpdateRequest(
    this.email,
    this.name,
    this.phone,
    this.date_of_birth,
    this.image,
    this.driver_license,
    this.driving_licence_number,
    this.roulo_file_path,
    this.kb_number,
    this.kb_expiry_date,
    this.professional_driver_license,
  );

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'phone': phone,
        'date_of_birth': date_of_birth,
        'image': image,
        'driver_license': driver_license,
        'driving_licence_number': driving_licence_number,
        'roulo_file_path': roulo_file_path,
        'kb_number': kb_number,
        'kb_expiry_date': kb_expiry_date,
        'professional_driver_license': professional_driver_license,
      };
}
