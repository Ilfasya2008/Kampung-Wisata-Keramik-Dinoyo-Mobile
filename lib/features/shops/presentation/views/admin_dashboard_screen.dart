import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/launcher.dart';
import '../../../../widgets/app_bottom_nav.dart';
import '../../../../widgets/common.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../domain/entities/shop.dart';
import '../viewmodels/shop_viewmodel.dart';
import 'shop_form_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final ShopViewModel shopViewModel;
  final AuthViewModel authViewModel;
  const AdminDashboardScreen({
    super.key,
    required this.shopViewModel,
    required this.authViewModel,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _search = TextEditingController();

  static const _navItems = [
    NavItem('Dashboard', Icons.dashboard_outlined),
    NavItem('Toko', Icons.storefront_outlined),
    NavItem('Produk', Icons.inventory_2_outlined),
    NavItem('Akun', Icons.person_outline),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _addShop() async {
    final result = await Navigator.of(context).push<Shop>(
      MaterialPageRoute(builder: (_) => const ShopFormScreen()),
    );
    if (result != null && mounted) {
      widget.shopViewModel.addShop(result);
      showToast(context, 'Toko berhasil ditambahkan.');
    }
  }

  Future<void> _editShop(Shop shop) async {
    final result = await Navigator.of(context).push<Shop>(
      MaterialPageRoute(builder: (_) => ShopFormScreen(shop: shop)),
    );
    if (result != null && mounted) {
      widget.shopViewModel.updateShop(result);
      showToast(context, 'Perubahan toko disimpan.');
    }
  }

  Future<void> _deleteShop(Shop shop) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text('Hapus toko?', style: AppText.h3),
        content: Text('${shop.name} akan dihapus dari daftar direktori.',
            style: AppText.body13),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.brick)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      widget.shopViewModel.deleteShop(shop.id);
      showToast(context, 'Toko berhasil dihapus.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.shopViewModel,
      builder: (context, child) {
        final vm = widget.shopViewModel;
        final shops = vm.filteredShops;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              _header(),
              _stats(vm.allShops.length),
              _searchBar(vm),
              _filterChips(vm),
              _listHeader(shops.length, vm.allShops.length),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: shops.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                            child: Text('Tidak ada toko yang cocok.',
                                style: AppText.body13)),
                      )
                    : Column(
                        children: gapped([
                          for (final s in shops) _shopRow(s),
                        ], 12),
                      ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            items: _navItems,
            currentIndex: 1,
            onTap: (i) {
              if (i == 3) {
                Navigator.of(context).pushNamed('/persona');
              } else if (i != 1) {
                showToast(context, 'Halaman ${_navItems[i].label} belum tersedia.');
              }
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _addShop,
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            icon: const Icon(Icons.add),
            label: Text('Tambah Toko',
                style: AppText.inter(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.background)),
          ),
        );
      },
    );
  }

  Widget _header() {
    final user = widget.authViewModel.currentUser;
    return Container(
      color: AppColors.ink,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
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
                        Text('Panel Admin',
                            style: AppText.inter(
                                size: 15,
                                weight: FontWeight.w700,
                                color: AppColors.background)),
                        Text('${user?.name ?? 'Admin Paguyuban'} • Dinoyo',
                            style: AppText.inter(size: 11, color: AppColors.tan)),
                      ],
                    ),
                  ),
                  SquareIconButton(
                    icon: Icons.storefront_outlined,
                    tooltip: 'Lihat Tampilan Pengunjung',
                    background: const Color(0x1FFFFFFF),
                    color: AppColors.background,
                    bordered: false,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  SquareIconButton(
                    icon: Icons.logout,
                    tooltip: 'Keluar',
                    background: const Color(0x1FFFFFFF),
                    color: AppColors.background,
                    bordered: false,
                    onPressed: () async {
                      await widget.authViewModel.logout();
                      if (mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Kelola Toko & Pengrajin',
                  style: AppText.inter(
                      size: 24,
                      weight: FontWeight.w700,
                      height: 1.2,
                      color: AppColors.background)),
              const SizedBox(height: 6),
              Text(
                'Tambah, perbarui, dan sesuaikan status toko pengrajin di kawasan Dinoyo.',
                style: AppText.inter(size: 13, color: AppColors.tan),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stats(int total) {
    Widget stat(IconData icon, String label, String value, String caption) =>
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Column(
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
                const SizedBox(height: 10),
                Text(label, style: AppText.inter(size: 11, color: AppColors.muted)),
                Text(value,
                    style: AppText.inter(
                        size: 24, weight: FontWeight.w700, height: 1.2)),
                Text(caption,
                    style: AppText.inter(size: 10, color: AppColors.muted)),
              ],
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: gapped([
          stat(Icons.storefront_outlined, 'Total Toko', '$total',
              'toko terdaftar'),
          stat(Icons.groups_outlined, 'Workshop Aktif', '4',
              'tersedia/reservasi'),
          stat(Icons.inventory_2_outlined, 'Produk', '6', 'katalog utama'),
        ], 10, horizontal: true),
      ),
    );
  }

  Widget _searchBar(ShopViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 18, color: AppColors.muted),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _search,
                      onChanged: (val) => vm.setSearchQuery(val),
                      style: AppText.inter(size: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari nama toko / pengrajin...',
                        hintStyle: AppText.body13,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          SquareIconButton(
            icon: Icons.tune,
            size: 52,
            tooltip: 'Reset filter',
            onPressed: () {
              _search.clear();
              vm.resetFilters();
            },
          ),
        ],
      ),
    );
  }

  Widget _filterChips(ShopViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: gapped([
          for (final c in AppConstants.categories)
            FilterPill(
              label: c,
              selected: c == vm.selectedCategory,
              onTap: () => vm.setCategory(c),
            ),
        ], 8, horizontal: true),
      ),
    );
  }

  Widget _listHeader(int count, int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Expanded(child: Text('Daftar Toko & Sanggar', style: AppText.h3)),
          Text('$count dari $total toko', style: AppText.body12),
        ],
      ),
    );
  }

  Widget _shopRow(Shop s) {
    Widget action(
        IconData icon, String label, Color color, VoidCallback onTap) {
      final radius = BorderRadius.circular(10);
      return Material(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
              color:
                  color == AppColors.brick ? AppColors.brick : AppColors.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44, minWidth: 80),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 15, color: color),
                  const SizedBox(width: 6),
                  Text(label,
                      style: AppText.inter(
                          size: 12, weight: FontWeight.w600, color: color)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  s.imageAsset ?? 'assets/images/product_vas_bunga.jpg',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ImagePlaceholder(
                    label: '',
                    width: 56,
                    height: 56,
                    radius: 12,
                    iconSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name,
                        style: AppText.inter(size: 14, weight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text('${s.specialty} •', style: AppText.body12),
                        const SizedBox(width: 4),
                        const Icon(Icons.place_outlined,
                            size: 12, color: AppColors.muted),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(s.addressShort,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.body12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        WorkshopChip(s.workshop, short: true),
                        PillChip(
                          s.active ? 'Aktif' : 'Nonaktif',
                          background: s.active
                              ? AppColors.okBg
                              : const Color(0xFFE6DDD3),
                          foreground:
                              s.active ? AppColors.okFg : AppColors.muted,
                          fontSize: 10,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: gapped([
              action(Icons.edit_outlined, 'Edit', AppColors.ink,
                  () => _editShop(s)),
              action(Icons.delete_outline, 'Hapus', AppColors.brick,
                  () => _deleteShop(s)),
            ], 8, horizontal: true),
          ),
        ],
      ),
    );
  }
}
