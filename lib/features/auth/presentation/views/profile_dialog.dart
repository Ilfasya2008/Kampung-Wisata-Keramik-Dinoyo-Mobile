import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/common.dart';
import '../../domain/entities/user.dart';
import '../viewmodels/auth_viewmodel.dart';

void showUserProfileDialog(BuildContext context, AuthViewModel authViewModel) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _ProfileSheet(authViewModel: authViewModel),
  );
}

class _ProfileSheet extends StatelessWidget {
  final AuthViewModel authViewModel;
  const _ProfileSheet({required this.authViewModel});

  @override
  Widget build(BuildContext context) {
    final user = authViewModel.currentUser;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user != null && user.name.isNotEmpty
                        ? user.name.substring(0, 1).toUpperCase()
                        : '?',
                    style: AppText.inter(
                        size: 24,
                        weight: FontWeight.w700,
                        color: AppColors.background),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'Tamu (Belum Masuk)',
                          style: AppText.inter(
                              size: 18, weight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? 'Silakan masuk untuk fitur lengkap',
                          style: AppText.body12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (user != null) ...[
              Wrap(
                spacing: 8,
                children: [
                  PillChip(
                    user.role.label,
                    icon: Icons.verified_user_outlined,
                  ),
                  if (user.phone.isNotEmpty)
                    PillChip(
                      user.phone,
                      icon: Icons.phone_outlined,
                    ),
                ],
              ),
              const SizedBox(height: 24),
              if (user.isAdmin) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.admin_panel_settings_outlined,
                      color: AppColors.primary),
                  title: Text('Panel Dashboard Admin',
                      style: AppText.inter(size: 14, weight: FontWeight.w600)),
                  subtitle: const Text('Kelola seluruh toko dan pengrajin'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/admin');
                  },
                ),
                const Divider(),
              ],
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: AppColors.brick),
                title: Text('Keluar dari Akun',
                    style: AppText.inter(
                        size: 14,
                        weight: FontWeight.w600,
                        color: AppColors.brick)),
                onTap: () async {
                  Navigator.of(context).pop();
                  await authViewModel.logout();
                },
              ),
            ] else ...[
              const SizedBox(height: 12),
              AppButton(
                label: 'Masuk ke Akun',
                icon: Icons.login,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/login');
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
