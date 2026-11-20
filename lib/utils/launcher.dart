import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Nomor WhatsApp umum kampung wisata. Diisi saat build/run, misalnya:
///   flutter run --dart-define=VILLAGE_WHATSAPP=6281234567890
/// Format 08xx juga diterima (otomatis diubah ke 62xx). Bila kosong, tombol
/// WhatsApp menampilkan pesan "Nomor WhatsApp belum diisi."
const String kVillageWhatsApp = String.fromEnvironment('VILLAGE_WHATSAPP');

String? _normalizePhone(String raw) {
  if (raw.toLowerCase().contains('x')) return null; // still a placeholder
  var digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length < 9) return null;
  if (digits.startsWith('0')) digits = '62${digits.substring(1)}';
  return digits;
}

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<void> openWhatsApp(
  BuildContext context, {
  String? phone,
  String message =
      'Halo, saya ingin bertanya tentang Kampung Wisata Keramik Dinoyo.',
}) async {
  final number = _normalizePhone(phone ?? kVillageWhatsApp);
  if (number == null) {
    showToast(context, 'Nomor WhatsApp belum diisi.');
    return;
  }
  final uri =
      Uri.parse('https://wa.me/$number?text=${Uri.encodeComponent(message)}');
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) showToast(context, 'Tidak bisa membuka WhatsApp.');
}

Future<void> openMaps(BuildContext context, String query) async {
  final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) showToast(context, 'Tidak bisa membuka Maps.');
}
