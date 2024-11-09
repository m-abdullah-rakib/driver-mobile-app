import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cohort_cubit.dart';
import '../cubits/date_time_cubit.dart';
import '../cubits/driver_overview_cubit.dart';
import '../cubits/fab_cubit.dart';
import '../cubits/form_dropdown_cubit.dart';
import '../cubits/form_field_validation_cubit.dart';
import '../cubits/get_all_cars_cubit.dart';
import '../cubits/get_authenticated_user_cubit.dart';
import '../cubits/get_ledgers_cubit.dart';
import '../cubits/income_expense_category_cubit.dart';
import '../cubits/income_expense_cubit.dart';
import '../cubits/internet_cubit.dart';
import '../cubits/invoice_cubit.dart';
import '../cubits/login_form_validation_cubit.dart';
import '../cubits/main_screen_view_cubit.dart';
import '../cubits/month_year_cubit.dart';
import '../cubits/obscure_text_cubit.dart';

class BlocsProvidersList {
  List<BlocProvider> getBlocsList(Connectivity connectivity) {
    final List<BlocProvider> providersList = [
      BlocProvider<FabCubit>(
        create: (context) => FabCubit(),
      ),
      BlocProvider<IncomeExpenseCubit>(
        create: (context) => IncomeExpenseCubit(),
      ),
      BlocProvider<IncomeExpenseCategoryCubit>(
        create: (context) => IncomeExpenseCategoryCubit(
            icon: '',
            title: '',
            setCardSize: 0.0,
            setErrorCardSize: 0.0,
            fixButtonPosition: 0.0,
            fixErrorButtonPosition: 0.0,
            hasError: false),
      ),
      BlocProvider<FormDropdownCubit>(
        create: (context) =>
            FormDropdownCubit(firstDropdownTitle: '', secondDropdownTitle: ''),
      ),
      BlocProvider<FormFieldValidationCubit>(
        create: (context) => FormFieldValidationCubit(
            hasAmountFieldError: false, hasTipsFieldError: false),
      ),
      BlocProvider<LoginFormValidationCubit>(
        create: (context) => LoginFormValidationCubit(
            hasEmailFieldError: false, hasPasswordFieldError: false),
      ),
      BlocProvider<ObscureTextCubit>(
        create: (context) => ObscureTextCubit(),
      ),
      BlocProvider<InvoiceCubit>(
        create: (context) => InvoiceCubit(),
      ),
      BlocProvider<DateTimeCubit>(
        create: (context) => DateTimeCubit(),
      ),
      BlocProvider<GetAuthenticatedUserCubit>(
        create: (context) => GetAuthenticatedUserCubit(),
      ),
      BlocProvider<CohortCubit>(
        create: (context) => CohortCubit(),
      ),
      BlocProvider<DriverOverviewCubit>(
        create: (context) => DriverOverviewCubit(),
      ),
      BlocProvider<GetLedgersCubit>(
        create: (context) => GetLedgersCubit(),
      ),
      BlocProvider<MainScreenViewCubit>(
        create: (context) => MainScreenViewCubit(),
      ),
      BlocProvider<GetAllCarsCubit>(
        create: (context) => GetAllCarsCubit(),
      ),
      BlocProvider<MonthYearCubit>(
        create: (context) => MonthYearCubit(),
      ),
      BlocProvider<InternetCubit>(
        create: (context) => InternetCubit(connectivity: connectivity),
      ),
    ];

    return providersList;
  }
}
