import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_field_validation_state.dart';

class FormFieldValidationCubit extends Cubit<FormFieldValidationState> {
  bool hasAmountFieldError;
  bool hasTipsFieldError;

  FormFieldValidationCubit({
    required this.hasAmountFieldError,
    required this.hasTipsFieldError,
  }) : super(FormFieldValidationState(hasAmountFieldError, hasTipsFieldError));

  setAmountFieldErrorStatus(bool hasAmountFieldError) {
    this.hasAmountFieldError = hasAmountFieldError;

    emit(FormFieldValidationState(this.hasAmountFieldError, false));
  }

  setTipsFieldErrorStatus(bool hasTipsFieldError) {
    this.hasTipsFieldError = hasTipsFieldError;

    emit(FormFieldValidationState(false, this.hasTipsFieldError));
  }
}
