import 'package:dio/dio.dart';
import 'package:driver_app/business_logic/cubits/get_authenticated_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../business_logic/cubits/cohort_cubit.dart';
import '../constants/rest_api_call.dart';

class DriverOverviewAPI {
  final dio = Dio();

  Future driverOverviewAPICall(
      String token, BuildContext context, int month) async {
    CohortCubit cohortCubit = BlocProvider.of<CohortCubit>(context);
    CohortState cohortState = cohortCubit.state;
    GetAuthenticatedUserCubit getAuthenticatedUserCubit =
        BlocProvider.of<GetAuthenticatedUserCubit>(context);
    GetAuthenticatedUserState getAuthenticatedUserState =
        getAuthenticatedUserCubit.state;

    var authHeader = <String, String>{};
    authHeader['Authorization'] = token;

    DateTime startDateTime = DateFormat('EEEE, MMM d, yyyy')
        .parse(cohortState.cohortResponse!.data![month].start);
    DateTime endDateTime = DateFormat('EEEE, MMM d, yyyy')
        .parse(cohortState.cohortResponse!.data![month].end);

    String startDateTimeIsoString = startDateTime.toIso8601String();
    String endDateTimeIsoString = endDateTime.toIso8601String();

    Map<String, dynamic> queryParams = {
      'start': startDateTimeIsoString,
      'end': endDateTimeIsoString,
      'id': getAuthenticatedUserState.getAuthenticatedUserResponse!.data!.id,
    };

    var response = await dio.get(
      RestAPICall.baseURL + RestAPICall.getDriverOverviewEndPoint,
      options: Options(headers: authHeader),
      queryParameters: queryParams,
    );

    return response;
  }
}
