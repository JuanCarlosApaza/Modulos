import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Circular progress ring with a rounded stroke, used for:
///  - "Waste Processing Level" (big light-card gauge)
///  - "Climate Change Index" (small dark-card ring)
class RingGauge extends StatelessWidget {
  final double value; // 0..1
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;
  final Widget? center;
  final double startAngleDegrees;
  final double sweepDegrees;

  const RingGauge({
    super.key,
    required this.value,
    this.size = 140,
    this.strokeWidth = 14,
    required this.progressColor,
    required this.trackColor,
    this.center,
    this.startAngleDegrees = -210,
    this.sweepDegrees = 240,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              value: value.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              progressColor: progressColor,
              trackColor: trackColor,
              startAngleDegrees: startAngleDegrees,
              sweepDegrees: sweepDegrees,
            ),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;
  final double startAngleDegrees;
  final double sweepDegrees;

  _RingPainter({
    required this.value,
    required this.strokeWidth,
    required this.progressColor,
    required this.trackColor,
    required this.startAngleDegrees,
    required this.sweepDegrees,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final startRad = startAngleDegrees * math.pi / 180;
    final sweepRad = sweepDegrees * math.pi / 180;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startRad, sweepRad, false, trackPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startRad, sweepRad * value, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.progressColor != progressColor ||
      oldDelegate.trackColor != trackColor;
}
