import 'package:driver_app/data/models/response/driver_overview_response.dart';
import 'package:flutter/material.dart';

import '../data_providers/driver_overview_api.dart';

class DriverOverviewRepository {
  final DriverOverviewAPI driverOverviewAPI = DriverOverviewAPI();

  Future getDriverOverview(
      String token, BuildContext context, int month) async {
    var rawResponse =
        await driverOverviewAPI.driverOverviewAPICall(token, context, month);
    final DriverOverviewResponse driverOverviewResponse =
        DriverOverviewResponse.fromJson(rawResponse.data);

    return driverOverviewResponse;
  }
}
