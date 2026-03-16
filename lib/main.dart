import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeDateFormatting('id_ID', null);
  
  await NotificationService().init();
  
  // Here we would initialize Hive, Supabase, etc.
  
  runApp(
    const ProviderScope(
      child: MuslimTimeApp(),
    ),
  );
}

class MuslimTimeApp extends ConsumerWidget {
  const MuslimTimeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Muslim Time',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark, // Default to dark mode based on the design
      routerConfig: goRouter,
    );
  }
}
