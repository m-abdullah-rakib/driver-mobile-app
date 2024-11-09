import 'package:driver_app/data/repositories/change_car_repository.dart';
import 'package:driver_app/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubits/main_screen_view_cubit.dart';
import '../../data/models/response/change_car_response.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ChangeCarRepository changeCarRepository = ChangeCarRepository();
  late ChangeCarResponse changeCarResponse;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBackPressed();
        return false;
      },
      child: const Scaffold(
          body: Padding(
        padding: EdgeInsets.only(
          top: 85,
          left: 20.0,
          right: 20.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Statistics',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Inter',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Nothing to show now.'),
                    Text('This feature will come soon.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void handleBackPressed() {
    BlocProvider.of<MainScreenViewCubit>(context)
        .setCurrentPage(const HomePage());
  }
}
