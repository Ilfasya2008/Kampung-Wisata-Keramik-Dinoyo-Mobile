import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/launcher.dart';
import '../../../../widgets/common.dart';
import '../../../../widgets/form_fields.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthViewModel authViewModel;
  const LoginScreen({super.key, required this.authViewModel});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;
  bool _remember = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _fillSample(String email, String pass) {
    _email.text = email;
    _password.text = pass;
    setState(() {});
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.authViewModel.login(
      _email.text.trim(),
      _password.text.trim(),
    );

    if (success && mounted) {
      showToast(context, widget.authViewModel.successMessage ?? 'Berhasil masuk.');
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else if (mounted && widget.authViewModel.errorMessage != null) {
      showToast(context, widget.authViewModel.errorMessage!);
    }
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
      backgroundColor: AppColors.background,
      body: ListenableBuilder(
        listenable: widget.authViewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _brandPanel(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: _form(),
                ),
              ],
            ),
          );
        },
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
                'Autentikasi Pengguna & Pengrajin',
                background: Color(0x33FFFFFF),
                foreground: AppColors.background,
              ),
              const SizedBox(height: 12),
              Text('Selamat Datang di Dinoyo Ceramic Portal',
                  style: AppText.inter(
                      size: 24,
                      weight: FontWeight.w700,
                      height: 1.2,
                      color: AppColors.background)),
              const SizedBox(height: 10),
              Text(
                'Masuk untuk mengakses layanan kurasi AI, pengelolaan profil pengrajin, favorit toko, dan pemesanan workshop.',
                style: AppText.inter(size: 13, color: AppColors.tan),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _form() {
    final vm = widget.authViewModel;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Masuk ke Akun Anda', style: AppText.h2),
          const SizedBox(height: 4),
          Text('Gunakan email terdaftar atau akun uji coba di bawah ini.',
              style: AppText.body13),
          const SizedBox(height: 16),

          // Quick fill preset pills for ease of grading/testing
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tan,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.touch_app_outlined,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('Akun Contoh Cepat (Klik untuk isi otomatis):',
                        style: AppText.inter(
                            size: 11,
                            weight: FontWeight.w700,
                            color: AppColors.ink)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ActionChip(
                      label: const Text('Admin', style: TextStyle(fontSize: 11)),
                      backgroundColor: AppColors.white,
                      onPressed: () => _fillSample('admin@dinoyo.id', 'admin123'),
                    ),
                    ActionChip(
                      label: const Text('Pengrajin (Sari)', style: TextStyle(fontSize: 11)),
                      backgroundColor: AppColors.white,
                      onPressed: () => _fillSample('sari@dinoyo.id', 'sari123'),
                    ),
                    ActionChip(
                      label: const Text('Wisatawan (Robbi)', style: TextStyle(fontSize: 11)),
                      backgroundColor: AppColors.white,
                      onPressed: () => _fillSample('robbi@student.ac.id', 'robbi123'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          if (vm.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.brick.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.brick),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, size: 18, color: AppColors.brick),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vm.errorMessage!,
                      style: AppText.inter(size: 12, color: AppColors.brick),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

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
            hint: 'Masukkan minimal 6 karakter',
            icon: Icons.lock_outline,
            controller: _password,
            required: true,
            obscure: !_showPassword,
            suffix: TextButton(
              onPressed: () => setState(() => _showPassword = !_showPassword),
              child: Text(
                _showPassword ? 'Sembunyikan' : 'Tampilkan',
                style: AppText.inter(
                  size: 12,
                  weight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
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
                  context,
                  'Silakan hubungi admin atau daftar akun baru.',
                ),
                child: Text('Lupa kata sandi?',
                    style: AppText.inter(
                        size: 12,
                        weight: FontWeight.w600,
                        color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppButton(
            label: vm.isLoading ? 'Memproses...' : 'Masuk',
            fontSize: 14,
            minHeight: 52,
            onPressed: vm.isLoading ? null : _submit,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Belum memiliki akun? ', style: AppText.body13),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RegisterScreen(authViewModel: widget.authViewModel),
                    ),
                  );
                },
                child: Text(
                  'Daftar Sekarang',
                  style: AppText.inter(
                    size: 13,
                    weight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              onPressed: _backToSite,
              icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.primary),
              label: Text('Kembali ke Beranda',
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
}
