import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/app_constants.dart';

class LocationResult {
  final double? distanceMeters;
  final String statusMessage;
  final bool isSuccess;

  LocationResult({
    this.distanceMeters,
    required this.statusMessage,
    required this.isSuccess,
  });

  String get formattedDistance {
    if (distanceMeters == null) return '-';
    if (distanceMeters! >= 1000) {
      final km = (distanceMeters! / 1000).toStringAsFixed(1);
      return '$km km';
    }
    return '${distanceMeters!.round()} m';
  }
}

class LocationService {
  Future<LocationResult> calculateDistanceToDinoyo() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult(
          statusMessage: 'Layanan lokasi (GPS) perangkat belum aktif.',
          isSuccess: false,
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult(
            statusMessage: 'Izin akses lokasi ditolak oleh pengguna.',
            isSuccess: false,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult(
          statusMessage: 'Izin akses lokasi ditolak permanen pada pengaturan perangkat.',
          isSuccess: false,
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        AppConstants.dinoyoLatitude,
        AppConstants.dinoyoLongitude,
      );

      return LocationResult(
        distanceMeters: distance,
        statusMessage: 'Lokasi Anda berhasil terdeteksi.',
        isSuccess: true,
      );
    } catch (e) {
      debugPrint('LocationService error: $e');
      return LocationResult(
        statusMessage: 'Gagal mendeteksi lokasi: $e',
        isSuccess: false,
      );
    }
  }
}
