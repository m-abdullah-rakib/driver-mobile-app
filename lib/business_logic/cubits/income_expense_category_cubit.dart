import 'package:flutter_bloc/flutter_bloc.dart';

part 'income_expense_category_state.dart';

class IncomeExpenseCategoryCubit extends Cubit<IncomeExpenseCategoryState> {
  String icon;
  String title;
  double setCardSize;
  double fixButtonPosition;
  double setErrorCardSize;
  double fixErrorButtonPosition;
  bool hasError;

  IncomeExpenseCategoryCubit({
    required this.icon,
    required this.title,
    required this.setCardSize,
    required this.setErrorCardSize,
    required this.fixButtonPosition,
    required this.fixErrorButtonPosition,
    required this.hasError,
  }) : super(IncomeExpenseCategoryState(
            icon,
            title,
            setCardSize,
            setErrorCardSize,
            fixButtonPosition,
            fixErrorButtonPosition,
            hasError));

  setIncomeCategory(
      String icon,
      String title,
      double setCardSize,
      double setErrorCardSize,
      double fixButtonPosition,
      double fixErrorButtonPosition,
      bool hasError) {
    this.icon = icon;
    this.title = title;
    this.setCardSize = setCardSize;
    this.fixButtonPosition = fixButtonPosition;
    this.fixErrorButtonPosition = fixErrorButtonPosition;
    this.setErrorCardSize = setErrorCardSize;
    this.hasError = hasError;

    emit(IncomeExpenseCategoryState(icon, title, setCardSize, setErrorCardSize,
        fixButtonPosition, fixErrorButtonPosition, hasError));
  }

  setExpenseCategory(
      String icon,
      String title,
      double setCardSize,
      double setErrorCardSize,
      double fixButtonPosition,
      double fixErrorButtonPosition,
      bool hasError) {
    this.icon = icon;
    this.title = title;
    this.setCardSize = setCardSize;
    this.fixButtonPosition = fixButtonPosition;
    this.fixErrorButtonPosition = fixErrorButtonPosition;
    this.setErrorCardSize = setErrorCardSize;
    this.hasError = hasError;

    emit(IncomeExpenseCategoryState(icon, title, setCardSize, setErrorCardSize,
        fixButtonPosition, fixErrorButtonPosition, hasError));
  }
}
