import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/notification_service.dart';
import 'package:just_audio/just_audio.dart';

class AdhanSettingsNotifier extends StateNotifier<bool> {
  AdhanSettingsNotifier() : super(false) {
    _loadSettings();
  }

  static const _key = 'adhan_enabled';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> toggleAdhan(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isEnabled);
    state = isEnabled;

    if (isEnabled) {
      final notificationService = NotificationService();
      final hasPermission = await notificationService.requestPermissions();
      if (!hasPermission) {
        state = false;
        await prefs.setBool(_key, false);
      }
    } else {
      await NotificationService().cancelAllNotifications();
    }
  }
}

final adhanSettingsProvider =
    StateNotifierProvider<AdhanSettingsNotifier, bool>((ref) {
  return AdhanSettingsNotifier();
});

class AdhanSoundNotifier extends StateNotifier<String> {
  AdhanSoundNotifier() : super('azan_1') {
    _loadSettings();
  }

  static const _key = 'adhan_sound';
  final AudioPlayer _player = AudioPlayer();

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key) ?? 'azan_1';
  }

  Future<void> setSound(String sound) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, sound);
    state = sound;
  }

  Future<void> playPreview(String sound) async {
    await _player.stop();
    await _player.setAsset('assets/audio/azan/$sound.mp3');
    await _player.play();
  }

  Future<void> stopPreview() async {
    await _player.stop();
  }
  
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final adhanSoundProvider =
    StateNotifierProvider<AdhanSoundNotifier, String>((ref) {
  return AdhanSoundNotifier();
});

// Settings untuk Quran
class QuranSettings {
  final bool showArabic;
  final bool showLatin;
  final bool showTranslation;

  QuranSettings({
    this.showArabic = true,
    this.showLatin = true,
    this.showTranslation = true,
  });

  QuranSettings copyWith({
    bool? showArabic,
    bool? showLatin,
    bool? showTranslation,
  }) {
    return QuranSettings(
      showArabic: showArabic ?? this.showArabic,
      showLatin: showLatin ?? this.showLatin,
      showTranslation: showTranslation ?? this.showTranslation,
    );
  }
}

class QuranSettingsNotifier extends StateNotifier<QuranSettings> {
  QuranSettingsNotifier() : super(QuranSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = QuranSettings(
      showArabic: prefs.getBool('quran_show_arabic') ?? true,
      showLatin: prefs.getBool('quran_show_latin') ?? true,
      showTranslation: prefs.getBool('quran_show_translation') ?? true,
    );
  }

  Future<void> toggleArabic(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quran_show_arabic', value);
    state = state.copyWith(showArabic: value);
  }

  Future<void> toggleLatin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quran_show_latin', value);
    state = state.copyWith(showLatin: value);
  }

  Future<void> toggleTranslation(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quran_show_translation', value);
    state = state.copyWith(showTranslation: value);
  }
}

final quranSettingsProvider =
    StateNotifierProvider<QuranSettingsNotifier, QuranSettings>((ref) {
  return QuranSettingsNotifier();
});

// Tracking Terakhir Baca
class LastRead {
  final int surahId;
  final String surahName;
  final String updatedAt;

  LastRead({
    required this.surahId,
    required this.surahName,
    required this.updatedAt,
  });
}

class LastReadNotifier extends StateNotifier<LastRead?> {
  LastReadNotifier() : super(null) {
    _loadLastRead();
  }

  Future<void> _loadLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final surahId = prefs.getInt('last_read_surah_id');
    final surahName = prefs.getString('last_read_surah_name');
    final updatedAt = prefs.getString('last_read_at');

    if (surahId != null && surahName != null && updatedAt != null) {
      state = LastRead(
        surahId: surahId,
        surahName: surahName,
        updatedAt: updatedAt,
      );
    }
  }

  Future<void> updateLastRead(int surahId, String surahName) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    
    await prefs.setInt('last_read_surah_id', surahId);
    await prefs.setString('last_read_surah_name', surahName);
    await prefs.setString('last_read_at', now);

    state = LastRead(
      surahId: surahId,
      surahName: surahName,
      updatedAt: now,
    );
  }
}

final lastReadProvider =
    StateNotifierProvider<LastReadNotifier, LastRead?>((ref) {
  return LastReadNotifier();
});
