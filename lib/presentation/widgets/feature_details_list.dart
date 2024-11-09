import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/styles.dart';

class FeatureDetailsList extends StatelessWidget {
  const FeatureDetailsList({
    Key? key,
    required this.context,
    required this.svgAssetPath,
    required this.title,
    required this.property,
  }) : super(key: key);

  final BuildContext context;
  final String svgAssetPath;
  final String title;
  final String property;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kChangeCarListBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
        child: SizedBox(
          width: double.infinity,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SvgPicture.asset(
                    svgAssetPath,
                    width: 36.01,
                    height: 36.01,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 71.52,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontFamily: 'Inter',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          property,
                          style: const TextStyle(
                            color: Color(0xFF808080),
                            fontFamily: 'Urbanist',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
