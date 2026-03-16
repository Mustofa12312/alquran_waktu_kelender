import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/surah_provider.dart';
import '../../domain/models/surah.dart';

class SurahListScreen extends ConsumerStatefulWidget {
  const SurahListScreen({super.key});

  @override
  ConsumerState<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends ConsumerState<SurahListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Al-Qur\'an',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildLastRead(),
          Expanded(child: _buildSurahList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (v) {
          ref.read(searchSurahQueryProvider.notifier).state = v;
        },
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Cari surah...',
          hintStyle: const TextStyle(color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
          filled: true,
          fillColor: AppColors.darkCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildLastRead() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C6FB0), Color(0xFF4A3B8C)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.bookmark, color: AppColors.gold, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Terakhir Dibaca',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Al-Baqarah : 255',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Ayat Kursi',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.darkBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: const Text('Lanjut', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahList() {
    final surahsAsyncValue = ref.watch(filteredSurahListProvider);

    return surahsAsyncValue.when(
      data: (surahs) {
        if (surahs.isEmpty) {
          return const Center(
            child: Text(
              'Surah tidak ditemukan',
              style: TextStyle(color: AppColors.textMuted),
            ),
          );
        }
        return ListView.builder(
          itemCount: surahs.length,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemBuilder: (context, i) => _buildSurahItem(surahs[i]),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (err, stack) => Center(
        child: Text(
          'Gagal memuat surah: $err',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSurahItem(Surah surah) {
    // Capitalize first letter of tempatTurun to make it look nicer
    final type = surah.tempatTurun.isNotEmpty
        ? '${surah.tempatTurun[0].toUpperCase()}${surah.tempatTurun.substring(1)}'
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () {
          // Navigasi ke detail surah
          context.go('/quran/${surah.nomor}');
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
          ),
          alignment: Alignment.center,
          child: Text(
            '${surah.nomor}',
            style: const TextStyle(
              color: AppColors.primaryLight,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          surah.namaLatin,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${surah.arti} • ${surah.jumlahAyat} Ayat • $type',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        trailing: Text(
          surah.nama,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 20,
            fontFamily: 'Amiri',
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
