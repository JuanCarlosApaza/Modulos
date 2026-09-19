import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CommunityBanner extends StatelessWidget {
  const CommunityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brandGreenDark, Color(0xFF163F32)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(Icons.eco_rounded, size: 96, color: Colors.white.withOpacity(0.08)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.eco_rounded, color: AppColors.brandGreen, size: 16),
                      SizedBox(width: 6),
                      Text('AeuxGlobal',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Icon(Icons.north_east_rounded, color: Colors.white, size: 18),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                "Let's join our\ncommunity",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, height: 1.2),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 28,
                    child: Stack(
                      children: List.generate(3, (i) {
                        return Positioned(
                          left: i * 18.0,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.brandGreen.withOpacity(0.6 + i * 0.1),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('230k+ people',
                      style: TextStyle(color: AppColors.textOnDarkMuted, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
