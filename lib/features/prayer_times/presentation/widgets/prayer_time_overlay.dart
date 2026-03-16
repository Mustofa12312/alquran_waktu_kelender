import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_theme.dart';

class PrayerTimeOverlay extends StatelessWidget {
  final String prayerName;

  const PrayerTimeOverlay({super.key, required this.prayerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/prayer_time.json', // Placeholder, using icon if not exists
              width: 200,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.mosque,
                size: 100,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Waktu $prayerName Telah Tiba',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mari tegakkan shalat tepat waktu',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}
