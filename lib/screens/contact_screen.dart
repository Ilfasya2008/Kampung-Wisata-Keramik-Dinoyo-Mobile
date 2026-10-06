import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../utils/launcher.dart';
import '../widgets/common.dart';
import 'main_shell.dart';

/// Screen 07 - Kontak.
class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key, required this.onNavigate});
  final ValueChanged<int> onNavigate;

  static const _address =
      'Jl. MT Haryono IX No.336, Kelurahan Dinoyo, Kecamatan Lowokwaru, Kota Malang, Jawa Timur 65145';
  static const _email = 'info@keramikdinoyo.id';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const AppTopBar(title: 'Kontak', subtitle: 'Kontak umum kampung wisata'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PillChip('Kontak Umum Kampung'),
                  const SizedBox(height: 12),
                  Text('Hubungi Kampung Wisata Keramik Dinoyo',
                      style: AppText.h2.copyWith(fontSize: 26)),
                  const SizedBox(height: 10),
                  Text(
                    'Informasi kontak umum kampung wisata - bukan kontak pengrajin individual. Untuk menghubungi pengrajin tertentu, silakan kunjungi halaman profil toko masing-masing.',
                    style: AppText.body13,
                  ),
                  const SizedBox(height: 16),
                  _callout(),
                  const SizedBox(height: 24),
                  Text('Informasi Kontak', style: AppText.h3),
                  const SizedBox(height: 12),
                  ...gapped([
                    _contactCard(
                      icon: Icons.place_outlined,
                      label: 'Alamat',
                      value: _address,
                      trailingIcon: Icons.map_outlined,
                      tooltip: 'Buka di Maps',
                      onTrailing: () => openMaps(context, _address),
                    ),
                    _contactCard(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: 'WhatsApp Umum Kampung',
                      value:
                          '08xx-xxxx-xxxx (Ini adalah kontak umum kampung wisata, bukan pengrajin individual)',
                      trailingIcon: Icons.chevron_right,
                      tooltip: 'Chat WhatsApp',
                      onTrailing: () => openWhatsApp(context),
                    ),
                    _contactCard(
                      icon: Icons.mail_outline,
                      label: 'Email',
                      value: _email,
                      trailingIcon: Icons.copy_outlined,
                      tooltip: 'Salin email',
                      onTrailing: () async {
                        await Clipboard.setData(const ClipboardData(text: _email));
                        if (context.mounted) showToast(context, 'Email disalin.');
                      },
                    ),
                    _contactCard(
                      icon: Icons.schedule,
                      label: 'Jam Layanan Informasi',
                      value: 'Senin - Sabtu, 08.00 - 16.00 WIB',
                    ),
                  ], 12),
                  const SizedBox(height: 24),
                  Text('Lokasi', style: AppText.h3),
                  const SizedBox(height: 12),
                  const ImagePlaceholder(
                    label: '[ Peta Lokasi Kampung Wisata Keramik Dinoyo ]',
                    height: 190,
                    icon: Icons.place_outlined,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Buka di Maps',
                          icon: Icons.map_outlined,
                          onPressed: () => openMaps(context, _address),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          label: 'Chat WhatsApp',
                          variant: AppButtonVariant.whatsapp,
                          icon: Icons.chat_bubble_outline_rounded,
                          onPressed: () => openWhatsApp(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Sosial Media', style: AppText.h3),
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
                    'Ingin menghubungi pengrajin tertentu? Kunjungi Direktori Pengrajin untuk melihat profil toko dan menghubungi mereka langsung via WhatsApp masing-masing.',
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
                padding: const EdgeInsets.symmetric(vertical: 10),
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
          onTap: () => showToast(context, 'Tautan $label belum diisi.'),
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
