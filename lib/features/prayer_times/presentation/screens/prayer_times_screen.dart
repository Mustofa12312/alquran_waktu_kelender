import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'dart:ui';
import '../../../../core/theme/app_theme.dart';
import '../providers/location_provider.dart';
import '../providers/prayer_times_provider.dart';
import '../../../../shared/widgets/dynamic_sky_background.dart';
import '../widgets/prayer_time_overlay.dart';
import 'package:adhan/adhan.dart' show Prayer;

class PrayerTimesScreen extends ConsumerStatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  ConsumerState<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends ConsumerState<PrayerTimesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPrayer = ref.watch(currentPrayerProvider);

    // Listen to prayer changes to show overlay
    ref.listen(currentPrayerProvider, (previous, next) {
      if (next != Prayer.none && next != previous) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PrayerTimeOverlay(prayerName: _getPrayerName(next)),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: DynamicSkyBackground(
        currentPrayer: currentPrayer,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildPrayerCountdown(),
                    const SizedBox(height: 24),
                    _buildPrayerTimesList(),
                    const SizedBox(height: 24),
                    _buildIslamicDate(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 60,
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.mosque, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Muslim Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textPrimary),
        ),
        IconButton(
          onPressed: () => context.push('/settings'),
          icon: const Icon(Icons.settings_outlined,
              color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildPrayerCountdown() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lokasi Saat Ini',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer(
                    builder: (context, ref, child) {
                      final locationAsync = ref.watch(locationProvider);
                      return GestureDetector(
                        onTap: () {
                          ref.read(locationProvider.notifier).fetchLocation();
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: AppColors.gold, size: 16),
                            const SizedBox(width: 4),
                            locationAsync.when(
                              data: (loc) => Text(
                                loc,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              loading: () => const SizedBox(
                                height: 14,
                                width: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.gold,
                                ),
                              ),
                              error: (_, __) => const Text(
                                'Jakarta, ID',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (!locationAsync.isLoading)
                              Icon(Icons.refresh_rounded, color: AppColors.textSecondary.withOpacity(0.5), size: 16),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4),
                  ),
                ),
                child: const Text(
                  'Dashboard',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ScaleTransition(
            scale: _pulseAnimation,
            child: Column(
              children: [
                Text(
                  'Shalat Berikutnya',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Isya',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '19:15',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCountdownUnit('01', 'Jam'),
              _buildCountdownSeparator(),
              _buildCountdownUnit('23', 'Menit'),
              _buildCountdownSeparator(),
              _buildCountdownUnit('45', 'Detik'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownUnit(String value, String label) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.darkCard.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBorder),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownSeparator() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12, left: 8, right: 8),
      child: Text(
        ':',
        style: TextStyle(
          color: AppColors.gold,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList() {
    const prayers = [
      _PrayerData('Subuh', '04:45', AppColors.fajr, Icons.nights_stay_rounded),
      _PrayerData('Terbit', '06:02', AppColors.sunrise, Icons.wb_twilight_rounded),
      _PrayerData('Dzuhur', '12:02', AppColors.dhuhr, Icons.wb_sunny_rounded),
      _PrayerData('Ashar', '15:15', AppColors.asr, Icons.cloud_rounded),
      _PrayerData('Maghrib', '18:01', AppColors.maghrib, Icons.wb_twilight_outlined),
      _PrayerData('Isya', '19:15', AppColors.isha, Icons.dark_mode_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Waktu Shalat Hari Ini',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...prayers.map((p) => _buildPrayerItem(p, p.name == 'Isya')),
      ],
    );
  }

  Widget _buildPrayerItem(_PrayerData prayer, bool isNext) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isNext
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.darkCard.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNext
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.darkBorder,
          width: isNext ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: prayer.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(prayer.icon, color: prayer.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              prayer.name,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontWeight: isNext ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          if (isNext)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Berikutnya',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Text(
            prayer.time,
            style: TextStyle(
              color: isNext ? AppColors.gold : AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslamicDate() {
    final now = DateTime.now();
    HijriCalendar.setLocal('ar');
    final hijri = HijriCalendar.now();
    final gregorianDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);
    final formattedHijriDate = hijri.toFormat("dd MMMM yyyy");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_rounded, color: AppColors.gold, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gregorianDate,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedHijriDate,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getPrayerName(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr: return 'Subuh';
      case Prayer.sunrise: return 'Terbit';
      case Prayer.dhuhr: return 'Dzuhur';
      case Prayer.asr: return 'Ashar';
      case Prayer.maghrib: return 'Maghrib';
      case Prayer.isha: return 'Isya';
      default: return '';
    }
  }
}

class _PrayerData {
  const _PrayerData(this.name, this.time, this.color, this.icon);
  final String name;
  final String time;
  final Color color;
  final IconData icon;
}
