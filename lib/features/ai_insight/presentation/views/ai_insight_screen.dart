import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/launcher.dart';
import '../../../../widgets/common.dart';
import '../../domain/entities/ai_insight.dart';
import '../viewmodels/ai_insight_viewmodel.dart';

class AiInsightScreen extends StatefulWidget {
  final AiInsightViewModel viewModel;
  const AiInsightScreen({super.key, required this.viewModel});

  @override
  State<AiInsightScreen> createState() => _AiInsightScreenState();
}

class _AiInsightScreenState extends State<AiInsightScreen> {
  final _queryController = TextEditingController();
  final _apiKeyController = TextEditingController();
  bool _showApiKeyInput = false;
  int _tabIndex = 0; // 0 = Tanya Kurator, 1 = Riwayat Tersimpan

  static const _quickPrompts = [
    'Rekomendasi souvenir pernikahan semi-porselen untuk 300 tamu',
    'Paket workshop edukasi keramik untuk siswa sekolah SMP',
    'Peralatan makan tableware porselen tahan microwave untuk kafe',
    'Vas bunga klasik motif miring khas Dinoyo untuk dekorasi ruang tamu',
  ];

  @override
  void initState() {
    super.initState();
    _apiKeyController.text = widget.viewModel.geminiApiKey;
  }

