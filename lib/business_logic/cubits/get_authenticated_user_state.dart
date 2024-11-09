part of 'get_authenticated_user_cubit.dart';

class GetAuthenticatedUserState {
  GetAuthenticatedUserResponse? getAuthenticatedUserResponse;
  String? hasError;

  GetAuthenticatedUserState(this.getAuthenticatedUserResponse, this.hasError);
}
