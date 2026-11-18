import 'package:flutter/material.dart';
import '../core/services/notification_service.dart';
import '../features/ai_insight/presentation/viewmodels/ai_insight_viewmodel.dart';
import '../features/auth/domain/entities/user.dart';
import '../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../features/auth/presentation/views/profile_dialog.dart';
import '../features/history/presentation/viewmodels/history_viewmodel.dart';
import '../features/home/presentation/widgets/device_camera_sheet.dart';
import '../features/home/presentation/widgets/dinoyo_map_card.dart';
import '../features/home/presentation/widgets/notifications_sheet.dart';
import '../features/shops/presentation/viewmodels/shop_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/shop_cards.dart';
import 'main_shell.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int> onNavigate;
  final AuthViewModel authViewModel;
  final ShopViewModel shopViewModel;
  final HistoryViewModel historyViewModel;
  final AiInsightViewModel aiViewModel;
  final NotificationService notificationService;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.authViewModel,
    required this.shopViewModel,
    required this.historyViewModel,
    required this.aiViewModel,
    required this.notificationService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _heroController = PageController();
  int _heroPage = 0;

  static const _heroImages = [
    ('assets/images/hero_dinoyo.jpg', 'Gerbang Utama & Sentra Budaya Dinoyo'),
    ('assets/images/workshop_action.jpg', 'Aktivitas Workshop Edukasi Meja Putar'),
    ('assets/images/paguyuban_banner.jpg', 'Paguyuban Pengrajin Keramik Dinoyo'),
  ];

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
                  _aiAdvisorBanner(),
                  _productShowcase(),
                  _about(),
                  _timelinePreview(),
                  _mapSection(),
                  _directoryPreview(),
                  _deviceCameraAction(),
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
    return ListenableBuilder(
      listenable: widget.authViewModel,
      builder: (context, child) {
        final user = widget.authViewModel.currentUser;
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
                child: InkWell(
                  onTap: () =>
                      showUserProfileDialog(context, widget.authViewModel),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user != null ? user.name : 'Kampung Keramik Dinoyo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.inter(size: 14, weight: FontWeight.w700),
                      ),
                      Text(
                        user != null
                            ? '${user.role.label} • Akun Aktif'
                            : 'Portofolio digital & direktori budaya',
                        style: AppText.inter(size: 10, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ),
              SquareIconButton(
                icon: Icons.notifications_none,
                tooltip: 'Pusat Notifikasi',
                onPressed: () => showNotificationsSheet(
                    context, widget.notificationService),
              ),
              const SizedBox(width: 8),
              if (user != null && user.isAdmin)
                SquareIconButton(
                  icon: Icons.admin_panel_settings_outlined,
                  tooltip: 'Panel Admin',
                  onPressed: () => Navigator.of(context).pushNamed('/admin'),
                )
              else
                SquareIconButton(
                  icon: user != null ? Icons.person : Icons.login,
                  tooltip: user != null ? 'Profil Akun' : 'Masuk Akun',
                  onPressed: () {
                    if (user != null) {
                      showUserProfileDialog(context, widget.authViewModel);
                    } else {
                      Navigator.of(context).pushNamed('/login');
                    }
                  },
                ),
            ],
          ),
        );
      },
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
                  child: Text('Cari produk, toko, atau sejarah Dinoyo...',
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                    itemCount: _heroImages.length,
                    onPageChanged: (i) => setState(() => _heroPage = i),
                    itemBuilder: (_, i) => Image.asset(
                      _heroImages[i].$1,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, _, _) => const ImagePlaceholder(
                        label: '[ Foto Banner Keramik Dinoyo ]',
                        height: 220,
                        radius: 0,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < _heroImages.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _heroPage ? 20 : 6,
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
          const PillChip('Sentra budaya & kerajinan keramik Kota Malang'),
          const SizedBox(height: 12),
          Text('Kampung Wisata\nKeramik Dinoyo', style: AppText.h1),
          const SizedBox(height: 10),
          Text(
            'Menghadirkan karya seni semi-porselen, gerabah otentik, dan workshop edukasi sejak 1930-an. Nikmati perpaduan tradisi budaya lokal Jawa dan estetika ornamen Tiongkok.',
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
                        style: AppText.inter(size: 11, weight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: gapped([
          item(Icons.schedule, 'Sejarah', AppTab.sejarah),
          item(Icons.storefront_outlined, 'Direktori', AppTab.direktori),
          item(Icons.auto_awesome, 'AI Kurator', AppTab.aiKurator),
          item(Icons.place_outlined, 'Peta & GPS', AppTab.kontak),
        ], 10, horizontal: true),
      ),
    );
  }

  Widget _aiAdvisorBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 26, color: AppColors.background),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Konsultasi AI Kurator Seni',
                      style: AppText.inter(
                          size: 15,
                          weight: FontWeight.w700,
                          color: AppColors.background)),
                  const SizedBox(height: 2),
                  Text(
                    'Bingung memilih keramik atau suvenir? Dapatkan rekomendasi berbasis AI sekarang.',
                    style: AppText.inter(size: 11, color: AppColors.tan),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.background,
                foregroundColor: AppColors.ink,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => widget.onNavigate(AppTab.aiKurator),
              child: const Text('Tanya AI', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productShowcase() {
    final products = widget.shopViewModel.allProducts;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Koleksi Produk Pilihan Dinoyo',
          fontSize: 18,
          actionLabel: 'Lihat Semua',
          onAction: () => widget.onNavigate(AppTab.direktori),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final p = products[index];
              return Container(
                width: 180,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppShadows.card,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          p.imageAsset,
                          height: 115,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const ImagePlaceholder(
                            label: '[ Produk ]',
                            height: 115,
                            radius: 0,
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: PillChip(
                            p.category,
                            background: AppColors.white,
                            fontSize: 9,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.inter(
                                  size: 12, weight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(p.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.inter(
                                  size: 10, color: AppColors.muted)),
                          const SizedBox(height: 6),
                          Text(
                            p.price ?? 'Hubungi Pengrajin',
                            style: AppText.inter(
                              size: 12,
                              weight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
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
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/workshop_action.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Sentra industri & wisata bersejarah sejak era Kerajaan Kanjuruhan (abad ke-8 M) dan rintisan modern 1930. Ditetapkan sebagai proyek percontohan semi-porselen pemerintah pada tahun 1957 dengan tungku 1.200°C dan motif miring yang memikat.',
            style: AppText.body13,
          ),
          const SizedBox(height: 14),
          AppButton(
            label: 'Pelajari Sejarah Lengkap',
            variant: AppButtonVariant.outline,
            trailingIcon: Icons.arrow_forward,
            expand: false,
            onPressed: () => widget.onNavigate(AppTab.sejarah),
          ),
        ],
      ),
    );
  }

  Widget _timelinePreview() {
    final eras = widget.historyViewModel.eras;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Jejak Sejarah Dinoyo',
            fontSize: 18,
            actionLabel: 'Semua Era',
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
                for (var i = 0; i < eras.length; i++)
                  Container(
                    width: 170,
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
                          child: Text('${i + 1}',
                              style: AppText.inter(
                                  size: 11,
                                  weight: FontWeight.w700,
                                  color: AppColors.background)),
                        ),
                        const SizedBox(height: 8),
                        Text(eras[i].chip, style: AppText.cardTitle),
                        const SizedBox(height: 4),
                        Text(eras[i].title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.body12),
                      ],
                    ),
                  ),
              ], 12, horizontal: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Lokasi & Peta Google Maps', fontSize: 18),
          const SizedBox(height: 12),
          const DinoyoMapCard(),
        ],
      ),
    );
  }

  Widget _directoryPreview() {
    final shops = widget.shopViewModel.allShops;
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
            actionLabel: 'Semua Toko',
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
                for (final shop in shops.take(4))
                  ShopPreviewCard(
                    shop: shop,
                    onTap: () => openShopProfile(
                        context, shop, widget.shopViewModel),
                  ),
              ], 12, horizontal: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceCameraAction() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Container(
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.tan,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.camera_alt_outlined,
                  size: 22, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dokumentasi Kunjungan', style: AppText.cardTitle),
                  Text('Abadikan foto karya keramik Anda dengan kamera HP.',
                      style: AppText.body12),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () =>
                  showDeviceCameraSheet(context, widget.notificationService),
              child: const Text('Buka Kamera', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}
