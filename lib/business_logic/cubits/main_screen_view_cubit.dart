import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/pages/home_page.dart';

part 'main_screen_view_state.dart';

class MainScreenViewCubit extends Cubit<MainScreenViewState> {
  MainScreenViewCubit() : super(MainScreenViewState(const HomePage()));

  setCurrentPage(Widget widget) => emit(MainScreenViewState(widget));
}
