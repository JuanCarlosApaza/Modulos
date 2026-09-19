import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class _EnergySource {
  final String name;
  final String pct;
  final Color color;
  const _EnergySource(this.name, this.pct, this.color);
}

const _sources = [
  _EnergySource('Solar Energy', '52%', AppColors.brandGreen),
  _EnergySource('Hydropower', '22%', Color(0xFF5FD1A0)),
  _EnergySource('Wind Energy', '12%', Color(0xFFBFEBD8)),
];

class RenewableEnergyCard extends StatelessWidget {
  const RenewableEnergyCard({super.key});

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
            'Renewable Energy',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            '86%',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          ..._sources.map((s) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(s.name, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                    ),
                    Text(s.pct,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ],
                ),
              )),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.cardBorder),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }
}
