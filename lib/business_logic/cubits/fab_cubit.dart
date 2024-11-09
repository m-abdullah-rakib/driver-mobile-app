import 'package:flutter_bloc/flutter_bloc.dart';

part 'fab_state.dart';

class FabCubit extends Cubit<FabState> {
  FabCubit() : super(FabState(true));

  showFab() => emit(FabState(true));

  hideFab() => emit(FabState(false));
}
