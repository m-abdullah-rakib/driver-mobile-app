import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response/cohort_response.dart';
import '../../data/repositories/cohort_repository.dart';
import 'driver_overview_cubit.dart';
import 'get_ledgers_cubit.dart';

part 'cohort_state.dart';

class CohortCubit extends Cubit<CohortState> {
  final CohortRepository cohortRepository = CohortRepository();
  late CohortResponse cohortResponse;

  CohortCubit() : super(CohortState(null, null));

  getCohortData(String token, BuildContext context, String year, int month) {
    var cohortAPIResponse = cohortRepository.getCohortData(token, year);

    cohortAPIResponse.then((value) {
      cohortResponse = value;
      emit(CohortState(cohortResponse, null));
      BlocProvider.of<DriverOverviewCubit>(context)
          .getDriverOverviewData(token, context, month);
      BlocProvider.of<GetLedgersCubit>(context)
          .getLedgers(token, context, month);
    }, onError: (e) {
      emit(CohortState(null, 'Sorry! Something went wrong.'));
    });
  }

  updateCurrentCohort(CohortResponse cohortResponse) {
    emit(CohortState(cohortResponse, null));
  }
}
