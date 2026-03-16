import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/prayer_times/presentation/screens/prayer_times_screen.dart';
import '../../features/islamic_calendar/presentation/screens/calendar_screen.dart';
import '../../features/quran/presentation/screens/surah_list_screen.dart';
import '../../features/quran/presentation/screens/surah_detail_screen.dart';
import '../../features/news/presentation/screens/news_list_screen.dart';
import '../../features/qibla/presentation/screens/qibla_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/quran/presentation/screens/bookmarks_screen.dart';
import '../../shared/widgets/main_scaffold.dart';

enum AppRoute {
  home,
  calendar,
  quran,
  news,
  qibla,
  settings,
  surahDetail,
  newsDetail,
  bookmarks,
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: AppRoute.home.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PrayerTimesScreen(),
          ),
        ),
        GoRoute(
          path: '/calendar',
          name: AppRoute.calendar.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CalendarScreen(),
          ),
        ),
        GoRoute(
          path: '/quran',
          name: AppRoute.quran.name,
          builder: (context, state) => const SurahListScreen(),
          routes: [
            GoRoute(
              path: ':number',
              builder: (context, state) {
                final number = int.tryParse(state.pathParameters['number'] ?? '') ?? 1;
                return SurahDetailScreen(surahId: number);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/news',
          name: AppRoute.news.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: NewsListScreen(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              name: AppRoute.newsDetail.name,
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return NewsDetailPlaceholder(newsId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/qibla',
          name: AppRoute.qibla.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: QiblaScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          name: AppRoute.settings.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
        GoRoute(
          path: '/bookmarks',
          name: AppRoute.bookmarks.name,
          builder: (context, state) => const BookmarksScreen(),
        ),
      ],
    ),
  ],
);

// Placeholder for surah detail (will be implemented later)
class SurahDetailPlaceholder extends StatelessWidget {
  const SurahDetailPlaceholder({super.key, required this.surahNumber});
  final int surahNumber;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Surah $surahNumber')),
        body: const Center(child: CircularProgressIndicator()),
      );
}

// Placeholder for news detail (will be implemented later)
class NewsDetailPlaceholder extends StatelessWidget {
  const NewsDetailPlaceholder({super.key, required this.newsId});
  final String newsId;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Berita')),
        body: const Center(child: CircularProgressIndicator()),
      );
}
