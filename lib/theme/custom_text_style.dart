import 'package:driver_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class CustomTextStyles {
  // Title text style
  static get titleMediumBluegray200 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blueGray200,
      );

  static get titleMediumOnPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumOnPrimaryBold => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumOnPrimary_1 => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );

  static get titleMediumPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );

  static get titleMediumWhiteA700 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w700,
      );

  static get titleSmallBluegray200 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray200,
      );

  static get titleSmallBluegray500 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray500,
      );
}

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get urbanist {
    return copyWith(
      fontFamily: 'Urbanist',
    );
  }
}
