import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_dropdown_state.dart';

class FormDropdownCubit extends Cubit<FormDropdownState> {
  String firstDropdownTitle;
  String secondDropdownTitle;

  FormDropdownCubit({
    required this.firstDropdownTitle,
    required this.secondDropdownTitle,
  }) : super(FormDropdownState(firstDropdownTitle, secondDropdownTitle));

  setFirstDropdownTitle(String title) {
    firstDropdownTitle = title;

    emit(FormDropdownState(firstDropdownTitle, secondDropdownTitle));
  }

  setSecondDropdownTitle(String title) {
    secondDropdownTitle = title;

    emit(FormDropdownState(firstDropdownTitle, secondDropdownTitle));
  }
}
