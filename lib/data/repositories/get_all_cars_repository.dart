import '../data_providers/get_all_cars_api.dart';
import '../models/response/free_cars_response.dart';

class GetAllCarsRepository {
  final GetAllCarsAPI getAllCarsAPI = GetAllCarsAPI();

  Future getAllCars(String token) async {
    var rawResponse = await getAllCarsAPI.getAllCarsAPICall(token);
    final FreeCarsResponse freeCarsResponse =
        FreeCarsResponse.fromJson(rawResponse.data);

    return freeCarsResponse;
  }
}
