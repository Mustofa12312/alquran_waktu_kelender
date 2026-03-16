import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adhanEnabled = ref.watch(adhanSettingsProvider);
    final quranSettings = ref.watch(quranSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Pengaturan',
            style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.darkBg,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 30),
          _buildSectionTitle('Preferensi Waktu Shalat'),
          _buildSettingsTile(
            title: 'Metode Perhitungan',
            subtitle: 'Kemenag RI (Kementerian Agama)',
            icon: Icons.calculate_outlined,
          ),
          _buildSettingsTile(
            title: 'Koreksi Waktu Hijriah',
            subtitle: '+0 Hari',
            icon: Icons.calendar_month_outlined,
          ),
          _buildSectionTitle('Notifikasi Azan'),
          _buildSwitchTile(
            title: 'Aktifkan Suara Azan',
            icon: Icons.notifications_active_outlined,
            value: adhanEnabled,
            onChanged: (val) {
              ref.read(adhanSettingsProvider.notifier).toggleAdhan(val);
            },
          ),
          if (adhanEnabled) _buildSoundPickerTile(context, ref),
          _buildSectionTitle('Al-Qur\'an'),
          _buildSwitchTile(
            title: 'Tampilkan Arab',
            icon: Icons.font_download_outlined,
            value: quranSettings.showArabic,
            onChanged: (val) {
              ref.read(quranSettingsProvider.notifier).toggleArabic(val);
            },
          ),
          _buildSwitchTile(
            title: 'Tampilkan Latin',
            icon: Icons.abc,
            value: quranSettings.showLatin,
            onChanged: (val) {
              ref.read(quranSettingsProvider.notifier).toggleLatin(val);
            },
          ),
          _buildSwitchTile(
            title: 'Tampilkan Terjemahan',
            icon: Icons.translate,
            value: quranSettings.showTranslation,
            onChanged: (val) {
              ref.read(quranSettingsProvider.notifier).toggleTranslation(val);
            },
          ),
          _buildSectionTitle('Aplikasi'),
          _buildSwitchTile(
            title: 'Mode Gelap (Dark Mode)',
            icon: Icons.dark_mode_outlined,
            value: true,
            onChanged: (val) {},
          ),
          _buildSettingsTile(
            title: 'Tentang Aplikasi',
            subtitle: 'Versi 1.0.0',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 40),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ahmad Santri',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'santri@muslimtime.com',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.gold,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSoundPickerTile(BuildContext context, WidgetRef ref) {
    final adhanSound = ref.watch(adhanSoundProvider);

    String getLabel(String name) {
      if (name == 'azan_1') return 'Azan Pilihan 1';
      if (name == 'azan_2') return 'Azan Pilihan 2';
      if (name == 'azan_3') return 'Azan Pilihan 3';
      if (name == 'azan_4') return 'Azan Pilihan 4';
      if (name == 'azan_5') return 'Azan Pilihan 5';
      if (name == 'azan_6') return 'Azan Pilihan 6';
      return 'Azan Default';
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: const Icon(Icons.audiotrack_outlined,
            color: AppColors.textPrimary, size: 20),
      ),
      title: const Text(
        'Pilih Suara Azan',
        style: TextStyle(color: AppColors.textPrimary, fontSize: 15),
      ),
      subtitle: Text(
        getLabel(adhanSound),
        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: () {
        _showAdhanPickerBottomSheet(context, ref, adhanSound);
      },
    );
  }

  void _showAdhanPickerBottomSheet(
      BuildContext context, WidgetRef ref, String currentSound) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _AdhanPickerSheet(currentSound: currentSound);
      },
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: () {},
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required IconData icon,
    required bool value,
    void Function(bool)? onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      ),
      value: value,
      activeColor: AppColors.primaryLight,
      inactiveTrackColor: AppColors.darkCard,
      onChanged: onChanged,
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkBg,
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
        ),
        onPressed: () {},
        child: const Text('Keluar (Logout)'),
      ),
    );
  }
}

class _AdhanPickerSheet extends ConsumerStatefulWidget {
  final String currentSound;
  const _AdhanPickerSheet({required this.currentSound});

  @override
  ConsumerState<_AdhanPickerSheet> createState() => _AdhanPickerSheetState();
}

class _AdhanPickerSheetState extends ConsumerState<_AdhanPickerSheet> {
  String? playingSound;

  @override
  void dispose() {
    Future.microtask(() {
      if (mounted) ref.read(adhanSoundProvider.notifier).stopPreview();
    });
    super.dispose();
  }

  void _togglePlay(String soundName) async {
    final notifier = ref.read(adhanSoundProvider.notifier);
    if (playingSound == soundName) {
      await notifier.stopPreview();
      if (mounted) setState(() => playingSound = null);
    } else {
      if (mounted) setState(() => playingSound = soundName);
      await notifier.playPreview(soundName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> adhanOptions = [
      {'id': 'azan_1', 'name': 'Azan Pilihan 1'},
      {'id': 'azan_2', 'name': 'Azan Pilihan 2'},
      {'id': 'azan_3', 'name': 'Azan Pilihan 3'},
      {'id': 'azan_4', 'name': 'Azan Pilihan 4'},
      {'id': 'azan_5', 'name': 'Azan Pilihan 5'},
      {'id': 'azan_6', 'name': 'Azan Pilihan 6'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Pilih Suara Azan',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: adhanOptions.length,
              itemBuilder: (context, index) {
                final option = adhanOptions[index];
                final isSelected = widget.currentSound == option['id'];
                final isPlaying = playingSound == option['id'];

                return ListTile(
                  title: Text(
                    option['name']!,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.stop_circle_outlined
                              : Icons.play_circle_outline,
                          color: isPlaying
                              ? AppColors.error
                              : AppColors.primaryLight,
                        ),
                        onPressed: () => _togglePlay(option['id']!),
                      ),
                      if (isSelected)
                        const Icon(Icons.check, color: AppColors.primaryLight),
                    ],
                  ),
                  onTap: () {
                    // Update Provider and dismiss sheet
                    ref.read(adhanSoundProvider.notifier).stopPreview();
                    ref
                        .read(adhanSoundProvider.notifier)
                        .setSound(option['id']!);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
