import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/launcher.dart';
import '../widgets/common.dart';
import '../widgets/form_fields.dart';

enum LoginRole { admin, artisan }

/// Screen 08 - CRUD Login.
/// NOTE: this is UI only. Replace [_submit] with real authentication.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  LoginRole _role = LoginRole.admin;
  bool _showPassword = false;
  bool _remember = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: authenticate against your backend, using _role / _email / _password.
    Navigator.of(context).pushReplacementNamed('/admin');
  }

  void _backToSite() {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      nav.pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _brandPanel(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: _form(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _brandPanel() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('KD',
                        style: AppText.inter(
                            size: 13,
                            weight: FontWeight.w700,
                            color: AppColors.primary)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Kampung Wisata Keramik Dinoyo',
                        style: AppText.inter(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.background)),
                  ),
                  SquareIconButton(
                    icon: Icons.arrow_back,
                    tooltip: 'Kembali ke situs',
                    background: const Color(0x26FFFFFF),
                    color: AppColors.background,
                    bordered: false,
                    onPressed: _backToSite,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const PillChip(
                'Panel Pengelolaan Data',
                background: Color(0x33FFFFFF),
                foreground: AppColors.background,
              ),
              const SizedBox(height: 12),
              Text('Kelola data toko dan produk pengrajin Dinoyo',
                  style: AppText.inter(
                      size: 24,
                      weight: FontWeight.w700,
                      height: 1.2,
                      color: AppColors.background)),
              const SizedBox(height: 10),
              Text(
                'Perbarui profil toko, katalog produk, dan status workshop agar informasi di direktori selalu akurat.',
                style: AppText.inter(size: 13, color: AppColors.tan),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Masuk ke Panel Pengelolaan', style: AppText.h2),
          const SizedBox(height: 4),
          Text('Khusus admin paguyuban dan pengrajin terdaftar.',
              style: AppText.body13),
          const SizedBox(height: 18),
          const FieldLabel('Masuk sebagai'),
          Row(
            children: gapped([
              Expanded(
                child: _roleOption(
                  LoginRole.admin,
                  Icons.groups_outlined,
                  'Admin Paguyuban',
                  'Kelola seluruh toko, produk & akun',
                ),
              ),
              Expanded(
                child: _roleOption(
                  LoginRole.artisan,
                  Icons.storefront_outlined,
                  'Pengrajin',
                  'Kelola profil, produk & workshop sendiri',
                ),
              ),
            ], 10, horizontal: true),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Email atau Username',
            hint: 'nama@email.com',
            icon: Icons.mail_outline,
            controller: _email,
            required: true,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Kata Sandi',
            hint: 'Masukkan kata sandi',
            icon: Icons.lock_outline,
            controller: _password,
            required: true,
            obscure: !_showPassword,
            suffix: TextButton(
              onPressed: () => setState(() => _showPassword = !_showPassword),
              child: Text(_showPassword ? 'Sembunyikan' : 'Tampilkan',
                  style: AppText.inter(
                      size: 12,
                      weight: FontWeight.w600,
                      color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: () => setState(() => _remember = !_remember),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _remember
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text('Ingat saya', style: AppText.inter(size: 12)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => showToast(
                    context, 'Hubungi admin paguyuban untuk reset kata sandi.'),
                child: Text('Lupa kata sandi?',
                    style: AppText.inter(
                        size: 12,
                        weight: FontWeight.w600,
                        color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppButton(label: 'Masuk', fontSize: 14, minHeight: 52, onPressed: _submit),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Belum punya akun? Akun pengrajin dibuat oleh admin paguyuban. Hubungi Kontak Umum Kampung.',
              textAlign: TextAlign.center,
              style: AppText.inter(size: 12, color: AppColors.muted),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _backToSite,
              icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.primary),
              label: Text('Kembali ke situs',
                  style: AppText.inter(
                      size: 13,
                      weight: FontWeight.w600,
                      color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleOption(
      LoginRole role, IconData icon, String title, String subtitle) {
    final selected = _role == role;
    return InkWell(
      onTap: () => setState(() => _role = role),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.tan : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(title,
                      style: AppText.inter(size: 12, weight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle,
                style: AppText.inter(size: 10, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}
