import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundedIconPlaceholder extends StatelessWidget {
  const RoundedIconPlaceholder({
    super.key,
    required this.icon,
  });

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xffF0F6F5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
          topLeft: Radius.circular(50.0),
          topRight: Radius.circular(50.0),
        ),
      ),
      child: Align(
        child: SvgPicture.asset(
          icon,
        ),
      ),
    );
  }
}
