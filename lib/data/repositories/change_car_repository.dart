import '../data_providers/change_car_api.dart';
import '../models/request/change_car_request.dart';
import '../models/response/change_car_response.dart';

class ChangeCarRepository {
  final ChangeCarAPI changeCarAPI = ChangeCarAPI();

  Future<ChangeCarResponse> changeCar(ChangeCarRequest changeCarRequest) async {
    var rawResponse = await changeCarAPI.changeCarAPICall(changeCarRequest);
    final ChangeCarResponse changeCarResponse =
        ChangeCarResponse.fromJson(rawResponse.data);

    return changeCarResponse;
  }
}
