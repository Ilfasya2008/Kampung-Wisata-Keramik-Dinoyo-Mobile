import 'package:flutter/material.dart';

import '../ml/shop_recommender.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/recommendation_cards.dart';

/// Rekomendasi Cerdas: pengunjung menulis kebutuhannya dengan bahasa bebas,
/// model TF-IDF + cosine similarity mengurutkan toko yang paling relevan.
class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key, this.initialQuery = ''});
  final String initialQuery;

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  late final _query = TextEditingController(text: widget.initialQuery);
  final _model = ShopRecommender.instance;

  static const _examples = [
    'Belajar membuat gerabah bersama rombongan sekolah',
    'Oleh-oleh murah khas Malang',
    'Hadiah cangkir teh porselen',
    'Piring untuk kafe, pesan grosir',
  ];

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _use(String text) {
    _query
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final text = _query.text.trim();
    final results = _model.recommend(text);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(
              title: 'Rekomendasi Cerdas',
              subtitle: 'Temukan toko sesuai kebutuhanmu',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  _intro(),
                  const SizedBox(height: 16),
                  _input(),
                  const SizedBox(height: 12),
                  _exampleChips(),
                  const SizedBox(height: 20),
                  if (text.isEmpty)
                    _hint(Icons.edit_note,
                        'Tulis kebutuhanmu di atas, misalnya jenis keramik, tujuan kunjungan, atau anggaran.')
                  else if (results.isEmpty)
                    _hint(Icons.search_off,
                        'Belum ada toko yang cocok dengan "$text". Coba kata lain seperti gerabah, suvenir, porselen, atau workshop.')
                  else ...[
                    Text('${results.length} toko paling relevan',
                        style: AppText.h3),
                    const SizedBox(height: 2),
                    Text('Diurutkan dari skor kecocokan tertinggi',
                        style: AppText.body12),
                    const SizedBox(height: 12),
                    ...gapped([
                      for (var i = 0; i < results.length; i++)
                        RecommendationCard(
                            rank: i + 1, recommendation: results[i]),
                    ], 14),
                  ],
                  const SizedBox(height: 20),
                  _modelInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _intro() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PillChip('Machine Learning • TF-IDF + Cosine Similarity',
              icon: Icons.auto_awesome,
              background: AppColors.white),
          const SizedBox(height: 10),
          Text('Ceritakan kebutuhanmu, kami carikan tokonya',
              style: AppText.h3),
          const SizedBox(height: 6),
          Text(
            'Model membandingkan kalimatmu dengan profil, spesialisasi, workshop, dan katalog produk setiap pengrajin.',
            style: AppText.body13,
          ),
        ],
      ),
    );
  }

  Widget _input() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _query,
              autofocus: widget.initialQuery.isEmpty,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.search,
              onChanged: (_) => setState(() {}),
              style: AppText.inter(size: 14),
              decoration: InputDecoration(
                hintText: 'Contoh: ingin ikut workshop gerabah',
                hintStyle: AppText.body13,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (_query.text.isNotEmpty)
            IconButton(
              tooltip: 'Hapus',
              icon: const Icon(Icons.close, size: 18, color: AppColors.muted),
              onPressed: () => _use(''),
            ),
        ],
      ),
    );
  }

  Widget _exampleChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Coba contoh:', style: AppText.body12),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final e in _examples)
              ActionChip(
                label: Text(e),
                labelStyle: AppText.inter(size: 12, weight: FontWeight.w600),
                backgroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
                onPressed: () => _use(e),
              ),
          ],
        ),
      ],
    );
  }

  Widget _hint(IconData icon, String message) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.muted),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: AppText.body13)),
        ],
      ),
    );
  }

  Widget _modelInfo() {
    final v = _model.vectorizer;
    return Center(
      child: Text(
        'Model dilatih dari ${v.documentCount} profil toko • '
        '${v.vocabularySize} kata kunci • berjalan di perangkat',
        textAlign: TextAlign.center,
        style: AppText.inter(size: 11, color: AppColors.muted),
      ),
    );
  }
}
