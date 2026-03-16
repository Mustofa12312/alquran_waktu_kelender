import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/surah_provider.dart';
import '../../../../core/providers/favorites_provider.dart';

class SurahDetailScreen extends ConsumerStatefulWidget {
  final int surahId;

  const SurahDetailScreen({super.key, required this.surahId});

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Update terakhir baca saat masuk
    Future.microtask(() => _updateLastRead());
  }

  void _updateLastRead() {
    final surahDetailAsync = ref.read(surahDetailProvider(widget.surahId));
    surahDetailAsync.whenData((surah) {
      ref.read(lastReadProvider.notifier).updateLastRead(surah.nomor, surah.namaLatin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final surahDetailAsync = ref.watch(surahDetailProvider(widget.surahId));
    final quranSettings = ref.watch(quranSettingsProvider);
    final favorites = ref.watch(favoritesProvider);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: surahDetailAsync.maybeWhen(
          data: (surah) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                surah.namaLatin,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${surah.arti} • ${surah.jumlahAyat} Ayat',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          orElse: () => const Text('Memuat...'),
        ),
        backgroundColor: AppColors.darkBg,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: surahDetailAsync.when(
        data: (surah) {
          return CustomScrollView(
            slivers: [
              // Header Surah (Bismillah)
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        surah.nama,
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 32,
                          fontFamily: 'Amiri',
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Tampilkan Basmalah kalau bukan surat At-Taubah (Surah 9) dan Al-Fatihah
                      if (surah.nomor != 1 && surah.nomor != 9)
                        const Text(
                          'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Amiri',
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),
              // Daftar Ayat
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ayat = surah.ayat[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.darkBorder),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Baris action & nomor ayat
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${ayat.nomor}',
                                  style: const TextStyle(
                                    color: AppColors.primaryLight,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.share_outlined,
                                        color: AppColors.textMuted, size: 20),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.play_arrow_outlined,
                                        color: AppColors.textMuted, size: 20),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      favoritesNotifier.isBookmarked(
                                              surah.nomor.toString(), ayat.nomor)
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: favoritesNotifier.isBookmarked(
                                              surah.nomor.toString(), ayat.nomor)
                                          ? AppColors.gold
                                          : AppColors.textMuted,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      favoritesNotifier.toggleBookmark(
                                        surahId: surah.nomor.toString(),
                                        surahName: surah.namaLatin,
                                        verseNumber: ayat.nomor,
                                        arabicText: ayat.ar,
                                        translation: ayat.idn,
                                      );
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            favoritesNotifier.isBookmarked(surah.nomor.toString(), ayat.nomor) 
                                            ? 'Ayat ditambahkan ke bookmark' 
                                            : 'Ayat dihapus dari bookmark'
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Arab
                          if (quranSettings.showArabic)
                            Text(
                              ayat.ar,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 28,
                                fontFamily: 'Amiri',
                                height: 2.0,
                              ),
                            ),
                          if (quranSettings.showArabic && (quranSettings.showLatin || quranSettings.showTranslation))
                             const SizedBox(height: 16),
                          // Latin (transliterasi)
                          if (quranSettings.showLatin)
                            Text(
                              ayat.tr,
                              style: const TextStyle(
                                color: AppColors.primaryLight,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          if (quranSettings.showLatin && quranSettings.showTranslation)
                            const SizedBox(height: 8),
                          // Terjemahan
                          if (quranSettings.showTranslation)
                            Text(
                              ayat.idn,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  childCount: surah.ayat.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Gagal memuat ayat: $err',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
