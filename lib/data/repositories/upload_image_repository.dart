import 'package:dio/dio.dart';

import '../data_providers/upload_image_api.dart';
import '../models/response/upload_image_response.dart';

class UploadImageRepository {
  final UploadImageAPI uploadImageAPI = UploadImageAPI();

  Future<UploadImageResponse> uploadImage(FormData uploadImageFormData) async {
    var rawResponse =
        await uploadImageAPI.uploadImageAPICall(uploadImageFormData);
    print(rawResponse.data.toString());
    final UploadImageResponse uploadImageResponse =
        UploadImageResponse.fromJson(rawResponse.data);

    return uploadImageResponse;
  }
}
