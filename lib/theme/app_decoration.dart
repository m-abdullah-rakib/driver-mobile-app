import 'package:driver_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class AppDecoration {
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700,
      );
}

class BorderRadiusStyle {}

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;
