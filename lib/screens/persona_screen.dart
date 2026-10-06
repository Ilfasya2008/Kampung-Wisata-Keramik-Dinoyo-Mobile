import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// Screen 05 - User Persona.
/// Put the persona photo at assets/images/persona_robbi.jpg (optional; a
/// placeholder is shown when the file is missing).
class PersonaScreen extends StatelessWidget {
  const PersonaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppTopBar(
              title: 'User Persona',
              subtitle:
                  'Kampung Wisata Keramik Dinoyo — Portofolio & Direktori Budaya',
              showBack: true,
              trailing: ShareButton(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  children: [
                    _photo(),
                    const SizedBox(height: 16),
                    Text('Robbi Pantduro', style: AppText.h2),
                    const SizedBox(height: 8),
                    const PillChip(
                      'Mahasiswa / Wisatawan Domestik',
                      fontSize: 12,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    const SizedBox(height: 20),
                    _infoGrid(),
                    const SizedBox(height: 16),
                    _quote(),
                    const SizedBox(height: 16),
                    _textCard(
                      Icons.description_outlined,
                      'Deskripsi Singkat',
                      'Robbi adalah mahasiswa yang sering diajak dosen ikut kegiatan field trip budaya, dan juga suka jalan-jalan akhir pekan ke tempat bersejarah bersama teman. Ia tertarik pada cerita di balik sebuah produk atau tempat, bukan sekadar datang untuk foto-foto.',
                    ),
                    const SizedBox(height: 16),
                    _listCard(
                      Icons.track_changes,
                      'Tujuan (Goals)',
                      const [
                        'Mengetahui sejarah & filosofi desain keramik Dinoyo sebelum berkunjung',
                        'Menemukan toko/pengrajin yang sesuai untuk tugas kuliah atau oleh-oleh',
                        'Menghubungi pengrajin dengan mudah tanpa proses ribet',
                      ],
                      Icons.check_circle_outline,
                      AppColors.sage,
                    ),
                    const SizedBox(height: 16),
                    _listCard(
                      Icons.warning_amber_rounded,
                      'Frustrasi (Pain Points)',
                      const [
                        'Sulit menemukan info sejarah kampung keramik secara online sebelum datang',
                        'Akses jalan sempit & susah parkir bus rombongan saat kunjungan langsung',
                        'Tidak tahu toko mana yang sesuai kebutuhan karena minim info digital pengrajin',
                      ],
                      Icons.error_outline,
                      AppColors.brick,
                    ),
                    const SizedBox(height: 16),
                    _listCard(
                      Icons.star_outline,
                      'Fitur yang Dibutuhkan',
                      const [
                        'Timeline sejarah & warisan budaya interaktif',
                        'Direktori pengrajin & profil toko lengkap dengan lokasi',
                        'Galeri visual katalog karya tiap toko',
                        'Tombol kontak langsung ke WhatsApp pengrajin',
                      ],
                      Icons.star_border,
                      AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photo() {
    return SizedBox(
      width: 180,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/images/persona_robbi.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const ImagePlaceholder(
            label: '[ Foto Persona ]',
            radius: 0,
            icon: Icons.person_outline,
            iconSize: 32,
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.tan,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.inter(size: 11, color: AppColors.muted)),
                Text(value,
                    style: AppText.inter(size: 13, weight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoGrid() {
    return Column(
      children: [
        Row(
          children: gapped([
            Expanded(child: _infoTile(Icons.cake_outlined, 'Usia', '21 tahun')),
            Expanded(
                child: _infoTile(
                    Icons.work_outline, 'Pekerjaan', 'Mahasiswa D3/S1')),
          ], 10, horizontal: true),
        ),
        const SizedBox(height: 10),
        Row(
          children: gapped([
            Expanded(
                child: _infoTile(
                    Icons.place_outlined, 'Lokasi', 'Malang, Jawa Timur')),
            Expanded(
                child: _infoTile(Icons.smartphone, 'Perangkat',
                    'Smartphone (utama)')),
          ], 10, horizontal: true),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: _infoTile(Icons.map_outlined, 'Status',
              'Wisatawan domestik / field trip'),
        ),
      ],
    );
  }

  Widget _quote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.tan,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('“',
              style: AppText.inter(
                  size: 48,
                  weight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.1)),
          Text(
            'Aku pengen tahu sejarah & cerita di balik kerajinan sebelum aku beli atau kunjungi langsung.',
            style: AppText.inter(size: 15, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _cardShell(IconData icon, String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.tan,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: AppText.cardTitle)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _textCard(IconData icon, String title, String body) =>
      _cardShell(icon, title, Text(body, style: AppText.body13));

  Widget _listCard(IconData icon, String title, List<String> items,
      IconData itemIcon, Color itemColor) {
    return _cardShell(
      icon,
      title,
      Column(
        children: gapped([
          for (final t in items)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(itemIcon, size: 18, color: itemColor),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(t, style: AppText.body13)),
              ],
            ),
        ], 10),
      ),
    );
  }
}
