import 'package:flutter/material.dart';

import '../../theme/styles.dart';

class MenuItemForm extends StatelessWidget {
  const MenuItemForm({
    Key? key,
    required this.text,
    this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: kGradientRed,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: kWhiteTextColor,
            padding: const EdgeInsets.all(10),
          ),
          onPressed: press,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: kWhiteTextColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
