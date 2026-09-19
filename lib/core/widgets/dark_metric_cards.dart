import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'ring_gauge.dart';

/// Shared dark-card shell used for the small metric tiles at the bottom
/// of the dashboard (Climate Change Index, Water level in Dnipro).
class _DarkTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;

  const _DarkTile({required this.leading, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.darkCardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: AppColors.textOnDarkMuted, fontSize: 11.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClimateChangeIndexTile extends StatelessWidget {
  const ClimateChangeIndexTile({super.key});

  @override
  Widget build(BuildContext context) {
    return _DarkTile(
      leading: RingGauge(
        value: 0.762,
        size: 52,
        strokeWidth: 5,
        progressColor: const Color(0xFFE8604C),
        trackColor: const Color(0xFF1B4437),
        startAngleDegrees: -90,
        sweepDegrees: 360,
        center: const Text('76.2',
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
      ),
      title: 'Climate Change Index',
      subtitle: 'Impact of anthropogenic activities on climate',
    );
  }
}

class WaterLevelTile extends StatelessWidget {
  const WaterLevelTile({super.key});

  @override
  Widget build(BuildContext context) {
    return _DarkTile(
      leading: RingGauge(
        value: 0.57,
        size: 52,
        strokeWidth: 5,
        progressColor: AppColors.brandGreen,
        trackColor: const Color(0xFF1B4437),
        startAngleDegrees: -90,
        sweepDegrees: 360,
        center: const Text('57m',
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      ),
      title: 'Water level in Dnipro',
      subtitle: 'Water level value in m with ice melting.',
    );
  }
}
