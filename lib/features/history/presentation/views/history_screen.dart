import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/common.dart';
import '../../domain/entities/history_era.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryScreen extends StatefulWidget {
  final HistoryViewModel viewModel;
  const HistoryScreen({super.key, required this.viewModel});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final List<GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _keys = List.generate(
      widget.viewModel.eras.length,
      (_) => GlobalKey(),
    );
  }

  void _select(int i) {
    widget.viewModel.selectEra(i);
    if (i < _keys.length) {
      final ctx = _keys[i].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          alignment: 0.05,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        final eras = widget.viewModel.eras;
        return SafeArea(
          bottom: false,
          child: Column(
            children: [
              const AppTopBar(
                title: 'Sejarah Keramik Dinoyo',
                subtitle: 'Linimasa warisan budaya sejak abad ke-8 hingga kini',
                trailing: ShareButton(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(),
                      _timelineIntro(),
                      _eraChips(eras),
                      _timeline(eras),
                      const WorkshopCta(
                        description:
                            'Telusuri langsung jejak sejarah di Kampung Wisata Keramik Dinoyo. Ikuti workshop meja putar dan temui maestro pengrajin di sanggar mereka.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PillChip('Sentra Warisan Budaya Kota Malang'),
            const SizedBox(height: 12),
            Text('Jejak Sejarah Keramik Dinoyo',
                style: AppText.h2.copyWith(fontSize: 26)),
            const SizedBox(height: 10),
            Text(
              'Menyusuri narasi peradaban dari artefak tanah liat era Kerajaan Kanjuruhan (760 M), sentra gerabah kolonial 1930, pabrik percontohan semi-porselen 1957, hingga menjadi Kampung Tematik Edu-Wisata unggulan di Kota Malang.',
              style: AppText.body13,
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/hero_dinoyo.jpg',
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ImagePlaceholder(
                  label: '[ Foto Arsip Kampung Keramik Dinoyo ]',
                  height: 190,
                  radius: 20,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _timelineIntro() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Garis Waktu Perjalanan Warisan', style: AppText.h3),
            const SizedBox(height: 8),
            Text(
              'Pilih era di bawah ini untuk melihat transformasi teknologi, filosofi estetika motif miring, dan ketangguhan perajin Dinoyo lintas zaman.',
              style: AppText.body13,
            ),
          ],
        ),
      );

  Widget _eraChips(List<HistoryEra> eras) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: gapped([
            for (var i = 0; i < eras.length; i++)
              FilterPill(
                label: eras[i].chip,
                selected: i == widget.viewModel.selectedEraIndex,
                onTap: () => _select(i),
              ),
          ], 8, horizontal: true),
        ),
      );

  Widget _timeline(List<HistoryEra> eras) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          for (var i = 0; i < eras.length; i++)
            IntrinsicHeight(
              key: i < _keys.length ? _keys[i] : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 28,
                    child: Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.background, width: 2),
                          ),
                          child: Text('${i + 1}',
                              style: AppText.inter(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.background)),
                        ),
                        if (i < eras.length - 1)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: AppColors.border,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: i < eras.length - 1 ? 20 : 0),
                      child: _eraCard(eras[i], i),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _eraCard(HistoryEra era, int i) {
    final isSelected = i == widget.viewModel.selectedEraIndex;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PillChip(era.period),
              const Spacer(),
              Text('Era ${i + 1} dari ${widget.viewModel.eras.length}',
                  style: AppText.body12),
            ],
          ),
          const SizedBox(height: 10),
          Text(era.title,
              style: AppText.inter(
                  size: 17, weight: FontWeight.w700, height: 1.3)),
          const SizedBox(height: 8),
          Text(era.description, style: AppText.body13),
          const SizedBox(height: 12),

          // Cultural Significance Callout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tan,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_stories_outlined,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    era.culturalSignificance,
                    style: AppText.inter(
                        size: 12,
                        weight: FontWeight.w600,
                        color: AppColors.ink),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Real Image of Era
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              era.imageAsset,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => ImagePlaceholder(
                label: '[ Foto: ${era.title} ]',
                height: 140,
                radius: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Milestones
          Text('Catatan Sejarah Kunci:',
              style: AppText.inter(size: 12, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          for (final m in era.keyMilestones)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(m, style: AppText.body12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
