import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/styles.dart';

class CommonListView extends StatelessWidget {
  const CommonListView({
    Key? key,
    required this.context,
    required this.index,
    required this.navigationPath,
    required this.amount,
    required this.networkImageUrl,
    required this.category,
    required this.type,
    required this.fromDashboardStatistics,
  }) : super(key: key);

  final BuildContext context;
  final int index;
  final String navigationPath;
  final int amount;
  final String networkImageUrl;
  final String category;
  final String type;
  final bool fromDashboardStatistics;

  @override
  Widget build(BuildContext context) {
    String categoryIcon = '${category.toLowerCase()}_icon.svg';
    return InkWell(
      onTap: () {},
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10.0, left: 10, right: 10),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    // padding: const EdgeInsets.all(50),
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xffF0F6F5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Align(
                      child: SvgPicture.asset(
                        'assets/icons/$categoryIcon',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        category,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: 'Inter',
                          fontSize: 16.0,
                          // height: 21.78,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        type,
                        style: const TextStyle(
                          color: kSecondaryTextColor,
                          fontFamily: 'Inter',
                          fontSize: 13.0,
                          // height: 21.78,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Text(
                '+ \u20AC $amount',
                style: const TextStyle(
                  color: Color(0xFF25A969),
                  fontFamily: 'Inter',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
