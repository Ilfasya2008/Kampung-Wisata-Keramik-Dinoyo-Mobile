import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/launcher.dart';
import '../../../../widgets/common.dart';
import '../../../../widgets/form_fields.dart';
import '../../domain/entities/user.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  final AuthViewModel authViewModel;
  const RegisterScreen({super.key, required this.authViewModel});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  UserRole _selectedRole = UserRole.visitor;
  bool _showPassword = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_password.text.trim() != _confirmPassword.text.trim()) {
      showToast(context, 'Konfirmasi kata sandi tidak cocok.');
      return;
    }

    final success = await widget.authViewModel.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text.trim(),
      role: _selectedRole,
      phone: _phone.text.trim(),
    );

    if (success && mounted) {
      showToast(context, 'Pendaftaran berhasil! Selamat datang.');
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else if (mounted && widget.authViewModel.errorMessage != null) {
      showToast(context, widget.authViewModel.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Daftar Akun Baru', style: AppText.h3),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: SquareIconButton(
          icon: Icons.arrow_back,
          tooltip: 'Kembali',
          background: Colors.transparent,
          bordered: false,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.authViewModel,
        builder: (context, child) {
          final vm = widget.authViewModel;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PillChip('Registrasi Pengguna Baru'),
                  const SizedBox(height: 10),
                  Text('Buat Akun Anda', style: AppText.h2),
                  const SizedBox(height: 6),
                  Text(
                    'Bergabunglah bersama komunitas Kampung Wisata Keramik Dinoyo.',
                    style: AppText.body13,
                  ),
                  const SizedBox(height: 20),

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
                          const Icon(Icons.error_outline,
                              size: 18, color: AppColors.brick),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              vm.errorMessage!,
                              style:
                                  AppText.inter(size: 12, color: AppColors.brick),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const FieldLabel('Mendaftar sebagai'),
                  Row(
                    children: [
                      Expanded(
                        child: _roleOption(
                          UserRole.visitor,
                          Icons.person_outline,
                          'Wisatawan',
                          'Eksplorasi & simpan karya',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _roleOption(
                          UserRole.artisan,
                          Icons.storefront_outlined,
                          'Pengrajin',
                          'Kelola galeri toko',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama lengkap',
                    icon: Icons.person_outline,
                    controller: _name,
                    required: true,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Alamat Email',
                    hint: 'nama@email.com',
                    icon: Icons.mail_outline,
                    controller: _email,
                    required: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Nomor WhatsApp / HP',
                    hint: '08xxxxxxxxxx',
                    icon: Icons.phone_outlined,
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Kata Sandi',
                    hint: 'Minimal 6 karakter',
                    icon: Icons.lock_outline,
                    controller: _password,
                    required: true,
                    obscure: !_showPassword,
                    suffix: TextButton(
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
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
                  const SizedBox(height: 16),

                  AppTextField(
                    label: 'Konfirmasi Kata Sandi',
                    hint: 'Ulangi kata sandi Anda',
                    icon: Icons.lock_reset_outlined,
                    controller: _confirmPassword,
                    required: true,
                    obscure: !_showPassword,
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    label: vm.isLoading ? 'Mendaftarkan...' : 'Daftar Sekarang',
                    fontSize: 14,
                    minHeight: 52,
                    onPressed: vm.isLoading ? null : _submit,
                  ),
                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Sudah punya akun? ', style: AppText.body13),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'Masuk di sini',
                          style: AppText.inter(
                            size: 13,
                            weight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _roleOption(
      UserRole role, IconData icon, String title, String subtitle) {
    final selected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
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
