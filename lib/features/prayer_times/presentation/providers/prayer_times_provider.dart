import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';

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
    );
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
  return PrayerTimes(coordsAsync, date, params);
});

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
