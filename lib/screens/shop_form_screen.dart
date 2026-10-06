import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';
import '../utils/launcher.dart';
import '../widgets/common.dart';
import '../widgets/form_fields.dart';

/// Screen 10 - Form Tambah/Edit Toko.
/// Pops with the saved [Shop] (or null when cancelled).
class ShopFormScreen extends StatefulWidget {
  const ShopFormScreen({super.key, this.shop});
  final Shop? shop;

  @override
  State<ShopFormScreen> createState() => _ShopFormScreenState();
}

class _ShopFormScreenState extends State<ShopFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.shop?.name);
  late final _specialty = TextEditingController(text: widget.shop?.specialty);
  late final _year = TextEditingController(text: widget.shop?.established);
  late final _location = TextEditingController(text: widget.shop?.addressShort);
  late final _about = TextEditingController(text: widget.shop?.about);
  final _addressDetail = TextEditingController();
  late final _hours = TextEditingController(
      text: widget.shop?.hours ?? '08.00 - 16.00 WIB');
  late final _whatsapp = TextEditingController(text: widget.shop?.whatsapp);

  late String? _category = (widget.shop?.categoryKeys.isNotEmpty ?? false)
      ? widget.shop!.categoryKeys.first
      : null;
  late WorkshopStatus _workshop =
      widget.shop?.workshop ?? WorkshopStatus.tersedia;
  late bool _showInDirectory = widget.shop?.active ?? true;

  bool get _isEdit => widget.shop != null;

  @override
  void dispose() {
    for (final c in [
      _name, _specialty, _year, _location, _about, _addressDetail, _hours, _whatsapp,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      showToast(context, 'Lengkapi kolom yang wajib diisi.');
      return;
    }
    final detail = _addressDetail.text.trim();
    final location = _location.text.trim();
    final categories = <String>{
      ?_category,
      if (_workshop != WorkshopStatus.tidakTersedia) 'Workshop Edukasi',
    }.toList();

    final saved = Shop(
      id: widget.shop?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      specialty: _specialty.text.trim(),
      address: detail.isEmpty ? location : '$location, $detail',
      hours: _hours.text.trim(),
      workshop: _workshop,
      categoryKeys: categories,
      established: _year.text.trim().isEmpty ? null : _year.text.trim(),
      about: _about.text.trim(),
      whatsapp: _whatsapp.text.trim(),
      active: _showInDirectory,
    );
    Navigator.of(context).pop(saved);
  }

  void _pickPhoto() => showToast(
      context, 'Pemilih foto belum dipasang (tambahkan paket image_picker).');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  children: gapped([
                    _note(),
                    _photoSection(),
                    _infoSection(),
                    _workshopSection(),
                  ], 16),
                ),
              ),
            ),
            _actionBar(),
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
          SquareIconButton(
            icon: Icons.arrow_back,
            tooltip: 'Kembali',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEdit ? 'Kelola Toko / Edit Toko' : 'Kelola Toko / Tambah Toko',
                  style: AppText.inter(size: 11, color: AppColors.muted),
                ),
                Text(_isEdit ? 'Edit Toko' : 'Tambah Toko Baru',
                    style: AppText.inter(size: 18, weight: FontWeight.w700)),
              ],
            ),
          ),
          SquareIconButton(
            icon: Icons.more_horiz,
            tooltip: 'Lainnya',
            onPressed: () => showToast(context, 'Menu lainnya belum tersedia.'),
          ),
        ],
      ),
    );
  }

  Widget _note() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.tan,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Form yang sama dipakai untuk Edit Toko. Isi hanya informasi yang sudah terverifikasi.',
                style: AppText.inter(size: 12, color: AppColors.ink),
              ),
            ),
          ],
        ),
      );

  Widget _sectionCard(IconData icon, String title, String step, Widget child) {
    return Container(
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
              Text(step, style: AppText.body12),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _photoSection() {
    return _sectionCard(
      Icons.photo_camera_outlined,
      'Foto Toko',
      '1/3',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _pickPhoto,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.upload_outlined,
                      size: 26, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Text('Unggah Foto Sampul',
                      style: AppText.inter(size: 13, weight: FontWeight.w700)),
                  Text('Rasio 16:9, maks. 5 MB',
                      style: AppText.inter(size: 11, color: AppColors.muted)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.tan,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.storefront_outlined,
                    size: 22, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Avatar / logo toko',
                        style: AppText.inter(size: 13, weight: FontWeight.w700)),
                    Text('Rasio 1:1',
                        style: AppText.inter(size: 11, color: AppColors.muted)),
                  ],
                ),
              ),
              AppButton(
                label: 'Unggah',
                variant: AppButtonVariant.outline,
                expand: false,
                minHeight: 44,
                fontSize: 12,
                onPressed: _pickPhoto,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Galeri Workshop',
              style: AppText.inter(size: 13, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: gapped([
              const Expanded(
                child: ImagePlaceholder(
                    label: '[ Foto ]', height: 90, radius: 14),
              ),
              const Expanded(
                child: ImagePlaceholder(
                    label: '[ Foto ]', height: 90, radius: 14),
              ),
              Expanded(
                child: InkWell(
                  onTap: _pickPhoto,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add, size: 20, color: AppColors.primary),
                        Text('Tambah',
                            style: AppText.inter(
                                size: 11,
                                weight: FontWeight.w600,
                                color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ),
            ], 8, horizontal: true),
          ),
        ],
      ),
    );
  }

  Widget _infoSection() {
    return _sectionCard(
      Icons.storefront_outlined,
      'Informasi Toko',
      '2/3',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: gapped([
          AppTextField(
            label: 'Nama Toko / Pengrajin',
            hint: 'Contoh: Toko Keramik Sari Asih',
            controller: _name,
            required: true,
          ),
          AppTextField(
            label: 'Spesialisasi',
            hint: 'Contoh: Semi-Porselen',
            controller: _specialty,
            required: true,
          ),
          AppDropdownField(
            label: 'Kategori',
            hint: 'Pilih kategori',
            required: true,
            items: kCategories.skip(1).toList(),
            value: _category,
            onChanged: (v) => setState(() => _category = v),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: gapped([
              Expanded(
                child: AppTextField(
                  label: 'Tahun Berdiri',
                  hint: 'Opsional',
                  controller: _year,
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: AppTextField(
                  label: 'Lokasi',
                  hint: 'Jl. MT Haryono IX',
                  controller: _location,
                  required: true,
                ),
              ),
            ], 12, horizontal: true),
          ),
          Text('Tahun berdiri: isi hanya jika sudah terverifikasi.',
              style: AppText.inter(size: 11, color: AppColors.muted)),
          AppTextField(
            label: 'Tentang Toko (About Us)',
            hint:
                'Ceritakan sejarah singkat toko, filosofi karya, dan keahlian khusus pengrajin...',
            controller: _about,
            required: true,
            maxLines: 5,
          ),
          AppTextField(
            label: 'Alamat Spesifik',
            hint: 'Nomor bangunan / patokan lokasi di dalam kampung',
            controller: _addressDetail,
            maxLines: 3,
          ),
        ], 14),
      ),
    );
  }

  Widget _workshopSection() {
    return _sectionCard(
      Icons.groups_outlined,
      'Workshop & Kontak',
      '3/3',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: gapped([
          AppTextField(
            label: 'Jam Operasional',
            hint: '08.00 - 16.00 WIB',
            icon: Icons.schedule,
            controller: _hours,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FieldLabel('Status Workshop'),
              ...gapped([
                for (final s in WorkshopStatus.values) _radioTile(s),
              ], 8),
            ],
          ),
          AppTextField(
            label: 'WhatsApp Toko',
            hint: '08xx-xxxx-xxxx',
            icon: Icons.chat_bubble_outline_rounded,
            controller: _whatsapp,
            required: true,
            keyboardType: TextInputType.phone,
            helper:
                'Nomor ini khusus toko ini, bukan kontak umum kampung. Tombol WhatsApp di profil toko akan mengarah ke nomor ini.',
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tampilkan di direktori',
                          style: AppText.inter(size: 13, weight: FontWeight.w700)),
                      Text('Nonaktifkan untuk menyembunyikan toko',
                          style: AppText.inter(size: 11, color: AppColors.muted)),
                    ],
                  ),
                ),
                Switch(
                  value: _showInDirectory,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => setState(() => _showInDirectory = v),
                ),
              ],
            ),
          ),
        ], 14),
      ),
    );
  }

  Widget _radioTile(WorkshopStatus s) {
    final selected = _workshop == s;
    return InkWell(
      onTap: () => setState(() => _workshop = s),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.tan : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 20,
              color: selected ? AppColors.primary : AppColors.muted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(s.label,
                  style: AppText.inter(size: 13, weight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: AppShadows.bottomBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Row(
            children: [
              AppButton(
                label: 'Batal',
                variant: AppButtonVariant.outline,
                expand: false,
                minHeight: 52,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: 'Simpan Toko',
                  fontSize: 14,
                  minHeight: 52,
                  onPressed: _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
