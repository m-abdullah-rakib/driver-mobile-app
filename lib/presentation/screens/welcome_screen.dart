import 'package:driver_app/presentation/screens/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/styles.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  List<ContentConfig> listContentConfig = [];
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    listContentConfig.add(
      const ContentConfig(
        description: "Drive smarter knowing \nthe best route and \ntime to go",
        textAlignDescription: TextAlign.start,
        styleDescription: TextStyle(
          color: Colors.white,
          fontFamily: 'Urbanist',
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
        pathImage: "assets/images/slide_1.png",
        backgroundColor: kWelcomeBackground,
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        description: "Hassel free cash and account management",
        textAlignDescription: TextAlign.start,
        styleDescription: TextStyle(
          color: Colors.white,
          fontFamily: 'Urbanist',
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
        pathImage: "assets/images/slide_2.png",
        backgroundColor: kWelcomeBackground,
      ),
    );
    listContentConfig.add(
      const ContentConfig(
        description: "All of your data in in one place",
        textAlignDescription: TextAlign.start,
        styleDescription: TextStyle(
          color: Colors.white,
          fontFamily: 'Urbanist',
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
        ),
        pathImage: "assets/images/slide_3.png",
        backgroundColor: kWelcomeBackground,
      ),
    );

    initInstance();
  }

  Future<void> initInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('welcomeStatus', 'WELCOME_SHOWED');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IntroSlider(
          key: UniqueKey(),
          listContentConfig: listContentConfig,
          onDonePress: onDonePress,
          indicatorConfig: const IndicatorConfig(
              colorIndicator: Colors.white60,
              colorActiveIndicator: Colors.white),
          isShowNextBtn: false,
          isShowSkipBtn: false,
          isShowPrevBtn: false,
          renderDoneBtn: const Text(
            "DONE",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Positioned(
          top: 60.0,
          right: 20.0,
          child: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => SignInScreen()),
                (route) => false,
              );
            },
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Urbanist',
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onDonePress() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => SignInScreen()),
      (route) => false,
    );
  }
}
