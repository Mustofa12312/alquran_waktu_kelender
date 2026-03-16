import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider((ref) => StorageService());

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<dynamic>>((ref) {
  return FavoritesNotifier(ref.watch(storageServiceProvider));
});

class FavoritesNotifier extends StateNotifier<List<dynamic>> {
  final StorageService _storage;

  FavoritesNotifier(this._storage) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    state = _storage.getAllBookmarks();
  }

  bool isBookmarked(String surahId, int verseNumber) {
    return _storage.isBookmarked(surahId, verseNumber);
  }

  Future<void> toggleBookmark({
    required String surahId,
    required int verseNumber,
    required String surahName,
    required String arabicText,
    required String translation,
  }) async {
    final data = {
      'surahId': surahId,
      'surahName': surahName,
      'verseNumber': verseNumber,
      'arabicText': arabicText,
      'translation': translation,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await _storage.toggleBookmark(surahId, verseNumber, data);
    _loadFavorites();
  }
}
