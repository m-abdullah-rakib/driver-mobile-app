import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driver_app/business_logic/blocs/blocs_provider.dart';
import 'package:driver_app/month_year_picker-0.3.0+1/lib/month_year_picker.dart';
import 'package:driver_app/presentation/router/app_router.dart';
import 'package:driver_app/theme/styles.dart';
import 'package:driver_app/utilities/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String navigationPath = await getWelcomeStatus();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = kPrimaryColor
    ..backgroundColor = Colors.white
    ..indicatorColor = kGradientFour
    ..textColor = Colors.black
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;

  runApp(MyApp(
    connectivity: Connectivity(),
    appRouter: AppRouter(),
    navigationPath: navigationPath,
  ));
}

Future<String> getWelcomeStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String welcomeStatus = prefs.getString('welcomeStatus') ?? '';
  String userLoginStatus = prefs.getString('userLoggedIn') ?? '';
  prefs.setInt('cohortMonth', 0);

  if (welcomeStatus != 'WELCOME_SHOWED') {
    return '/welcome-screen';
  } else if (userLoginStatus == 'USER_LOGGED_IN') {
    return '/main-screen';
  } else {
    return '/sign-in-screen';
  }
}

class MyApp extends StatefulWidget {
  final Connectivity connectivity;
  final AppRouter appRouter;
  final String navigationPath;

  const MyApp({
    super.key,
    required this.connectivity,
    required this.appRouter,
    required this.navigationPath,
  });

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  BlocsProvidersList blocsList = BlocsProvidersList();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: blocsList.getBlocsList(widget.connectivity),
          child: MaterialApp(
            title: 'Driver App',
            onGenerateRoute: widget.appRouter.onGenerateRoute,
            initialRoute: widget.navigationPath,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
            localizationsDelegates: [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              MonthYearPickerLocalizations.delegate,
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.appRouter.dispose();
    super.dispose();
  }
}
