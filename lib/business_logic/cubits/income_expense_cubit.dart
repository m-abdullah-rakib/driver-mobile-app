import 'package:flutter_bloc/flutter_bloc.dart';

part 'income_expense_state.dart';

class IncomeExpenseCubit extends Cubit<IncomeExpenseState> {
  IncomeExpenseCubit() : super(IncomeExpenseState(true));

  isIncomeSelected() => emit(IncomeExpenseState(false));

  isExpenseSelected() => emit(IncomeExpenseState(true));
}
