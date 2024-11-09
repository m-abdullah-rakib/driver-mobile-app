class LoginAndSecurityRequest {
  late String password;
  late String newPassword;

  LoginAndSecurityRequest(this.password, this.newPassword);

  Map<String, dynamic> toJson() =>
      {'password': password, 'newPassword': newPassword};
}
