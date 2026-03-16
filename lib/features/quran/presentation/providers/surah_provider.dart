import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/quran_repository.dart';
import '../../domain/models/surah.dart';
import '../../domain/models/surah_detail.dart';

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository();
});

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getSurahList();
});

final searchSurahQueryProvider = StateProvider<String>((ref) => '');

final filteredSurahListProvider = Provider<AsyncValue<List<Surah>>>((ref) {
  final surahListAsyncValue = ref.watch(surahListProvider);
  final searchQuery = ref.watch(searchSurahQueryProvider).trim().toLowerCase();

  return surahListAsyncValue.whenData((surahs) {
    if (searchQuery.isEmpty) {
      return surahs;
    }
    return surahs.where((surah) {
      return surah.namaLatin.toLowerCase().contains(searchQuery) ||
          surah.arti.toLowerCase().contains(searchQuery);
    }).toList();
  });
});

final surahDetailProvider =
    FutureProvider.family<SurahDetail, int>((ref, surahId) async {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getSurahDetail(surahId);
});
