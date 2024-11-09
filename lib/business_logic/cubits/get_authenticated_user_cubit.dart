import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response/get_authenticated_user_response.dart';
import '../../data/repositories/get_authenticated_user_repository.dart';
import 'cohort_cubit.dart';

part 'get_authenticated_user_state.dart';

class GetAuthenticatedUserCubit extends Cubit<GetAuthenticatedUserState> {
  final GetAuthenticatedUserRepository getAuthenticatedUserRepository =
  GetAuthenticatedUserRepository();
  late GetAuthenticatedUserResponse getAuthenticatedUserResponse;

  GetAuthenticatedUserCubit() : super(GetAuthenticatedUserState(null, null));

  getAuthenticatedUser(String token, BuildContext context) {
    var getAuthenticatedUserAPIResponse =
        getAuthenticatedUserRepository.getAuthenticatedUser(token);

    getAuthenticatedUserAPIResponse.then((value) {
      getAuthenticatedUserResponse = value;
      emit(GetAuthenticatedUserState(getAuthenticatedUserResponse, null));
      DateTime dateTime = DateTime.now();
      String year = dateTime.year.toString();
      int month = dateTime.month - 1;
      BlocProvider.of<CohortCubit>(context)
          .getCohortData(token, context, year, month);
    }, onError: (e) {
      emit(GetAuthenticatedUserState(null, 'Sorry! Something went wrong.'));
    });
  }
}
