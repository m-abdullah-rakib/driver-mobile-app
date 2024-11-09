import 'package:driver_app/theme/styles.dart';
import 'package:flutter/material.dart';

class ElevatedButtonPrimary extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;
  final bool isExpense;

  const ElevatedButtonPrimary({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 64.0,
    required this.gradient,
    required this.isExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0.0, 10.0), //(x,y)
            blurRadius: 20.0,
            color: isExpense ? kGradientRedShadow : kGradientPrimaryShadow,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: child,
      ),
    );
  }
}
