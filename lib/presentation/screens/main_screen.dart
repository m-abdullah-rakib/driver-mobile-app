import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/storage_data_provider.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';

GlobalKey<FABBottomAppBarState> fabBottomAppBarKey =
    GlobalKey<FABBottomAppBarState>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  StorageDataProvider tokenProvider = StorageDataProvider();
  String token = '';

  void _selectedTab(int index) {
    setState(() {
      if (index == 0) {
        BlocProvider.of<MainScreenViewCubit>(context)
            .setCurrentPage(const HomePage());
      } else if (index == 1) {
        BlocProvider.of<MainScreenViewCubit>(context)
            .setCurrentPage(ProfilePage(
          fabBottomAppBarKey: fabBottomAppBarKey,
        ));
      }
      // else if (index == 2) {
      //   BlocProvider.of<MainScreenViewCubit>(context)
      //       .setCurrentPage(const HistoryPage(fromHomePage: false));
      // } else if (index == 3) {
      //   BlocProvider.of<MainScreenViewCubit>(context)
      //       .setCurrentPage(const ProfilePage());
      // }
    });
  }

  @override
  void initState() {
    super.initState();

    getToken();
  }

  getToken() async {
    token = await tokenProvider.retrieveToken();
    getUserData();
  }

  getUserData() {
    BlocProvider.of<GetAuthenticatedUserCubit>(context)
        .getAuthenticatedUser(token, context);
    BlocProvider.of<GetAllCarsCubit>(context).getAllCars(token);
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FabCubit>(context).showFab();

    return BlocBuilder<MainScreenViewCubit, MainScreenViewState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: state.widget,
          bottomNavigationBar: FABBottomAppBar(
            key: fabBottomAppBarKey,
            centerItemText: '',
            color: const Color(0xFFAAAAAA),
            selectedColor: kPrimaryColor,
            notchedShape: const CircularNotchedRectangle(),
            onTabSelected: _selectedTab,
            items: [
              FABBottomAppBarItem(iconData: Icons.home_filled),
              // FABBottomAppBarItem(iconData: Icons.stacked_bar_chart),
              // FABBottomAppBarItem(iconData: Icons.sticky_note_2_rounded),
              FABBottomAppBarItem(iconData: Icons.person_outline_outlined),
            ],
            backgroundColor: Colors.white,
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildFab(context),
        );
      },
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.sms];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 70,
        width: 70,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 2.0), //(x,y)
              blurRadius: 4.0,
              color: kGradientPrimaryShadow,
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
