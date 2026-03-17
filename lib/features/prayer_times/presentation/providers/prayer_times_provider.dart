import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../../core/services/notification_service.dart';

// Provider buat menyimpan Posisi lat lng
final coordinatesProvider = FutureProvider<Coordinates?>((ref) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Kalau ditolak kita default kembali ke Jakarta (Pusat) supaya tidak error
    return Coordinates(-6.2088, 106.8456);
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Coordinates(-6.2088, 106.8456);
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Coordinates(-6.2088, 106.8456);
  }

  try {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low), // Akurasi rendah supaya cepat untuk jam salat sudah cukup
    ).timeout(const Duration(seconds: 3));
    return Coordinates(position.latitude, position.longitude);
  } catch (e) {
    return Coordinates(-6.2088, 106.8456);
  }
});

// Menghitung jadwal salat
final prayerTimesProvider = FutureProvider<PrayerTimes?>((ref) async {
  final coordsAsync = await ref.watch(coordinatesProvider.future);

  if (coordsAsync == null) return null;

  final params = CalculationMethod.singapore.getParameters(); // Metode Kemenag sangat mirip singapura
  params.madhab = Madhab.shafi;

  final date = DateComponents.from(DateTime.now());
  final prayerTimes = PrayerTimes(coordsAsync, date, params);
  
  // Ambil service dan preferensi azan
  final adhanEnabled = ref.watch(adhanSettingsProvider);
  final adhanSound = ref.watch(adhanSoundProvider);
  if (adhanEnabled) {
    _scheduleAllPrayers(prayerTimes, adhanSound);
  }

  return prayerTimes;
});

void _scheduleAllPrayers(PrayerTimes pt, String soundName) {
  final service = NotificationService();
  service.cancelAllNotifications();
  
  if (pt.fajr.isAfter(DateTime.now())) {
    service.schedulePrayerNotification(
      id: 1, title: 'Waktu Subuh', body: 'Sudah masuk waktu Subuh',
      scheduledTime: pt.fajr, playAzanSound: true, soundName: soundName,
    );
  }
  if (pt.dhuhr.isAfter(DateTime.now())) {
    service.schedulePrayerNotification(
      id: 2, title: 'Waktu Dzuhur', body: 'Sudah masuk waktu Dzuhur',
      scheduledTime: pt.dhuhr, playAzanSound: true, soundName: soundName,
    );
  }
  if (pt.asr.isAfter(DateTime.now())) {
    service.schedulePrayerNotification(
      id: 3, title: 'Waktu Ashar', body: 'Sudah masuk waktu Ashar',
      scheduledTime: pt.asr, playAzanSound: true, soundName: soundName,
    );
  }
  if (pt.maghrib.isAfter(DateTime.now())) {
    service.schedulePrayerNotification(
      id: 4, title: 'Waktu Maghrib', body: 'Sudah masuk waktu Maghrib',
      scheduledTime: pt.maghrib, playAzanSound: true, soundName: soundName,
    );
  }
  if (pt.isha.isAfter(DateTime.now())) {
    service.schedulePrayerNotification(
      id: 5, title: 'Waktu Isya', body: 'Sudah masuk waktu Isya',
      scheduledTime: pt.isha, playAzanSound: true, soundName: soundName,
    );
  }
}


final currentPrayerProvider = Provider<Prayer>((ref) {
  final prayerTimesAsync = ref.watch(prayerTimesProvider);
  return prayerTimesAsync.maybeWhen(
    data: (prayerTimes) {
      if (prayerTimes != null) {
        return prayerTimes.currentPrayer();
      }
      return Prayer.none;
    },
    orElse: () => Prayer.none,
  );
});

final nextPrayerProvider = Provider<Prayer>((ref) {
  final prayerTimesAsync = ref.watch(prayerTimesProvider);
  return prayerTimesAsync.maybeWhen(
    data: (prayerTimes) {
      if (prayerTimes != null) {
        return prayerTimes.nextPrayer();
      }
      return Prayer.none;
    },
    orElse: () => Prayer.none,
  );
});
