import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String bookmarksBox = 'quran_bookmarks';
  static const String newsFavoritesBox = 'news_favorites';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(bookmarksBox);
    await Hive.openBox(newsFavoritesBox);
  }

  // Quran Bookmarks Logic
  bool isBookmarked(String surahId, int verseNumber) {
    final box = Hive.box(bookmarksBox);
    final key = '${surahId}_$verseNumber';
    return box.containsKey(key);
  }

  Future<void> toggleBookmark(String surahId, int verseNumber, Map<String, dynamic> data) async {
    final box = Hive.box(bookmarksBox);
    final key = '${surahId}_$verseNumber';

    if (box.containsKey(key)) {
      await box.delete(key);
    } else {
      await box.put(key, data);
    }
  }

  List<dynamic> getAllBookmarks() {
    final box = Hive.box(bookmarksBox);
    return box.values.toList();
  }
}
