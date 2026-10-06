import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'main_shell.dart';

/// Screen 06 - Tentang Kami.
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key, required this.onNavigate});
  final ValueChanged<int> onNavigate;

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _paguyubanKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const AppTopBar(
            title: 'Tentang Kami',
            subtitle: 'Paguyuban Pengrajin Keramik Dinoyo',
            trailing: ShareButton(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hero(),
                  _stats(),
                  _sejarah(),
                  _paguyuban(),
                  _misi(),
                  const WorkshopCta(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImagePlaceholder(
              label: '[ Foto Paguyuban Pengrajin Keramik Dinoyo ]',
              height: 200,
              radius: 20,
            ),
            const SizedBox(height: 16),
            const PillChip('Paguyuban pengrajin keramik Dinoyo'),
            const SizedBox(height: 12),
            Text('Tentang Kampung Wisata Keramik Dinoyo',
                style: AppText.h2.copyWith(fontSize: 26)),
            const SizedBox(height: 10),
            Text(
              'Platform ini dikelola oleh Paguyuban Pengrajin Keramik Dinoyo - sebuah organisasi lokal yang mewadahi para pengrajin keramik di kawasan Dinoyo. Paguyuban ini berfungsi sebagai jembatan antara pengrajin dan pengunjung, memastikan setiap toko mendapat visibilitas yang adil dan informasi yang ditampilkan selalu akurat.',
              style: AppText.body13,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Jelajahi Sejarah',
                    trailingIcon: Icons.arrow_forward,
                    onPressed: () => widget.onNavigate(AppTab.sejarah),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Lihat Paguyuban',
                    variant: AppButtonVariant.outline,
                    onPressed: () {
                      final ctx = _paguyubanKey.currentContext;
                      if (ctx != null) {
                        Scrollable.ensureVisible(ctx,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOut);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _stats() {
    Widget stat(String value, String label) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.tan,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(value,
                    style: AppText.inter(
                        size: 20, weight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 2),
                Text(label, style: AppText.body12),
              ],
            ),
          ),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: gapped([
          stat('1930-an', 'Awal sejarah'),
          stat('30+', 'Pengrajin'),
          stat('12', 'Workshop'),
        ], 10, horizontal: true),
      ),
    );
  }

  Widget _sejarah() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImagePlaceholder(
                label: '[ Foto Sejarah Kampung Keramik Dinoyo ]', height: 180),
            const SizedBox(height: 16),
            Text('Sejarah Kampung Keramik Dinoyo', style: AppText.h3),
            const SizedBox(height: 10),
            Text(
              'Kampung Wisata Keramik Dinoyo terletak di Jl. MT Haryono IX, Kelurahan Dinoyo, Kota Malang. Sejak era 1950-an, kawasan ini menjadi sentra produksi keramik yang dikenal luas di Jawa Timur. Puluhan pengrajin yang tinggal dan berkarya di kampung ini mewarisi teknik pembuatan keramik dari generasi ke generasi.',
              style: AppText.body13,
            ),
            const SizedBox(height: 10),
            Text(
              'Platform digital ini hadir untuk memperkenalkan kekayaan budaya keramik Dinoyo kepada wisatawan, pelajar, dan masyarakat luas - sekaligus memudahkan mereka menemukan dan menghubungi langsung para pengrajin yang ada di kampung ini.',
              style: AppText.body13,
            ),
            const SizedBox(height: 14),
            AppButton(
              label: 'Selengkapnya',
              variant: AppButtonVariant.outline,
              trailingIcon: Icons.arrow_forward,
              expand: false,
              onPressed: () => widget.onNavigate(AppTab.sejarah),
            ),
          ],
        ),
      );

  Widget _paguyuban() => Container(
        key: _paguyubanKey,
        width: double.infinity,
        color: AppColors.sand,
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.groups_outlined,
                      size: 20, color: AppColors.background),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Paguyuban Pengrajin Keramik Dinoyo',
                      style: AppText.h3),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Paguyuban ini berfungsi sebagai jembatan antara pengrajin dan pengunjung, memastikan setiap toko mendapat visibilitas yang adil dan informasi yang ditampilkan selalu akurat.',
              style: AppText.body13,
            ),
            const SizedBox(height: 10),
            Text(
              'Paguyuban juga mengoordinasikan kegiatan workshop edukasi, pameran bersama, dan program pelestarian budaya keramik tradisional.',
              style: AppText.body13,
            ),
            const SizedBox(height: 14),
            const ImagePlaceholder(
                label: '[ Foto Kegiatan Paguyuban Pengrajin ]', height: 170),
          ],
        ),
      );

  Widget _misi() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Misi Platform', style: AppText.h2),
            const SizedBox(height: 10),
            Text(
              'Kami menghubungkan pengunjung dengan cerita, pengrajin, dan karya asli Dinoyo melalui pengalaman digital yang jelas, rapi, dan mudah diakses.',
              style: AppText.body13,
            ),
            const SizedBox(height: 14),
            ...gapped(const [
              FeatureCard(
                icon: Icons.menu_book_outlined,
                iconBackground: AppColors.primary,
                title: 'Pelestarian Budaya',
                description:
                    'Mendokumentasikan dan mempromosikan warisan keramik tradisional Dinoyo agar tetap dikenal generasi mendatang.',
              ),
              FeatureCard(
                icon: Icons.chat_bubble_outline_rounded,
                iconBackground: AppColors.sage,
                title: 'Koneksi Langsung',
                description:
                    'Memudahkan pengunjung menemukan dan menghubungi pengrajin secara langsung tanpa perantara.',
              ),
              FeatureCard(
                icon: Icons.grid_view_rounded,
                iconBackground: AppColors.brick,
                title: 'Edukasi & Workshop',
                description:
                    'Menyediakan informasi workshop edukasi bagi pelajar, wisatawan, dan masyarakat yang ingin belajar membuat keramik.',
              ),
            ], 12),
          ],
        ),
      );
}
