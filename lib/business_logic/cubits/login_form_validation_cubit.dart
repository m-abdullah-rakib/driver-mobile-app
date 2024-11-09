import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_form_validation_state.dart';

class LoginFormValidationCubit extends Cubit<LoginFormValidationState> {
  bool hasEmailFieldError;
  bool hasPasswordFieldError;

  LoginFormValidationCubit({
    required this.hasEmailFieldError,
    required this.hasPasswordFieldError,
  }) : super(LoginFormValidationState(
            hasEmailFieldError, hasPasswordFieldError));

  setEmailFieldErrorStatus(bool hasEmailFieldError) {
    this.hasEmailFieldError = hasEmailFieldError;

    emit(LoginFormValidationState(
        this.hasEmailFieldError, hasPasswordFieldError));
  }

  setPasswordFieldErrorStatus(bool hasPasswordFieldError) {
    this.hasPasswordFieldError = hasPasswordFieldError;

    emit(LoginFormValidationState(
        hasEmailFieldError, this.hasPasswordFieldError));
  }
}
