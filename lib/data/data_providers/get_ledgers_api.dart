import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../business_logic/cubits/cohort_cubit.dart';
import '../../business_logic/cubits/get_authenticated_user_cubit.dart';
import '../constants/rest_api_call.dart';

class GetLedgersAPI {
  final dio = Dio();

  Future getLedgersAPICall(
      String token, BuildContext context, int month) async {
    GetAuthenticatedUserCubit getAuthenticatedUserCubit =
        BlocProvider.of<GetAuthenticatedUserCubit>(context);
    GetAuthenticatedUserState getAuthenticatedUserState =
        getAuthenticatedUserCubit.state;
    CohortCubit cohortCubit = BlocProvider.of<CohortCubit>(context);
    CohortState cohortState = cohortCubit.state;

    DateTime startDateTime = DateFormat('EEEE, MMM d, yyyy')
        .parse(cohortState.cohortResponse!.data![month].start);
    DateTime endDateTime = DateFormat('EEEE, MMM d, yyyy')
        .parse(cohortState.cohortResponse!.data![month].end);

    var authHeader = <String, String>{};
    authHeader['Authorization'] = token;

    Map<String, dynamic> queryParams = {
      'userId':
          getAuthenticatedUserState.getAuthenticatedUserResponse?.data?.id,
      'limit': 10,
      'order': 'desc',
      'start': startDateTime,
      'end': endDateTime,
    };

    var response = await dio.get(
      RestAPICall.baseURL + RestAPICall.getLedgersEndPoint,
      options: Options(headers: authHeader),
      queryParameters: queryParams,
    );

    return response;
  }
}
