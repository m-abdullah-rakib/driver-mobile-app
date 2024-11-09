import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PromptItem extends StatelessWidget {
  const PromptItem({
    Key? key,
    required this.gradient,
    required this.icon,
    required this.title,
    required this.titleFontSize,
    required this.containerHeight,
    required this.containerWeight,
    required this.iconHeight,
    required this.iconWeight,
  }) : super(key: key);

  final Gradient gradient;
  final String icon;
  final String title;
  final double titleFontSize;
  final double containerHeight;
  final double containerWeight;
  final double iconHeight;
  final double iconWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      height: containerHeight,
      width: containerWeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: iconWeight,
            height: iconHeight,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: titleFontSize,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
