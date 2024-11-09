import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response/free_cars_response.dart';
import '../../data/repositories/get_all_cars_repository.dart';

part 'get_all_cars_state.dart';

class GetAllCarsCubit extends Cubit<GetAllCarsState> {
  final GetAllCarsRepository getAllCarsRepository = GetAllCarsRepository();
  late FreeCarsResponse freeCarsResponse;

  GetAllCarsCubit() : super(GetAllCarsState(null, null));

  void getAllCars(String token) {
    var getAllCarsAPIResponse = getAllCarsRepository.getAllCars(token);

    getAllCarsAPIResponse.then((value) {
      freeCarsResponse = value;
      emit(GetAllCarsState(freeCarsResponse, null));
    }, onError: (e) {
      emit(GetAllCarsState(null, 'Sorry! Something went wrong.'));
    });
  }
}
