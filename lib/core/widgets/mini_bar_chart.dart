import 'package:flutter/material.dart';

/// Tiny inline bar chart used inside the KPI cards at the top of the
/// dashboard (e.g. "Air Pollution Level", "Investments in Clean Tech").
class MiniBarChart extends StatelessWidget {
  final List<double> values; // 0..1 normalized heights
  final Color color;
  final double width;
  final double height;

  const MiniBarChart({
    super.key,
    required this.values,
    required this.color,
    this.width = 64,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _MiniBarPainter(values: values, color: color),
      ),
    );
  }
}

class _MiniBarPainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _MiniBarPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final barCount = values.length;
    const gapRatio = 0.35;
    final barWidth = size.width / (barCount + (barCount - 1) * gapRatio);
    final gap = barWidth * gapRatio;

    for (var i = 0; i < barCount; i++) {
      final v = values[i].clamp(0.0, 1.0);
      final barHeight = size.height * v;
      final left = i * (barWidth + gap);
      final top = size.height - barHeight;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, barHeight),
        Radius.circular(barWidth / 2.2),
      );
      final paint = Paint()
        ..color = i == barCount - 1 ? color : color.withOpacity(0.45);
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniBarPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}
