class ForgotPassRequest {
  late String userInput;

  ForgotPassRequest(this.userInput);

  Map<String, dynamic> toJsonLink() => {'email': userInput};

  Map<String, dynamic> toJsonToken() => {'password': userInput};
}
