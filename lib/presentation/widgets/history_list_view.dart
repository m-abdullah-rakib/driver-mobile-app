import 'package:flutter/material.dart';

import '../../theme/styles.dart';

class HistoryListView extends StatelessWidget {
  const HistoryListView({
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
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffFBFBFB),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          border: Border.all(
            color: kPrimaryColor, // Set your desired border color
            width: 1.0, // Set the border width
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
      ),
    );
  }
}
