import 'dart:convert';

import 'package:dio/dio.dart';

import '../../utilities/storage_data_provider.dart';
import '../constants/rest_api_call.dart';
import '../models/request/change_car_request.dart';

class ChangeCarAPI {
  final dio = Dio();
  StorageDataProvider tokenProvider = StorageDataProvider();

  Future changeCarAPICall(ChangeCarRequest changeCarRequest) async {
    var response = await dio.patch(
      RestAPICall.baseURL + RestAPICall.changeCarEndPoint,
      data: jsonEncode(changeCarRequest.toJson()),
      options: Options(headers: await tokenProvider.retrieveHeader()),
    );

    return response;
  }
}
