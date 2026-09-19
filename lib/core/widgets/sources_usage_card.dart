import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class _CountryStat {
  final String name;
  final String pct;
  final Color dot;
  const _CountryStat(this.name, this.pct, this.dot);
}

const _countries = [
  _CountryStat('Ukraine', '89%', AppColors.mapHighest),
  _CountryStat('Belgium', '82%', AppColors.mapHigh),
  _CountryStat('Latvia', '85%', AppColors.mapHigh),
  _CountryStat('Spain', '80%', AppColors.mapMed),
  _CountryStat('Italia', '79%', AppColors.mapMed),
  _CountryStat('Portugal', '76%', AppColors.mapLow),
];

/// "Sources Usage in Manufacturing" card. The map area is a simplified,
/// stylised abstraction (not a geographically accurate map) evoking a
/// heat-map of renewable-source usage by country.
class SourcesUsageCard extends StatelessWidget {
  const SourcesUsageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final narrow = constraints.maxWidth < 420;
        final listAndTitle = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sources Usage in Manufacturing',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Percentage of renewable energy sources used in manufacturing industries.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 14),
            ..._countries.map((c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: c.dot, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text('${c.name} - ',
                          style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary)),
                      Text(c.pct,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                )),
          ],
        );

        final map = _MapIllustration(constraints: constraints, narrow: narrow);

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              listAndTitle,
              const SizedBox(height: 16),
              SizedBox(height: 160, child: map),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: listAndTitle),
            const SizedBox(width: 16),
            Expanded(flex: 4, child: SizedBox(height: 190, child: map)),
          ],
        );
      }),
    );
  }
}

class _MapIllustration extends StatelessWidget {
  final BoxConstraints constraints;
  final bool narrow;
  const _MapIllustration({required this.constraints, required this.narrow});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.pageBg,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CustomPaint(painter: _HeatBlobsPainter()),
          ),
        ),
        Positioned(
          top: 14,
          right: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.brandGreenDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Ukraine',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                Text('High Level  89%',
                    style: TextStyle(color: AppColors.textOnDarkMuted, fontSize: 10)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Abstract cluster of soft rounded "heat" shapes standing in for a map,
/// since no real geographic data/asset is used here.
class _HeatBlobsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blobs = [
      (Offset(size.width * 0.30, size.height * 0.30), size.width * 0.22, AppColors.mapLow),
      (Offset(size.width * 0.55, size.height * 0.22), size.width * 0.18, AppColors.mapMed),
      (Offset(size.width * 0.68, size.height * 0.45), size.width * 0.24, AppColors.mapHighest),
      (Offset(size.width * 0.42, size.height * 0.55), size.width * 0.20, AppColors.mapHigh),
      (Offset(size.width * 0.22, size.height * 0.65), size.width * 0.16, AppColors.mapMed),
      (Offset(size.width * 0.80, size.height * 0.75), size.width * 0.14, AppColors.mapLow),
    ];

    for (final (center, radius, color) in blobs) {
      final paint = Paint()..color = color.withOpacity(0.85);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HeatBlobsPainter oldDelegate) => false;
}
