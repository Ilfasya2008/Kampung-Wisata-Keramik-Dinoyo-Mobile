import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/shop_cards.dart';

/// Screen 02 - Direktori Pengrajin.
class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final _search = TextEditingController();
  String _category = kCategories.first;
  bool _ascending = true;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Shop> get _filtered {
    final q = _search.text.trim().toLowerCase();
    final list = dummyShops.where((s) {
      final matchCategory =
          _category == kCategories.first || s.categoryKeys.contains(_category);
      final matchQuery = q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          s.specialty.toLowerCase().contains(q) ||
          s.address.toLowerCase().contains(q);
      return matchCategory && matchQuery && s.active;
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return _ascending ? list : list.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final shops = _filtered;
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          AppTopBar(
            title: 'Direktori Pengrajin',
            subtitle: 'Profil, galeri karya & lokasi toko',
            trailing: SquareIconButton(
              icon: Icons.favorite_border,
              tooltip: 'Favorit',
              onPressed: () => showFavoritesHint(context),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PillChip('Direktori pengrajin & toko'),
                      const SizedBox(height: 12),
                      Text('Direktori Pengrajin & Toko Keramik',
                          style: AppText.h2.copyWith(fontSize: 24)),
                      const SizedBox(height: 8),
                      Text(
                        'Temukan profil pengrajin, galeri karya, dan lokasi toko di Kampung Dinoyo',
                        style: AppText.body13,
                      ),
                    ],
                  ),
                ),
                _searchBar(),
                _categoryChips(),
                _resultMeta(shops.length),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: shops.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Text('Tidak ada toko yang cocok.',
                                style: AppText.body13),
                          ),
                        )
                      : Column(
                          children: gapped([
                            for (final s in shops) ShopListCard(shop: s),
                          ], 14),
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Pagination(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showFavoritesHint(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
          const SnackBar(content: Text('Favorit belum tersedia.')));
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
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
                        hintText: 'Cari nama pengrajin / toko...',
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
            background: AppColors.primary,
            color: AppColors.background,
            bordered: false,
            tooltip: 'Filter',
            onPressed: () => setState(() {
              _category = kCategories.first;
              _search.clear();
            }),
          ),
        ],
      ),
    );
  }

  Widget _categoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: gapped([
          for (final c in kCategories)
            FilterPill(
              label: c,
              selected: c == _category,
              onTap: () => setState(() => _category = c),
            ),
        ], 8, horizontal: true),
      ),
    );
  }

  Widget _resultMeta(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Text('Menampilkan $count dari $kTotalShops pengrajin',
                style: AppText.body12),
          ),
          InkWell(
            onTap: () => setState(() => _ascending = !_ascending),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Text('Urutkan: ${_ascending ? 'A-Z' : 'Z-A'}',
                      style: AppText.inter(
                          size: 12,
                          weight: FontWeight.w600,
                          color: AppColors.primary)),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
