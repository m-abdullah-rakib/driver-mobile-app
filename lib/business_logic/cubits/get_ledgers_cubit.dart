import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/response/get_ledgers_response.dart';
import '../../data/repositories/get_ledgers_repository.dart';

part 'get_ledgers_state.dart';

class GetLedgersCubit extends Cubit<GetLedgersState> {
  final GetLedgersRepository getLedgersRepository = GetLedgersRepository();
  late GetLedgersResponse getLedgersResponse;

  GetLedgersCubit() : super(GetLedgersState(null, null));

  void getLedgers(String token, BuildContext context, int month) {
    var getLedgersAPIResponse =
        getLedgersRepository.getLedgers(token, context, month);

    getLedgersAPIResponse.then((value) {
      getLedgersResponse = value;
      emit(GetLedgersState(getLedgersResponse, null));
    }, onError: (e) {
      emit(GetLedgersState(null, 'Sorry! Something went wrong.'));
    });
  }
}
