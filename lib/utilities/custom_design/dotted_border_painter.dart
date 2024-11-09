import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/styles.dart';

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kFormFieldBorder // Border color
      ..strokeWidth = 1 // Border width
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, size.height),
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft: const Radius.circular(10),
          bottomRight: const Radius.circular(10),
        ),
      );

    const double dashWidth = 4; // Adjust the width of the dashes
    const double dashSpace = 1; // Adjust the space between dashes

    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0;
      bool draw = true;
      while (distance < pathMetric.length) {
        Path extractPath = pathMetric
            .extractPath(distance, distance + dashWidth, startWithMoveTo: true);
        if (draw) {
          canvas.drawPath(extractPath, paint);
        }
        distance += dashWidth + dashSpace;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
