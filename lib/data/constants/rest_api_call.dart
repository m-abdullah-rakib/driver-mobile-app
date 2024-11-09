class RestAPICall {
  /// Live
  // static const String baseURL =
  //     "https://cashflow.backend.test.inovetix.com/";

  /// Test
  static const String baseURL = "https://cashflow.backend.test.inovetix.com/";

  static const String loginEndPoint = "auth/login";
  static const String getAuthenticatedUserEndPoint = "auth";
  static const String getAllCarsEndPoint = "car";
  static const String changeCarEndPoint = "car/change/";
  static const String incomeEndPoint = "income";
  static const String expenseEndPoint = "expense";
  static const String uploadImageEndPoint = "image";
  static const String cohortEndPoint = "cohort/";
  static const String getDriverOverviewEndPoint = "ledger/driver";
  static const String getLedgersEndPoint = "ledger";
  static const String changePassEndPoint = "user/password";
  static const String resetPinLinkEndPoint = "auth/reset";

  static const String updateProfileEndPoint = "user/";
  static const String getImage = "${baseURL}uploads/";
}
