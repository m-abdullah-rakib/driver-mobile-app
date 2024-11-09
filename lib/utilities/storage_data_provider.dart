import 'package:shared_preferences/shared_preferences.dart';

class StorageDataProvider {
  Future<Map<String, String>> retrieveHeader() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var authHeader = <String, String>{};
    authHeader['Authorization'] = sharedPreferences.getString('authToken')!;
    return authHeader;
  }

  Future<String> retrieveToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('authToken')!;
  }

  Future<String> retrieveWelcomeStatus() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('welcomeStatus')!;
  }
}
