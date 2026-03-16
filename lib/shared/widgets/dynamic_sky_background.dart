import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart' show Prayer;
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';

class DynamicSkyBackground extends StatelessWidget {
  final Prayer currentPrayer;
  final Widget child;

  const DynamicSkyBackground({
    super.key,
    required this.currentPrayer,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getSkyColors(currentPrayer),
        ),
      ),
      child: Stack(
        children: [
          if (currentPrayer == Prayer.isha || currentPrayer == Prayer.fajr || currentPrayer == Prayer.none)
            const _StarsEffect(),
          if (currentPrayer == Prayer.dhuhr || currentPrayer == Prayer.asr)
            const _CloudsEffect(),
          child,
        ],
      ),
    );
  }

  List<Color> _getSkyColors(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)];
      case Prayer.sunrise:
        return [const Color(0xFFfdbb2d), const Color(0xFF22c1c3)];
      case Prayer.dhuhr:
        return [const Color(0xFF2980B9), const Color(0xFF6DD5FA), const Color(0xFFFAFAFA)];
      case Prayer.asr:
        return [const Color(0xFF485563), const Color(0xFF29323c)];
      case Prayer.maghrib:
        return [const Color(0xFFe96443), const Color(0xFF904e95)];
      case Prayer.isha:
        return [const Color(0xFF000000), const Color(0xFF434343)];
      default:
        return [AppColors.darkBg, AppColors.darkSurface];
    }
  }
}

class _StarsEffect extends StatelessWidget {
  const _StarsEffect();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: StarPainter(),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.5);
    final random = math.Random(42); 
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * 0.6;
      final radius = random.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _CloudsEffect extends StatelessWidget {
  const _CloudsEffect();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: Container(
          decoration: const BoxDecoration(
            // Using a simple icon or gradient if image doesn't exist
            gradient: LinearGradient(
              colors: [Colors.white24, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}
