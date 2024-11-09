import 'package:flutter/material.dart';

import '../data_providers/get_ledgers_api.dart';
import '../models/response/get_ledgers_response.dart';

class GetLedgersRepository {
  final GetLedgersAPI getLedgersAPI = GetLedgersAPI();

  Future getLedgers(String token, BuildContext context, int month) async {
    var rawResponse =
        await getLedgersAPI.getLedgersAPICall(token, context, month);
    final GetLedgersResponse getLedgersResponse =
        GetLedgersResponse.fromJson(rawResponse.data);

    return getLedgersResponse;
  }
}
