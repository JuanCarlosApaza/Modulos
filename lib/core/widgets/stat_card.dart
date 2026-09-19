import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'mini_bar_chart.dart';

/// One of the three top KPI cards: "Air Pollution Level",
/// "Environmental Quality Index", "Investments in Clean Technologies".
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String changeLabel;
  final bool isPositive;
  final List<double> barValues;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.changeLabel,
    required this.isPositive,
    required this.barValues,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor = isPositive ? AppColors.positiveGreen : AppColors.negativeRed;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14,
                      color: trendColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      changeLabel,
                      style: TextStyle(
                        color: trendColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          MiniBarChart(values: barValues, color: trendColor),
        ],
      ),
    );
  }
}
