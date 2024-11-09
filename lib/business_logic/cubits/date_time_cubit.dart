import 'package:flutter_bloc/flutter_bloc.dart';

part 'date_time_state.dart';

class DateTimeCubit extends Cubit<DateTimeState> {
  DateTimeCubit() : super(DateTimeState(true));

  changeDateState() => emit(DateTimeState(true));
}
