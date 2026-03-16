import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_theme.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  // Koordinat Ka'bah (Makkah)
  static const double _kabbaLat = 21.422487;
  static const double _kabbaLng = 39.826206;

  // Placeholder untuk lokasi saat ini (Jakarta)
  // Nantinya diganti dengan Geolocator
  static const double _currentLat = -6.2088;
  static const double _currentLng = 106.8456;

  double _qiblaDirection = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateQibla();
  }

  void _calculateQibla() {
    // Menghitung arah kiblat menggunakan spherical trigonometry
    final latK = _kabbaLat * math.pi / 180.0;
    final lngK = _kabbaLng * math.pi / 180.0;
    final lat = _currentLat * math.pi / 180.0;
    final lng = _currentLng * math.pi / 180.0;

    final dLng = lngK - lng;

    final y = math.sin(dLng);
    final x = math.cos(lat) * math.tan(latK) - math.sin(lat) * math.cos(dLng);

    var qibla = math.atan2(y, x) * 180.0 / math.pi;
    if (qibla < 0) qibla += 360.0;

    setState(() {
      _qiblaDirection = qibla;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Kompas Qibla', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: _buildCompass(),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Gagal membaca sensor kompas', style: TextStyle(color: AppColors.error)),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        double? direction = snapshot.data?.heading;

        if (direction == null) {
          return const Center(
            child: Text('Perangkat tidak memiliki sensor kompas', style: TextStyle(color: AppColors.textSecondary)),
          );
        }

        // Qibla direction relative to North is _qiblaDirection
        // So the qibla indicator should point to _qiblaDirection - direction
        final qiblaAngle = (_qiblaDirection - direction) * (math.pi / 180);

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Arah Kiblat',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_qiblaDirection.toStringAsFixed(1)}°',
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Dari Utara',
              style: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring (Kompas) diputar sesuai arah mata angin
                  Transform.rotate(
                    angle: (direction * (math.pi / 180) * -1),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.darkBorder, width: 2),
                      ),
                      child: Stack(
                        children: [
                          _buildCompassMark('N', 0, color: AppColors.error),
                          _buildCompassMark('E', math.pi / 2),
                          _buildCompassMark('S', math.pi),
                          _buildCompassMark('W', 3 * math.pi / 2),
                        ],
                      ),
                    ),
                  ),

                  // Ka'bah indicator diputar ke arah qibla relatf terhadap hp
                  Transform.rotate(
                    angle: qiblaAngle,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: AppColors.gold, size: 40),
                        Container(
                          width: 4,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(2),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.gold, AppColors.gold.withOpacity(0.0)],
                            ),
                          ),
                        ),
                        const SizedBox(height: 120), // offset dari center
                      ],
                    ),
                  ),
                  
                  // Center dot
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Jauhkan perangkat dari benda magnetik untuk kalibrasi yang lebih baik.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCompassMark(String label, double radians, {Color? color}) {
    return Align(
      alignment: Alignment(
        math.sin(radians),
        -math.cos(radians), // negatif agar 0 radian = atas (North)
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          label,
          style: TextStyle(
            color: color ?? AppColors.textSecondary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
