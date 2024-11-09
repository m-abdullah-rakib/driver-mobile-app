import 'dart:convert';

import 'package:dio/dio.dart';

import '../../utilities/storage_data_provider.dart';
import '../constants/rest_api_call.dart';
import '../models/request/income_request.dart';

class IncomeAPI {
  final dio = Dio();
  StorageDataProvider tokenProvider = StorageDataProvider();

  Future createIncomeAPICall(IncomeRequest incomeRequest) async {
    print(jsonEncode(incomeRequest.toJson()));
    var response = await dio.post(
      RestAPICall.baseURL + RestAPICall.incomeEndPoint,
      data: jsonEncode(incomeRequest.toJson()),
      options: Options(headers: await tokenProvider.retrieveHeader()),
    );

    return response;
  }
}
