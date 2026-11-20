import 'package:flutter/material.dart';

import '../ml/shop_recommender.dart';
import '../theme/app_theme.dart';
import 'common.dart';
import 'shop_cards.dart';

void openRecommendations(BuildContext context, {String query = ''}) {
  Navigator.of(context).pushNamed(
    query.isEmpty
        ? '/rekomendasi'
        : '/rekomendasi?q=${Uri.encodeQueryComponent(query)}',
  );
}

/// Entry point card "Bingung pilih toko?" (Beranda & Direktori).
class SmartRecommendationBanner extends StatelessWidget {
  const SmartRecommendationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return Material(
      color: AppColors.ink,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: () => openRecommendations(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome,
                    size: 20, color: AppColors.background),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bingung pilih toko?',
                        style: AppText.inter(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.background)),
                    const SizedBox(height: 2),
                    Text(
                      'Ketik kebutuhanmu, Rekomendasi Cerdas mencarikan toko yang paling cocok.',
                      style: AppText.inter(size: 12, color: AppColors.tan),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward,
                  size: 18, color: AppColors.background),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kecocokan (skor cosine) sebagai label + bar.
class MatchScore extends StatelessWidget {
  const MatchScore({super.key, required this.score, this.label = 'Kecocokan'});
  final double score;
  final String label;

  @override
  Widget build(BuildContext context) {
    final pct = (score * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: AppText.body12)),
            Text('$pct%',
                style: AppText.inter(
                    size: 12,
                    weight: FontWeight.w700,
                    color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: score.clamp(0, 1).toDouble(),
            minHeight: 6,
            backgroundColor: AppColors.sand,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class ReasonChips extends StatelessWidget {
  const ReasonChips(this.reasons, {super.key});
  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    if (reasons.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Cocok karena:', style: AppText.body12),
        for (final r in reasons)
          PillChip(r,
              background: AppColors.okBg,
              foreground: AppColors.okFg,
              fontSize: 10,
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4)),
      ],
    );
  }
}

/// Kartu hasil di layar Rekomendasi.
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.rank,
    required this.recommendation,
  });

  final int rank;
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final shop = recommendation.shop;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: rank == 1 ? AppColors.primary : AppColors.border,
            width: rank == 1 ? 1.5 : 1),
        boxShadow: AppShadows.card,
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
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: rank == 1 ? AppColors.primary : AppColors.tan,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('#$rank',
                    style: AppText.inter(
                        size: 13,
                        weight: FontWeight.w700,
                        color: rank == 1
                            ? AppColors.background
                            : AppColors.primary)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: AppText.cardTitle),
                    Text('${shop.specialty} • ${shop.addressShort}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body12),
                    const SizedBox(height: 6),
                    WorkshopChip(shop.workshop),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          MatchScore(score: recommendation.score),
          const SizedBox(height: 10),
          ReasonChips(recommendation.reasons),
          const SizedBox(height: 12),
          AppButton(
            label: 'Lihat Profil Toko',
            trailingIcon: Icons.arrow_forward,
            minHeight: 44,
            onPressed: () => openShopProfile(context, shop),
          ),
        ],
      ),
    );
  }
}

/// Kartu kecil di bagian "Toko Serupa" pada Profil Toko.
class SimilarShopCard extends StatelessWidget {
  const SimilarShopCard({super.key, required this.recommendation});
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final shop = recommendation.shop;
    final radius = BorderRadius.circular(18);
    return SizedBox(
      width: 230,
      child: Material(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: () => openShopProfile(context, shop),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cardTitle),
                Text(shop.specialty, style: AppText.body12),
                const SizedBox(height: 10),
                MatchScore(score: recommendation.score, label: 'Kemiripan'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final r in recommendation.reasons)
                      PillChip(r,
                          background: AppColors.okBg,
                          foreground: AppColors.okFg,
                          fontSize: 10,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
