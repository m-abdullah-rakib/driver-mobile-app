import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'month_year_state.dart';

class MonthYearCubit extends Cubit<MonthYearState> {
  MonthYearCubit()
      : super(MonthYearState(DateFormat('MMM, yyyy').format(DateTime.now()),
            DateTime.now().month, DateTime.now()));

  changeMonthYear(
          String monthYear, int month, DateTime cohortCalendarInitialDate) =>
      emit(MonthYearState(monthYear, month, cohortCalendarInitialDate));
}
