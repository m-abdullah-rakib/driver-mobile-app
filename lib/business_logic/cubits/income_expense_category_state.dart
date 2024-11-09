part of 'income_expense_category_cubit.dart';

class IncomeExpenseCategoryState {
  String icon;
  String title;
  double setCardSize;
  double fixButtonPosition;
  double setErrorCardSize;
  double fixErrorButtonPosition;
  bool hasError;

  IncomeExpenseCategoryState(
      this.icon,
      this.title,
      this.setCardSize,
      this.setErrorCardSize,
      this.fixButtonPosition,
      this.fixErrorButtonPosition,
      this.hasError);
}
