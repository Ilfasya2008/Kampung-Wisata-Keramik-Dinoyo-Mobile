import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/common.dart';
import '../../../../widgets/shop_cards.dart';
import '../viewmodels/shop_viewmodel.dart';

class DirectoryScreen extends StatefulWidget {
  final ShopViewModel viewModel;
  const DirectoryScreen({super.key, required this.viewModel});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.text = widget.viewModel.searchQuery;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        final vm = widget.viewModel;
        final shops = vm.filteredShops;

        return SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppTopBar(
                title: 'Direktori Pengrajin',
                subtitle: 'Profil, galeri karya & lokasi toko di Dinoyo',
                trailing: SquareIconButton(
                  icon: Icons.tune,
                  tooltip: 'Reset Filter',
                  onPressed: () {
                    _search.clear();
                    vm.resetFilters();
                  },
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
                          const PillChip('Direktori Pengrajin & Toko'),
                          const SizedBox(height: 12),
                          Text('Sentra Galeri & Sanggar Keramik',
                              style: AppText.h2.copyWith(fontSize: 24)),
                          const SizedBox(height: 8),
                          Text(
                            'Temukan pengrajin semi-porselen, gerabah tradisional, dan suvenir khas Kampung Dinoyo',
                            style: AppText.body13,
                          ),
                        ],
                      ),
                    ),
                    _searchBar(vm),
                    _categoryChips(vm),
                    _resultMeta(vm, shops.length),
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
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _searchBar(ShopViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
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
                  hintText: 'Cari nama pengrajin, spesialisasi, atau alamat...',
                  hintStyle: AppText.body13,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            if (_search.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: 16, color: AppColors.muted),
                onPressed: () {
                  _search.clear();
                  vm.setSearchQuery('');
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChips(ShopViewModel vm) {
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

  Widget _resultMeta(ShopViewModel vm, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Text('Menampilkan $count pengrajin terdaftar',
                style: AppText.body12),
          ),
          InkWell(
            onTap: () => vm.toggleSort(),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  Text('Urutan: ${vm.ascending ? 'A-Z' : 'Z-A'}',
                      style: AppText.inter(
                          size: 12,
                          weight: FontWeight.w600,
                          color: AppColors.primary)),
                  const SizedBox(width: 2),
                  Icon(
                    vm.ascending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
