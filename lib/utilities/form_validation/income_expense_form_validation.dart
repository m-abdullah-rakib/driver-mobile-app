import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubits/income_expense_category_cubit.dart';
import '../../business_logic/cubits/income_expense_cubit.dart';

class IncomeExpenseFormValidation {
  static void fieldValidation(
      IncomeExpenseState state,
      IncomeExpenseCategoryState incomeExpenseCategoryState,
      BuildContext context,
      bool status) {
    if (state.isExpense) {
      BlocProvider.of<IncomeExpenseCategoryCubit>(context).setExpenseCategory(
          incomeExpenseCategoryState.icon,
          incomeExpenseCategoryState.title,
          incomeExpenseCategoryState.setCardSize,
          incomeExpenseCategoryState.setErrorCardSize,
          incomeExpenseCategoryState.fixButtonPosition,
          incomeExpenseCategoryState.fixErrorButtonPosition,
          status);
    } else {
      BlocProvider.of<IncomeExpenseCategoryCubit>(context).setIncomeCategory(
          incomeExpenseCategoryState.icon,
          incomeExpenseCategoryState.title,
          incomeExpenseCategoryState.setCardSize,
          incomeExpenseCategoryState.setErrorCardSize,
          incomeExpenseCategoryState.fixButtonPosition,
          incomeExpenseCategoryState.fixErrorButtonPosition,
          status);
    }
  }
}