  @override
  void dispose() {
    _queryController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _submitQuery(String query) async {
    if (query.trim().isEmpty) {
      showToast(context, 'Tulis pertanyaan atau pilih topik di bawah.');
      return;
    }
    _queryController.text = query;
    FocusScope.of(context).unfocus();

    final ok = await widget.viewModel.askCurator(query);
    if (ok && mounted) {
      showToast(context, 'Insight kurator keramik berhasil digenerate & disimpan!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _topBar(),
            _tabSwitch(),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, child) {
                  return _tabIndex == 0 ? _consultationView() : _historyView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: Color(0xB3D7C1A8))),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome,
                size: 20, color: AppColors.background),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Kurator & Insight Budaya',
                    style: AppText.inter(size: 16, weight: FontWeight.w700)),
                Text('Konsultan cerdas karya seni keramik Dinoyo',
                    style: AppText.inter(size: 11, color: AppColors.muted)),
              ],
            ),
          ),
          SquareIconButton(
            icon: Icons.key_outlined,
            tooltip: 'Konfigurasi Gemini API Key',
            onPressed: () =>
                setState(() => _showApiKeyInput = !_showApiKeyInput),
          ),
        ],
      ),
    );
  }

  Widget _tabSwitch() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FilterPill(
              label: 'Konsultasi Baru',
              selected: _tabIndex == 0,
              onTap: () => setState(() => _tabIndex = 0),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FilterPill(
              label: 'Riwayat (${widget.viewModel.savedInsights.length})',
              selected: _tabIndex == 1,
              onTap: () => setState(() => _tabIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _consultationView() {
    final vm = widget.viewModel;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showApiKeyInput) _apiKeySection(),
          _promptHero(),
          const SizedBox(height: 16),
          _inputBox(),
          const SizedBox(height: 16),
          Text('Topik Cepat Populer:', style: AppText.cardTitle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in _quickPrompts)
                ActionChip(
                  label: Text(p, style: const TextStyle(fontSize: 11)),
                  backgroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.border),
                  onPressed: () => _submitQuery(p),
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (vm.isLoading) ...[
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text('Kurator AI sedang menganalisis tradisi keramik...',
                      style: AppText.inter(size: 13, weight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Memvalidasi skema JSON & rekomendasi pengrajin.',
                      style: AppText.body12),
                ],
              ),
            ),
          ] else if (vm.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.brick.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.brick),
              ),
              child: Text(vm.errorMessage!,
                  style: AppText.inter(size: 12, color: AppColors.brick)),
            ),
          ] else if (vm.currentInsight != null) ...[
            _insightResultCard(vm.currentInsight!),
          ],
        ],
      ),
    );
  }

  Widget _apiKeySection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.tan,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.vpn_key_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Kunci API Gemini (Opsional)',
                    style: AppText.inter(
                        size: 13, weight: FontWeight.w700, color: AppColors.ink)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Bila tidak diisi, AI akan berjalan menggunakan Local Generative Engine tervalidasi yang siap offline.',
            style: AppText.inter(size: 11, color: AppColors.ink),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _apiKeyController,
                  obscureText: true,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'AIzaSy...',
                    filled: true,
                    fillColor: AppColors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  widget.viewModel.setApiKey(_apiKeyController.text);
                  setState(() => _showApiKeyInput = false);
                  showToast(context, 'Pengaturan API Key disimpan.');
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _promptHero() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.tan,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.psychology_outlined,
                size: 24, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dapatkan Rekomendasi Terkurasi',
                    style: AppText.inter(size: 15, weight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  'Tanyakan kebutuhan keramik Anda: budget, suvenir, dekorasi, hingga paket workshop edukasi keluarga atau sekolah.',
                  style: AppText.body12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _queryController,
            maxLines: 3,
            style: AppText.inter(size: 13),
            decoration: const InputDecoration(
              hintText: 'Tuliskan kebutuhan Anda di sini...',
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                label: 'Kirim ke AI',
                icon: Icons.send,
                expand: false,
                minHeight: 44,
                onPressed: () => _submitQuery(_queryController.text),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _insightResultCard(AiInsight insight) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary, width: 1.5),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, size: 20, color: AppColors.primary),
              const SizedBox(width: 6),
              Text('Hasil Insight Kurator Terverifikasi',
                  style: AppText.inter(
                      size: 13,
                      weight: FontWeight.w700,
                      color: AppColors.primary)),
              const Spacer(),
              PillChip(insight.category),
            ],
          ),
          const SizedBox(height: 12),
          Text(insight.title,
              style: AppText.inter(
                  size: 18, weight: FontWeight.w700, height: 1.3)),
          const SizedBox(height: 12),

          _insightSection(
            Icons.palette_outlined,
            'Rekomendasi Karya Keramik',
            insight.ceramicRecommendation,
          ),
          const SizedBox(height: 12),

          _insightSection(
            Icons.menu_book_outlined,
            'Nilai Historis & Makna Budaya Dinoyo',
            insight.culturalSignificance,
          ),
          const SizedBox(height: 12),

          _insightSection(
            Icons.monetization_on_outlined,
            'Estimasi Budget',
            insight.estimatedBudget,
          ),
          const SizedBox(height: 12),

          _insightSection(
            Icons.cleaning_services_outlined,
            'Tips Perawatan',
            insight.careTips,
          ),
          const SizedBox(height: 14),

          Text('Toko / Sanggar yang Direkomendasikan:',
              style: AppText.inter(size: 12, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final shopName in insight.recommendedShops)
                ActionChip(
                  avatar: const Icon(Icons.storefront, size: 14),
                  label: Text(shopName, style: const TextStyle(fontSize: 11)),
                  backgroundColor: AppColors.tan,
                  onPressed: () => openWhatsApp(
                    context,
                    message:
                        'Halo $shopName, saya melihat rekomendasi dari AI Kurator Dinoyo untuk ${insight.title}.',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          Text('Poin Kunci (Summary):',
              style: AppText.inter(size: 12, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          for (final point in insight.keyPoints)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(point, style: AppText.body12)),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // JSON Inspector (Bukti validasi & penyimpanan JSON sesuai Poin 6)
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text('Lihat Keluaran JSON Tervalidasi',
                  style: AppText.inter(
                      size: 11,
                      weight: FontWeight.w600,
                      color: AppColors.muted)),
              leading: const Icon(Icons.data_object, size: 16),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    insight.rawJson,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: Color(0xFF81C784),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightSection(IconData icon, String title, String body) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title,
                  style: AppText.inter(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.ink)),
            ],
          ),
          const SizedBox(height: 6),
          Text(body, style: AppText.body13),
        ],
      ),
    );
  }

  Widget _historyView() {
    final list = widget.viewModel.savedInsights;
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bookmark_border, size: 48, color: AppColors.muted),
              const SizedBox(height: 12),
              Text('Belum Ada Insight Tersimpan', style: AppText.h3),
              const SizedBox(height: 6),
              Text(
                'Mulai konsultasi pada tab "Konsultasi Baru" untuk mendapatkan insight karya keramik.',
                textAlign: TextAlign.center,
                style: AppText.body13,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PillChip(item.category),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: AppColors.brick),
                    tooltip: 'Hapus insight',
                    onPressed: () => widget.viewModel.removeInsight(item.id),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(item.title, style: AppText.cardTitle),
              const SizedBox(height: 4),
              Text(item.ceramicRecommendation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body12),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.estimatedBudget,
                      style: AppText.inter(
                          size: 12,
                          weight: FontWeight.w700,
                          color: AppColors.primary)),
                  TextButton(
                    onPressed: () {
                      widget.viewModel.selectInsight(item);
                      setState(() => _tabIndex = 0);
                    },
                    child: const Text('Buka Detail'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
