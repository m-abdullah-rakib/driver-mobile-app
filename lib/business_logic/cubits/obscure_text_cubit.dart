import 'package:flutter_bloc/flutter_bloc.dart';

part 'obscure_text_state.dart';

class ObscureTextCubit extends Cubit<ObscureTextState> {
  ObscureTextCubit() : super(ObscureTextState(true));

  toggleObscureTextState(bool toggleState) =>
      emit(ObscureTextState(toggleState));
}
