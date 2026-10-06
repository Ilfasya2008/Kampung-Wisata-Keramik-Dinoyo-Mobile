import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Screen 03 - Sejarah Timeline.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _keys = List.generate(historyEras.length, (_) => GlobalKey());
  int _selected = 0;

  void _select(int i) {
    setState(() => _selected = i);
    final ctx = _keys[i].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          alignment: 0.05);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const AppTopBar(
            title: 'Sejarah',
            subtitle: 'Garis waktu warisan keramik Dinoyo',
            trailing: ShareButton(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  _timelineIntro(),
                  _eraChips(),
                  _timeline(),
                  const WorkshopCta(
                    description:
                        'Hubungi pengrajin untuk info kunjungan, workshop, dan pemesanan khusus. Kami menghubungkan pengunjung dengan cerita, pengrajin, dan karya asli Dinoyo melalui pengalaman digital yang jelas, rapi, dan mudah diakses.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PillChip('Sentra budaya & kerajinan Dinoyo'),
            const SizedBox(height: 12),
            Text('Jejak Sejarah Keramik Dinoyo',
                style: AppText.h2.copyWith(fontSize: 26)),
            const SizedBox(height: 10),
            Text(
              'Menyusuri narasi budaya dari gerabah sederhana hingga sentra porselen bersejarah - sebuah perjalanan warisan yang terus hidup melalui pengrajin, motif, dan teknik pembuatan keramik Dinoyo.',
              style: AppText.body13,
            ),
            const SizedBox(height: 14),
            const ImagePlaceholder(
              label: '[ Foto Hero / Banner - Kampung Wisata Keramik Dinoyo ]',
              height: 190,
              radius: 20,
            ),
          ],
        ),
      );

  Widget _timelineIntro() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Garis Waktu Warisan', style: AppText.h3),
            const SizedBox(height: 8),
            Text(
              'Ikuti perjalanan Kampung Wisata Keramik Dinoyo dari awal produksi gerabah hingga berkembang menjadi sentra wisata edukasi dan direktori pengrajin keramik yang hidup.',
              style: AppText.body13,
            ),
          ],
        ),
      );

  Widget _eraChips() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: Row(
          children: gapped([
            for (var i = 0; i < historyEras.length; i++)
              FilterPill(
                label: historyEras[i].chip,
                selected: i == _selected,
                onTap: () => _select(i),
              ),
          ], 8, horizontal: true),
        ),
      );

  Widget _timeline() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          for (var i = 0; i < historyEras.length; i++)
            IntrinsicHeight(
              key: _keys[i],
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
                        if (i < historyEras.length - 1)
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
                          bottom: i < historyEras.length - 1 ? 18 : 0),
                      child: _eraCard(i),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _eraCard(int i) {
    final era = historyEras[i];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: i == _selected ? AppColors.primary : AppColors.border,
        ),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PillChip(era.label),
          const SizedBox(height: 10),
          Text(era.title,
              style: AppText.inter(size: 16, weight: FontWeight.w700, height: 1.3)),
          const SizedBox(height: 6),
          Text(era.description, style: AppText.body13),
          const SizedBox(height: 12),
          ImagePlaceholder(label: era.imageLabel, height: 130, radius: 14),
        ],
      ),
    );
  }
}
