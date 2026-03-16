import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/providers/favorites_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Bookmark Saya', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.darkBg,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: bookmarks.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return _buildBookmarkItem(context, ref, bookmark);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: AppColors.textMuted.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'Belum ada bookmark',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Klik ikon bookmark pada ayat Al-Qur\'an\nuntuk menyimpannya di sini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkItem(BuildContext context, WidgetRef ref, dynamic bookmark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${bookmark['surahName']} : ${bookmark['verseNumber']}',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleBookmark(
                        surahId: bookmark['surahId'],
                        surahName: bookmark['surahName'],
                        verseNumber: bookmark['verseNumber'],
                        arabicText: bookmark['arabicText'],
                        translation: bookmark['translation'],
                      );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            bookmark['arabicText'],
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontFamily: 'Amiri',
              height: 1.8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            bookmark['translation'],
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
