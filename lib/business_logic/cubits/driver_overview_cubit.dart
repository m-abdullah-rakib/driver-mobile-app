import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response/driver_overview_response.dart';
import '../../data/repositories/driver_overview_repository.dart';

part 'driver_overview_state.dart';

class DriverOverviewCubit extends Cubit<DriverOverviewState> {
  final DriverOverviewRepository driverOverviewRepository =
      DriverOverviewRepository();
  late DriverOverviewResponse driverOverviewResponse;

  DriverOverviewCubit() : super(DriverOverviewState(null, null));

  getDriverOverviewData(String token, BuildContext context, int month) {
    var driverOverviewAPIResponse =
        driverOverviewRepository.getDriverOverview(token, context, month);

    driverOverviewAPIResponse.then((value) {
      driverOverviewResponse = value;
      emit(DriverOverviewState(driverOverviewResponse, null));
    });
  }

  emitLoadingState() {
    emit(DriverOverviewState(null, null));
  }
}
