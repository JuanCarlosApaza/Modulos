import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'ring_gauge.dart';

class WasteProcessingCard extends StatelessWidget {
  const WasteProcessingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waste Processing Level',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: RingGauge(
                value: 0.72,
                size: 150,
                strokeWidth: 16,
                progressColor: AppColors.brandGreen,
                trackColor: AppColors.textPrimary.withOpacity(0.85),
                startAngleDegrees: -90,
                sweepDegrees: 360,
                center: const Text(
                  '72%',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text.rich(
              TextSpan(
                text: 'Deviation Index ',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                children: [
                  TextSpan(
                    text: '2%',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
