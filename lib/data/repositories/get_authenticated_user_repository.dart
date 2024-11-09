import '../data_providers/get_authenticated_user_api.dart';
import '../models/response/get_authenticated_user_response.dart';

class GetAuthenticatedUserRepository {
  final GetAuthenticatedUserAPI getAuthenticatedUserAPI =
      GetAuthenticatedUserAPI();

  Future getAuthenticatedUser(String token) async {
    var rawResponse =
        await getAuthenticatedUserAPI.getAuthenticatedUserAPICall(token);
    final GetAuthenticatedUserResponse getAuthenticatedUserResponse =
        GetAuthenticatedUserResponse.fromJson(rawResponse.data);

    return getAuthenticatedUserResponse;
  }
}
