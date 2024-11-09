import 'package:driver_app/utilities/app_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/constants/rest_api_call.dart';
import '../screens/sign_in_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.fabBottomAppBarKey});

  final GlobalKey<FABBottomAppBarState> fabBottomAppBarKey;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences sharedPreferences;
  FABBottomAppBarState? fabBottomAppBarState;

  @override
  void initState() {
    super.initState();

    initInstance();
  }

  Future<void> initInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    fabBottomAppBarState = widget.fabBottomAppBarKey.currentState;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: kGradientPrimary,
                      ),
                      height: (MediaQuery.of(context).size.height) * 0.40,
                      padding: const EdgeInsets.only(
                        top: 85,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: const Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Profile',
                                style: TextStyle(
                                  color: kWhiteTextColor,
                                  fontFamily: 'Inter',
                                  fontSize: 18.0,
                                  // height: 21.78,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      BlocBuilder<GetAuthenticatedUserCubit,
                          GetAuthenticatedUserState>(
                        builder: (context, state) {
                          return state.getAuthenticatedUserResponse?.data !=
                                  null
                              ? Column(
                                  children: [
                                    Text(
                                      state.getAuthenticatedUserResponse!.data!
                                          .name!,
                                      style: const TextStyle(
                                        color: kHeadlineTextColor,
                                        fontFamily: 'Inter',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                height: 5,
                              ),
                              Text(
                                state.getAuthenticatedUserResponse?.data
                                                  ?.car?.model !=
                                              null
                                          ? state.getAuthenticatedUserResponse!
                                              .data!.car!.model
                                          : 'No car assigned.',
                                      style: const TextStyle(
                                        color: kPrimaryColor,
                                        fontFamily: 'Inter',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(),
                                );
                        },
                      ),
                      const Divider(
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                        color: Color(0xFFEEF2F6),
                      ),
                      BlocBuilder<GetAuthenticatedUserCubit,
                          GetAuthenticatedUserState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/car-details-screen',
                                arguments: state.getAuthenticatedUserResponse
                                            ?.data?.car !=
                                        null
                                    ? [
                                        RestAPICall.getImage +
                                            state.getAuthenticatedUserResponse!
                                                .data!.car!.image,
                                        state.getAuthenticatedUserResponse?.data
                                            ?.car?.id
                                            .toString(),
                                        state.getAuthenticatedUserResponse?.data
                                            ?.car?.model,
                                        state.getAuthenticatedUserResponse?.data
                                            ?.car?.license
                                      ]
                                    : [
                                        'Car image not available',
                                        'Not available',
                                        'Not available',
                                        'Not available'
                                      ],
                              );
                              BlocProvider.of<FabCubit>(context).hideFab();
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/vehicle_details.svg',
                                      width: 24.0,
                                      height: 24.0,
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    const Text(
                                      "Vehicle Details",
                                      style: kProfileMenuListTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/personal-profile-screen',
                          );
                          BlocProvider.of<FabCubit>(context).hideFab();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/personal_profile.svg',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                const Text(
                                  "Personal Profile",
                                  style: kProfileMenuListTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/login-and-security-screen',
                          );
                          BlocProvider.of<FabCubit>(context).hideFab();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/login_and_security.svg',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                const Text(
                                  "Change Password",
                                  style: kProfileMenuListTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sharedPreferences.setString('authToken', '');
                          sharedPreferences.setString('userLoggedIn', '');
                          BlocProvider.of<FabCubit>(context).hideFab();
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => SignInScreen()),
                            (route) => false,
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/logout.svg',
                                  width: 24.0,
                                  height: 24.0,
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                const Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: kGradientFour,
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                child: SvgPicture.asset(
                  'assets/images/ellipse_7.svg',
                  width: 212.0,
                  height: 212.0,
                ),
              ),
              Positioned(
                left: 140,
                child: SvgPicture.asset(
                  'assets/images/ellipse_9.svg',
                  width: 85.0,
                  height: 85.0,
                ),
              ),
              Positioned(
                left: 70,
                child: SvgPicture.asset(
                  'assets/images/ellipse_8.svg',
                  width: 127.0,
                  height: 127.0,
                ),
              ),
              Positioned(
                top: (MediaQuery.of(context).size.height) * 0.31,
                left: (MediaQuery.of(context).size.width) * 0.33,
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: BlocBuilder<GetAuthenticatedUserCubit,
                        GetAuthenticatedUserState>(
                      builder: (context, state) {
                        return CircleAvatar(
                          backgroundImage:
                              state.getAuthenticatedUserResponse?.data?.image !=
                                      null
                                  ? NetworkImage(RestAPICall.getImage +
                                      state.getAuthenticatedUserResponse!.data!
                                          .image)
                                  : null,
                          backgroundColor: kPrimaryColor,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleBackPressed() {
    fabBottomAppBarState!.updateIndex(0);
  }
}
