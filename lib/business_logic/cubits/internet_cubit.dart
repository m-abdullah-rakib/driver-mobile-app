import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/constants/enums/connection_type.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;

  InternetCubit({required this.connectivity}) : super(InternetLoading());

  void emitInternetConnected(InternetConnection internetConnection) =>
      emit(InternetConnected(internetConnection: internetConnection));

  void emitInternetDisconnected() => emit(InternetDisconnected());
}
