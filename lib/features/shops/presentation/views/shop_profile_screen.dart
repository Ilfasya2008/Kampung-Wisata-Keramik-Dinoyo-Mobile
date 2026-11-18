import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/launcher.dart';
import '../../../../widgets/common.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/shop.dart';
import '../viewmodels/shop_viewmodel.dart';

class ShopProfileScreen extends StatefulWidget {
  final Shop shop;
  final ShopViewModel shopViewModel;
  const ShopProfileScreen({
    super.key,
    required this.shop,
    required this.shopViewModel,
  });

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  final _keys = List.generate(4, (_) => GlobalKey());
  int _tab = 0;
  bool _favorite = false;

  static const _tabs = ['Tentang', 'Galeri', 'Katalog', 'Kunjungan'];

  void _goToTab(int i) {
    setState(() => _tab = i);
    final ctx = _keys[i].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = widget.shop;
    final products = widget.shopViewModel.allProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hero(context, shop),
                  _tabBar(),
                  _section(_keys[0], _about(shop)),
                  _section(_keys[1], _gallery()),
                  _section(_keys[2], _catalog(products)),
                  _section(_keys[3], _visitInfo(shop)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _actionBar(context, shop),
        ],
      ),
    );
  }

  Widget _section(GlobalKey key, Widget child) =>
      Container(key: key, child: child);

  Widget _hero(BuildContext context, Shop shop) {
    final hoursShort = shop.hours.replaceAll(' WIB', '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image.asset(
                shop.imageAsset ?? 'assets/images/hero_dinoyo.jpg',
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ImagePlaceholder(
                  label: '[ FOTO SAMPUL TOKO / WORKSHOP ]',
                  height: 230,
                  radius: 0,
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      SquareIconButton(
                        icon: Icons.arrow_back,
                        tooltip: 'Kembali',
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      const ShareButton(),
                      const SizedBox(width: 8),
                      SquareIconButton(
                        icon: _favorite ? Icons.favorite : Icons.favorite_border,
                        color: _favorite ? AppColors.brick : AppColors.ink,
                        tooltip: 'Favorit',
                        onPressed: () {
                          setState(() => _favorite = !_favorite);
                          showToast(
                            context,
                            _favorite
                                ? 'Ditambahkan ke favorit'
                                : 'Dihapus dari favorit',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: AppColors.tan,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.white, width: 3),
                    ),
                    child: const Icon(Icons.storefront_outlined,
                        size: 28, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(shop.name,
                            style: AppText.inter(
                                size: 20,
                                weight: FontWeight.w700,
                                height: 1.22)),
                        const SizedBox(height: 4),
                        Text(
                          'Spesialis ${shop.specialty}'
                          '${shop.established != null ? ' • Est. ${shop.established}' : ''}',
                          style: AppText.body12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  PillChip(
                    shop.workshop.label,
                    icon: Icons.check_circle_outline,
                    background: shop.workshop.background,
                    foreground: shop.workshop.foreground,
                    fontSize: 11,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                  ),
                  PillChip(
                    shop.address,
                    icon: Icons.place_outlined,
                    fontSize: 11,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: gapped([
                  _quickInfo(Icons.schedule, hoursShort, 'Jam buka'),
                  _quickInfo(Icons.groups_outlined, 'Rombongan', 'Workshop'),
                  _quickInfo(
                      Icons.storefront_outlined,
                      shop.established != null
                          ? 'Sejak ${shop.established}'
                          : '-',
                      'Berdiri'),
                ], 10, horizontal: true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickInfo(IconData icon, String value, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(value,
                  textAlign: TextAlign.center,
                  style: AppText.inter(size: 12, weight: FontWeight.w700)),
              Text(label,
                  style: AppText.inter(size: 10, color: AppColors.muted)),
            ],
          ),
        ),
      );

  Widget _tabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.border),
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => _goToTab(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            i == _tab ? AppColors.primary : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Text(
                    _tabs[i],
                    textAlign: TextAlign.center,
                    style: AppText.inter(
                      size: 13,
                      weight: i == _tab ? FontWeight.w700 : FontWeight.w600,
                      color: i == _tab ? AppColors.primary : AppColors.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _about(Shop shop) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Tentang Toko', fontSize: 18),
          const SizedBox(height: 10),
          Text(
            shop.about.isNotEmpty
                ? shop.about
                : 'Profil pengrajin belum dilengkapi.',
            style: AppText.body13,
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Lokasi Toko',
            fontSize: 18,
            actionLabel: 'Buka Maps',
            onAction: () => openMaps(context,
                '${shop.name}, ${shop.address}, Dinoyo, Kota Malang'),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/map_dinoyo.jpg',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gallery() {
    final images = [
      'assets/images/workshop_action.jpg',
      'assets/images/product_vas_bunga.jpg',
      'assets/images/product_set_cangkir.jpg',
      'assets/images/product_guci_dekoratif.jpg',
      'assets/images/product_teko_poci.jpg',
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Galeri Workshop & Karya',
            fontSize: 18,
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, index) => ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  images[index],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _catalog(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Katalog Produk Pilihan',
                    style: AppText.inter(
                        size: 18, weight: FontWeight.w700, height: 1.22)),
              ),
              Text('${products.length} produk', style: AppText.body12),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, c) {
              final w = (c.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final p in products)
                    SizedBox(width: w, child: _productCard(p)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _productCard(Product p) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                p.imageAsset,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ImagePlaceholder(
                  label: '[ Foto Produk ]',
                  height: 130,
                  radius: 0,
                ),
              ),
              Positioned(
                left: 8,
                top: 8,
                child: PillChip(
                  p.category,
                  background: AppColors.white,
                  fontSize: 10,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.inter(size: 13, weight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(p.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.inter(size: 11, color: AppColors.muted)),
                const SizedBox(height: 8),
                Text(
                  p.price ?? 'Hubungi pengrajin',
                  style: AppText.inter(
                    size: p.price != null ? 14 : 12,
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
  }

  Widget _visitInfo(Shop shop) {
    Widget row(IconData icon, String text) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.tan,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(text, style: AppText.body13),
              ),
            ),
          ],
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
              title: 'Informasi Kunjungan & Edukasi', fontSize: 18),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.sand,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: gapped([
                row(Icons.schedule, 'Jam operasional: ${shop.hours}'),
                row(Icons.groups_outlined,
                    'Workshop edukasi tersedia untuk rombongan sekolah, instansi & keluarga. Hubungi via WhatsApp untuk reservasi.'),
              ], 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBar(BuildContext context, Shop shop) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: AppShadows.bottomBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: [
              AppButton(
                label: 'Tanya Jadwal',
                variant: AppButtonVariant.outline,
                icon: Icons.calendar_today_outlined,
                expand: false,
                minHeight: 50,
                onPressed: () => openWhatsApp(
                  context,
                  phone: shop.whatsapp,
                  message:
                      'Halo ${shop.name}, saya ingin menanyakan jadwal kunjungan/workshop keramik.',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: 'Hubungi via WhatsApp',
                  variant: AppButtonVariant.whatsapp,
                  icon: Icons.chat_bubble_outline_rounded,
                  minHeight: 50,
                  onPressed: () => openWhatsApp(
                    context,
                    phone: shop.whatsapp,
                    message:
                        'Halo ${shop.name}, saya tertarik dengan produk keramik Anda.',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
