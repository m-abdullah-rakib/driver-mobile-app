import 'package:flutter/material.dart';

const kPrimaryColor = Color(0XFF438883);
const kRectangularCurvedBackground = Color(0xFF429690);

const kFormFieldBorder = Color(0xFFDDDDDD);
const kGradientOne = Color(0xFF429690);
const kGradientTwo = Color(0xFF2A7C76);
const kGradientThree = Color(0xFFED6969);
const kGradientFour = Color(0xFFBE3838);
const kTeal_50 = Color(0xFFE0F2F1);
const kTeal_200 = Color(0xFF80CBC4);
const kHeadlineTextColor = Color(0xFF222222);
const kSecondaryTextColor = Color(0xFF666666);
const kWhiteTextColor = Color(0xFFFFFFFF);
const kGradientRedShadow = Color(0xFFF59494);
const kGradientPrimaryShadow = Color(0xFF73A8A6);
const kAmountErrorBackground = Color(0xFFFFDBDB);
const kChangeCarListBackground = Color(0xFFF2F3FA);
const kWelcomeBackground = Color(0xFF275E5D);

const kGradientPrimary = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [
    0.0,
    1.0,
  ],
  colors: [
    kGradientOne,
    kGradientTwo,
  ],
);

const kGradientRed = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [
    0.0,
    1.0,
  ],
  colors: [
    kGradientThree,
    kGradientFour,
  ],
);

const kGradientInvoicePrompt = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [
    0.0,
    1.0,
  ],
  colors: [
    Color(0xFFD7D7D7),
    Color(0xFFC0C0C0),
  ],
);

const kCurvedStyle = BoxDecoration(
  gradient: kGradientPrimary,
);

const kRectangularCurvedStyle = BoxDecoration(
  color: kRectangularCurvedBackground,
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(10.0),
    bottomRight: Radius.circular(10.0),
    topLeft: Radius.circular(10.0),
    topRight: Radius.circular(10.0),
  ),
);

const kCaptionTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
const kDescriptionTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.white,
);

const kFormFieldTextStyle = TextStyle(
  color: kSecondaryTextColor,
  fontFamily: 'Inter',
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
);

const kFormFieldInputTextStyle = TextStyle(
  color: kSecondaryTextColor,
  fontFamily: 'Inter',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const kHeadlineTextStyle = TextStyle(
  color: kHeadlineTextColor,
  fontFamily: 'Inter',
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
);

const kErrorTextStyle = TextStyle(
  color: kGradientFour,
  fontFamily: 'Urbanist',
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
);

const kDialogTitleTextStyle = TextStyle(
  color: kHeadlineTextColor,
  fontFamily: 'Urbanist',
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
);

const kDialogValueTextStyle = TextStyle(
  color: kSecondaryTextColor,
  fontFamily: 'Urbanist',
  fontSize: 16.0,
  fontWeight: FontWeight.w600,
);

const kProfileMenuListTextStyle = TextStyle(
  color: kSecondaryTextColor,
  fontFamily: 'Inter',
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
);
