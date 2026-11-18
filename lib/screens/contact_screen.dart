import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/notification_service.dart';
import '../../features/home/presentation/widgets/device_camera_sheet.dart';
import '../../features/home/presentation/widgets/dinoyo_map_card.dart';
import '../../theme/app_theme.dart';
import '../../utils/launcher.dart';
import '../../widgets/common.dart';
import 'main_shell.dart';

class ContactScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  final NotificationService notificationService;
  const ContactScreen({
    super.key,
    required this.onNavigate,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const AppTopBar(
            title: 'Kontak & Lokasi',
            subtitle: 'Peta, navigasi Google Maps, dan kontak umum kampung wisata',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PillChip('Kontak Resmi & Titik Kunjungan'),
                  const SizedBox(height: 12),
                  Text('Kunjungi & Hubungi Kampung Keramik Dinoyo',
                      style: AppText.h2.copyWith(fontSize: 24)),
                  const SizedBox(height: 10),
                  Text(
                    'Pusat informasi umum sekretariat Paguyuban Pengrajin Keramik Dinoyo. Untuk transaksi atau workshop toko individual, silakan kunjungi profil toko.',
                    style: AppText.body13,
                  ),
                  const SizedBox(height: 16),
                  _callout(),
                  const SizedBox(height: 24),

                  // Integrated Interactive Google Map Card with GPS Distance Calculation
                  Text('Peta & Navigasi Lokasi', style: AppText.h3),
                  const SizedBox(height: 12),
                  const DinoyoMapCard(),
                  const SizedBox(height: 24),

                  // Device Feature: Camera documentation
                  _deviceCameraCallout(context),
                  const SizedBox(height: 24),

                  Text('Informasi Kontak', style: AppText.h3),
                  const SizedBox(height: 12),
                  ...gapped([
                    _contactCard(
                      icon: Icons.place_outlined,
                      label: 'Alamat Kampung',
                      value: AppConstants.dinoyoAddress,
                      trailingIcon: Icons.map_outlined,
                      tooltip: 'Buka di Maps',
                      onTrailing: () =>
                          openMaps(context, AppConstants.dinoyoAddress),
                    ),
                    _contactCard(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'WhatsApp Paguyuban Dinoyo',
                      value:
                          '+62 812-3456-7890 (Layanan umum informasi kunjungan & study tour)',
                      trailingIcon: Icons.chevron_right,
                      tooltip: 'Chat WhatsApp',
                      onTrailing: () => openWhatsApp(context),
                    ),
                    _contactCard(
                      icon: Icons.mail_outline,
                      label: 'Email Resmi',
                      value: AppConstants.contactEmail,
                      trailingIcon: Icons.copy_outlined,
                      tooltip: 'Salin email',
                      onTrailing: () async {
                        await Clipboard.setData(
                            const ClipboardData(text: AppConstants.contactEmail));
                        if (context.mounted) {
                          showToast(context, 'Alamat email berhasil disalin.');
                        }
                      },
                    ),
                    _contactCard(
                      icon: Icons.schedule,
                      label: 'Jam Layanan Kunjungan',
                      value: 'Setiap Hari, 08.00 - 17.00 WIB',
                    ),
                  ], 12),
                  const SizedBox(height: 24),

                  Text('Kanal Media Sosial', style: AppText.h3),
                  const SizedBox(height: 12),
                  Row(
                    children: gapped([
                      _social(context, Icons.camera_alt_outlined, 'Instagram'),
                      _social(context, Icons.facebook_outlined, 'Facebook'),
                      _social(context, Icons.music_note_outlined, 'TikTok'),
                    ], 10, horizontal: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceCameraCallout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.tan,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.photo_camera_outlined,
                size: 24, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Foto Karya Workshop Anda', style: AppText.cardTitle),
                const SizedBox(height: 2),
                Text(
                  'Gunakan kamera perangkat untuk memotret kerajinan buatan Anda saat berkunjung.',
                  style: AppText.body12,
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: 'Buka Kamera / Galeri',
                  icon: Icons.camera_alt,
                  expand: false,
                  minHeight: 40,
                  fontSize: 12,
                  onPressed: () =>
                      showDeviceCameraSheet(context, notificationService),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _callout() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.tan,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.lightbulb_outline,
                      size: 18, color: AppColors.background),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ingin memesan keramik khusus atau workshop langsung? Buka Direktori Pengrajin untuk melihat nomor WhatsApp masing-masing toko.',
                    style: AppText.inter(size: 13, color: AppColors.ink),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => onNavigate(AppTab.direktori),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Buka Direktori Pengrajin',
                        style: AppText.inter(
                            size: 13,
                            weight: FontWeight.w700,
                            color: AppColors.primary)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward,
                        size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _contactCard({
    required IconData icon,
    required String label,
    required String value,
    IconData? trailingIcon,
    String? tooltip,
    VoidCallback? onTrailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.tan,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppText.inter(size: 13, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(value, style: AppText.body12),
              ],
            ),
          ),
          if (trailingIcon != null)
            IconButton(
              onPressed: onTrailing,
              tooltip: tooltip,
              icon: Icon(trailingIcon, size: 20, color: AppColors.primary),
            ),
        ],
      ),
    );
  }

  Widget _social(BuildContext context, IconData icon, String label) {
    final radius = BorderRadius.circular(12);
    return Expanded(
      child: Material(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: () => showToast(context, 'Membuka akun official $label...'),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: AppColors.ink),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.inter(size: 12, weight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
