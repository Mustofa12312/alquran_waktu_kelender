import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationNotifier extends AsyncNotifier<String> {
  static const _locationKey = 'saved_location';

  @override
  FutureOr<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_locationKey) ?? 'Jakarta, ID';
  }

  Future<void> fetchLocation() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return 'Lokasi dinonaktifkan';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Izin lokasi ditolak';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return 'Izin lokasi dilarang permanen';
      }

      try {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          String kecamatan = place.locality ?? '';
          String kabupaten = place.subAdministrativeArea ?? '';

          String locName = 'Lokasi Ditemukan';
          if (kabupaten.isNotEmpty && kecamatan.isNotEmpty) {
             locName = '$kecamatan, $kabupaten';
          } else if (kabupaten.isNotEmpty) {
             locName = kabupaten;
          } else if (kecamatan.isNotEmpty) {
             locName = kecamatan;
          } else {
             locName = place.administrativeArea ?? 'Koordinat ditemukan';
          }
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_locationKey, locName);
          return locName;
        }

        return 'Lokasi Ditemukan';
      } catch (e) {
        return 'Gagal deteksi lokasi';
      }
    });
  }
}

final locationProvider = AsyncNotifierProvider<LocationNotifier, String>(() {
  return LocationNotifier();
});
