import 'package:dio/dio.dart';

import '../../utilities/storage_data_provider.dart';
import '../constants/rest_api_call.dart';

class UploadImageAPI {
  final dio = Dio();
  StorageDataProvider tokenProvider = StorageDataProvider();

  Future uploadImageAPICall(FormData uploadImageFormData) async {
    var response = await dio.post(
      RestAPICall.baseURL + RestAPICall.uploadImageEndPoint,
      data: uploadImageFormData,
      options: Options(headers: await tokenProvider.retrieveHeader()),
    );

    return response;
  }
}
