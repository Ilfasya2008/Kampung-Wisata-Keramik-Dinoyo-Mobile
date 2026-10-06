import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../utils/launcher.dart';
import '../widgets/common.dart';
import '../widgets/shop_cards.dart';
import 'main_shell.dart';

/// Screen 01 - Beranda.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onNavigate});
  final ValueChanged<int> onNavigate;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _heroController = PageController();
  int _heroPage = 0;

  static const _heroSlides = 3;

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _appBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _search(),
                  _hero(),
                  _quickMenu(),
                  _about(),
                  _usp(),
                  _timelinePreview(),
                  _directoryPreview(),
                  const WorkshopCta(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: Color(0xB3D7C1A8))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('KD',
                style: AppText.inter(
                    size: 13,
                    weight: FontWeight.w700,
                    color: AppColors.background)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kampung Wisata Keramik Dinoyo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.inter(size: 14, weight: FontWeight.w700)),
                Text('Portofolio digital & direktori budaya',
                    style: AppText.inter(size: 10, color: AppColors.muted)),
              ],
            ),
          ),
          SquareIconButton(
            icon: Icons.notifications_none,
            tooltip: 'Notifikasi',
            onPressed: () => showToast(context, 'Belum ada notifikasi.'),
          ),
          const SizedBox(width: 8),
          SquareIconButton(
            icon: Icons.admin_panel_settings_outlined,
            tooltip: 'Panel Admin',
            onPressed: () => Navigator.of(context).pushNamed('/admin'),
          ),
        ],
      ),
    );
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Material(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => widget.onNavigate(AppTab.direktori),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.search, size: 18, color: AppColors.muted),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Cari pengrajin, toko, atau sejarah...',
                      style: AppText.body13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _heroController,
                    itemCount: _heroSlides,
                    onPageChanged: (i) => setState(() => _heroPage = i),
                    itemBuilder: (_, _) => const ImagePlaceholder(
                      label:
                          '[ Foto Hero / Banner - Kampung Wisata Keramik Dinoyo ]',
                      radius: 0,
                      iconSize: 26,
                      height: 220,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < _heroSlides; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _heroPage ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: i == _heroPage
                                  ? AppColors.primary
                                  : const Color(0xCCFFFFFF),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          const PillChip('Sentra budaya & kerajinan Dinoyo',
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
          const SizedBox(height: 14),
          Text('Kampung Wisata\nKeramik Dinoyo', style: AppText.h1),
          const SizedBox(height: 14),
          Text(
            'Portofolio digital & direktori budaya pengrajin keramik Dinoyo sejak 1930-an - untuk wisatawan, pelajar, dan pecinta warisan budaya.',
            style: AppText.body14,
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
                  label: 'Lihat Direktori',
                  variant: AppButtonVariant.outline,
                  onPressed: () => widget.onNavigate(AppTab.direktori),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickMenu() {
    Widget item(IconData icon, String label, int tab) => Expanded(
          child: Material(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => widget.onNavigate(tab),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                child: Column(
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
                    const SizedBox(height: 8),
                    Text(label,
                        style: AppText.inter(size: 12, weight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: gapped([
          item(Icons.schedule, 'Sejarah', AppTab.sejarah),
          item(Icons.storefront_outlined, 'Direktori', AppTab.direktori),
          item(Icons.calendar_today_outlined, 'Workshop', AppTab.direktori),
          item(Icons.place_outlined, 'Lokasi', AppTab.kontak),
        ], 10, horizontal: true),
      ),
    );
  }

  Widget _about() {
    return Container(
      width: double.infinity,
      color: AppColors.sand,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Tentang Kampung Keramik Dinoyo'),
          const SizedBox(height: 14),
          const ImagePlaceholder(
              label: '[ IMAGE: Pengrajin & Proses Produksi ]', height: 180),
          const SizedBox(height: 14),
          Text(
            'Sentra industri & wisata bersejarah sejak era 1930-an. Berkembang menjadi pusat kerajinan porselen sejak ditetapkan sebagai proyek percontohan pemerintah pada tahun 1957, dipengaruhi gaya keramik Tiongkok dengan keunikan desain warisan masa lampau.',
            style: AppText.body13,
          ),
          const SizedBox(height: 14),
          AppButton(
            label: 'Selengkapnya',
            variant: AppButtonVariant.outline,
            trailingIcon: Icons.arrow_forward,
            expand: false,
            onPressed: () => widget.onNavigate(AppTab.tentang),
          ),
        ],
      ),
    );
  }

  Widget _usp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Kenapa Memilih Kami'),
          const SizedBox(height: 12),
          Text(
            'Kami menghubungkan pengunjung dengan cerita, pengrajin, dan karya asli Dinoyo melalui pengalaman digital yang jelas, rapi, dan mudah diakses.',
            style: AppText.body13,
          ),
          const SizedBox(height: 12),
          ...gapped(const [
            FeatureCard(
              icon: Icons.menu_book_outlined,
              iconBackground: AppColors.primary,
              title: 'Authentic Heritage Storytelling',
              description:
                  'Eksplorasi sejarah, filosofi desain, dan proses pembuatan keramik sejak 1930-an.',
            ),
            FeatureCard(
              icon: Icons.chat_bubble_outline_rounded,
              iconBackground: AppColors.sage,
              title: 'Direct Artisan Connection',
              description:
                  'Hubungi pengrajin langsung via WhatsApp tanpa perantara platform pihak ketiga.',
            ),
            FeatureCard(
              icon: Icons.grid_view_rounded,
              iconBackground: AppColors.brick,
              title: 'Curated Merchant Showcase',
              description:
                  'Etalase visual portofolio karya dan identitas unik tiap gerai keramik Dinoyo.',
            ),
          ], 12),
        ],
      ),
    );
  }

  Widget _timelinePreview() {
    const eras = [
      ('1', '1930-an', 'Awal produksi gerabah sederhana'),
      ('2', '1957', 'Proyek percontohan pemerintah, era porselen'),
      ('3', 'Warisan Desain', 'Motif miring khas, pengaruh keramik Tiongkok'),
      ('4', 'Kini', 'Sentra wisata edukasi & galeri pengrajin'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Jejak Sejarah Keramik Dinoyo',
            fontSize: 18,
            actionLabel: 'Semua',
            onAction: () => widget.onNavigate(AppTab.sejarah),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: gapped([
                for (final e in eras)
                  Container(
                    width: 160,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.tan,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(e.$1,
                              style: AppText.inter(
                                  size: 11,
                                  weight: FontWeight.w700,
                                  color: AppColors.background)),
                        ),
                        const SizedBox(height: 6),
                        Text(e.$2, style: AppText.cardTitle),
                        const SizedBox(height: 6),
                        Text(e.$3, style: AppText.body12),
                      ],
                    ),
                  ),
              ], 12, horizontal: true),
            ),
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ImagePlaceholder(
                label: '[ Foto Dokumentasi Arsip & Proses Pembuatan ]',
                height: 160),
          ),
        ],
      ),
    );
  }

  Widget _directoryPreview() {
    return Container(
      width: double.infinity,
      color: AppColors.sand,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Direktori Pengrajin & Toko',
            fontSize: 18,
            actionLabel: 'Semua',
            onAction: () => widget.onNavigate(AppTab.direktori),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: gapped([
                for (final shop in dummyShops.take(3)) ShopPreviewCard(shop: shop),
              ], 12, horizontal: true),
            ),
          ),
        ],
      ),
    );
  }
}
