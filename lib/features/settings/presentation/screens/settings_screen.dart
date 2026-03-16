import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(color: AppColors.textPrimary)),
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
            title: 'Azan Subuh',
            icon: Icons.notifications_active_outlined,
            value: true,
          ),
          _buildSwitchTile(
            title: 'Azan Dzuhur',
            icon: Icons.notifications_active_outlined,
            value: false,
          ),
          _buildSectionTitle('Al-Qur\'an'),
          _buildSettingsTile(
            title: 'Ukuran Font Arab',
            subtitle: 'Sedang',
            icon: Icons.format_size,
          ),
          _buildSwitchTile(
            title: 'Tampilkan Terjemahan',
            icon: Icons.translate,
            value: true,
          ),
          _buildSectionTitle('Aplikasi'),
          _buildSwitchTile(
            title: 'Mode Gelap (Dark Mode)',
            icon: Icons.dark_mode_outlined,
            value: true,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Kelas 3 Ulya',
                  style: TextStyle(
                    color: AppColors.primaryLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
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
      onChanged: (val) {},
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
