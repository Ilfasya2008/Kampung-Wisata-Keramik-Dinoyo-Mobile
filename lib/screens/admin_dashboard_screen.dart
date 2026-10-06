import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../utils/launcher.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/common.dart';
import 'shop_form_screen.dart';

/// Screen 09 - CRUD Dashboard Admin.
/// Data lives in memory only; replace with your backend / database.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late List<Shop> _shops = List.of(dummyShops);
  final _search = TextEditingController();
  String? _category; // null = all
  WorkshopStatus? _workshop; // null = all
  bool? _active; // null = all

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

  List<Shop> get _filtered {
    final q = _search.text.trim().toLowerCase();
    return _shops.where((s) {
      if (_category != null && !s.categoryKeys.contains(_category)) return false;
      if (_workshop != null && s.workshop != _workshop) return false;
      if (_active != null && s.active != _active) return false;
      if (q.isNotEmpty &&
          !s.name.toLowerCase().contains(q) &&
          !s.specialty.toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _addShop() async {
    final result = await Navigator.of(context).push<Shop>(
      MaterialPageRoute(builder: (_) => const ShopFormScreen()),
    );
    if (result != null && mounted) {
      setState(() => _shops = [result, ..._shops]);
      showToast(context, 'Toko ditambahkan.');
    }
  }

  Future<void> _editShop(Shop shop) async {
    final result = await Navigator.of(context).push<Shop>(
      MaterialPageRoute(builder: (_) => ShopFormScreen(shop: shop)),
    );
    if (result != null && mounted) {
      setState(() {
        _shops = [for (final s in _shops) s.id == shop.id ? result : s];
      });
      showToast(context, 'Perubahan disimpan.');
    }
  }

  Future<void> _deleteShop(Shop shop) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text('Hapus toko?', style: AppText.h3),
        content: Text('${shop.name} akan dihapus dari daftar.',
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
      setState(() => _shops = _shops.where((s) => s.id != shop.id).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final shops = _filtered;
    return Scaffold(
      body: ListView(
              padding: EdgeInsets.zero,
              children: [
                _header(),
                _stats(),
                _searchBar(),
                _filterChips(),
                _listHeader(shops.length),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
                  child: Column(
                    children: [
                      Text(
                        'Menampilkan ${shops.length} dari $kTotalShops toko • Data contoh untuk keperluan desain',
                        textAlign: TextAlign.center,
                        style: AppText.inter(size: 11, color: AppColors.muted),
                      ),
                      const SizedBox(height: 16),
                      const Pagination(pages: 5),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: AppBottomNav(
        items: _navItems,
        currentIndex: 1,
        onTap: (i) {
          if (i != 1) {
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
                size: 14, weight: FontWeight.w700, color: AppColors.background)),
      ),
    );
  }

  Widget _header() {
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
                        Text('Admin Paguyuban • Akses semua toko',
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
                    onPressed: () {
                      final nav = Navigator.of(context);
                      if (nav.canPop()) {
                        nav.pop();
                      } else {
                        nav.pushReplacementNamed('/');
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  SquareIconButton(
                    icon: Icons.notifications_none,
                    tooltip: 'Notifikasi',
                    background: const Color(0x1FFFFFFF),
                    color: AppColors.background,
                    bordered: false,
                    onPressed: () => showToast(context, 'Belum ada notifikasi.'),
                  ),
                  const SizedBox(width: 8),
                  SquareIconButton(
                    icon: Icons.logout,
                    tooltip: 'Keluar',
                    background: const Color(0x1FFFFFFF),
                    color: AppColors.background,
                    bordered: false,
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
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
                'Tambah, ubah, dan nonaktifkan toko yang tampil di Direktori Pengrajin.',
                style: AppText.inter(size: 13, color: AppColors.tan),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stats() {
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
          stat(Icons.storefront_outlined, 'Total Toko', '$kTotalShops',
              'toko terdaftar'),
          stat(Icons.groups_outlined, 'Workshop Aktif', '12',
              'tersedia / dengan reservasi'),
          stat(Icons.inventory_2_outlined, 'Produk', '86', 'di seluruh katalog'),
        ], 10, horizontal: true),
      ),
    );
  }

  Widget _searchBar() {
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
                      onChanged: (_) => setState(() {}),
                      style: AppText.inter(size: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari nama toko / pengrajin...',
                        hintStyle: AppText.body13,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
            onPressed: () => setState(() {
              _category = null;
              _workshop = null;
              _active = null;
              _search.clear();
            }),
          ),
        ],
      ),
    );
  }

  Widget _filterChips() {
    Widget chip<T>({
      required String label,
      required List<(String, T?)> options,
      required bool active,
      required ValueChanged<T?> onSelected,
    }) {
      return PopupMenuButton<int>(
        onSelected: (i) => onSelected(options[i].$2),
        itemBuilder: (_) => [
          for (var i = 0; i < options.length; i++)
            PopupMenuItem(value: i, child: Text(options[i].$1)),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: const BoxConstraints(minHeight: 44),
          decoration: BoxDecoration(
            color: active ? AppColors.tan : AppColors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                color: active ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: AppText.inter(size: 13, weight: FontWeight.w600)),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  size: 16, color: AppColors.muted),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: gapped([
          chip<String>(
            label: _category ?? 'Semua Kategori',
            active: _category != null,
            options: [
              ('Semua Kategori', null),
              for (final c in kCategories.skip(1)) (c, c),
            ],
            onSelected: (v) => setState(() => _category = v),
          ),
          chip<WorkshopStatus>(
            label: _workshop?.shortLabel ?? 'Status Workshop',
            active: _workshop != null,
            options: [
              ('Semua Status Workshop', null),
              for (final w in WorkshopStatus.values) (w.shortLabel, w),
            ],
            onSelected: (v) => setState(() => _workshop = v),
          ),
          chip<bool>(
            label: _active == null ? 'Status Toko' : (_active! ? 'Aktif' : 'Nonaktif'),
            active: _active != null,
            options: const [
              ('Semua Status Toko', null),
              ('Aktif', true),
              ('Nonaktif', false),
            ],
            onSelected: (v) => setState(() => _active = v),
          ),
        ], 8, horizontal: true),
      ),
    );
  }

  Widget _listHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
      child: Row(
        children: [
          Expanded(child: Text('Daftar Toko', style: AppText.h3)),
          Text('$count dari $kTotalShops', style: AppText.body12),
        ],
      ),
    );
  }

  Widget _shopRow(Shop s) {
    Widget action(IconData icon, String label, Color color, VoidCallback onTap) {
      final radius = BorderRadius.circular(10);
      return Material(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: color == AppColors.brick ? AppColors.brick : AppColors.border),
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
              const ImagePlaceholder(
                label: '',
                width: 56,
                height: 56,
                radius: 12,
                iconSize: 20,
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
                          background:
                              s.active ? AppColors.okBg : const Color(0xFFE6DDD3),
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
