import 'dart:convert';

import 'package:dio/dio.dart';

import '../../utilities/storage_data_provider.dart';
import '../constants/rest_api_call.dart';
import '../models/request/expense_request.dart';

class ExpenseAPI {
  final dio = Dio();
  StorageDataProvider tokenProvider = StorageDataProvider();

  Future createExpenseAPICall(ExpenseRequest expenseRequest) async {
    print(jsonEncode(expenseRequest.toJson()));
    var response = await dio.post(
      RestAPICall.baseURL + RestAPICall.expenseEndPoint,
      data: jsonEncode(expenseRequest.toJson()),
      options: Options(headers: await tokenProvider.retrieveHeader()),
    );

    return response;
  }
}
