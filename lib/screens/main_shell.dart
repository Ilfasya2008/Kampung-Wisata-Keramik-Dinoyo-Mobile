import 'package:flutter/material.dart';
import '../core/services/notification_service.dart';
import '../features/ai_insight/presentation/viewmodels/ai_insight_viewmodel.dart';
import '../features/ai_insight/presentation/views/ai_insight_screen.dart';
import '../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../features/history/presentation/viewmodels/history_viewmodel.dart';
import '../features/history/presentation/views/history_screen.dart';
import '../features/shops/presentation/viewmodels/shop_viewmodel.dart';
import '../features/shops/presentation/views/directory_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'home_screen.dart';
import 'persona_screen.dart';

class AppTab {
  static const beranda = 0;
  static const sejarah = 1;
  static const direktori = 2;
  static const aiKurator = 3;
  static const kontak = 4;
}

class MainShell extends StatefulWidget {
  final int initialIndex;
  final AuthViewModel authViewModel;
  final ShopViewModel shopViewModel;
  final HistoryViewModel historyViewModel;
  final AiInsightViewModel aiViewModel;
  final NotificationService notificationService;

  const MainShell({
    super.key,
    this.initialIndex = AppTab.beranda,
    required this.authViewModel,
    required this.shopViewModel,
    required this.historyViewModel,
    required this.aiViewModel,
    required this.notificationService,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  static const _items = [
    NavItem('Beranda', Icons.home_outlined),
    NavItem('Sejarah', Icons.schedule),
    NavItem('Direktori', Icons.storefront_outlined),
    NavItem('AI Kurator', Icons.auto_awesome_outlined),
    NavItem('Kontak & Peta', Icons.place_outlined),
  ];

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _appDrawer(context),
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            onNavigate: _go,
            authViewModel: widget.authViewModel,
            shopViewModel: widget.shopViewModel,
            historyViewModel: widget.historyViewModel,
            aiViewModel: widget.aiViewModel,
            notificationService: widget.notificationService,
          ),
          HistoryScreen(viewModel: widget.historyViewModel),
          DirectoryScreen(viewModel: widget.shopViewModel),
          AiInsightScreen(viewModel: widget.aiViewModel),
          ContactScreen(
            onNavigate: _go,
            notificationService: widget.notificationService,
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        items: _items,
        currentIndex: _index,
        onTap: _go,
      ),
    );
  }

  Widget _appDrawer(BuildContext context) {
    final user = widget.authViewModel.currentUser;
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.background,
                    child: Text(
                      user != null && user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : 'KD',
                      style: AppText.inter(
                          size: 18,
                          weight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user != null ? user.name : 'Kampung Keramik Dinoyo',
                    style: AppText.inter(
                        size: 16,
                        weight: FontWeight.w700,
                        color: AppColors.background),
                  ),
                  Text(
                    user != null ? user.email : 'Portofolio & Direktori Budaya',
                    style: AppText.inter(size: 11, color: AppColors.tan),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppColors.primary),
                    title: const Text('Tentang Paguyuban'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AboutScreen(onNavigate: _go),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.person_pin_outlined, color: AppColors.primary),
                    title: const Text('User Persona (Robbi)'),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PersonaScreen(),
                        ),
                      );
                    },
                  ),
                  if (user != null && user.isAdmin)
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings_outlined,
                          color: AppColors.primary),
                      title: const Text('Panel Admin Paguyuban'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/admin');
                      },
                    ),
                  const Divider(),
                  if (user != null)
                    ListTile(
                      leading: const Icon(Icons.logout, color: AppColors.brick),
                      title: const Text('Keluar dari Akun',
                          style: TextStyle(color: AppColors.brick)),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await widget.authViewModel.logout();
                      },
                    )
                  else
                    ListTile(
                      leading: const Icon(Icons.login, color: AppColors.primary),
                      title: const Text('Masuk ke Akun'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed('/login');
                      },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Versi 1.0.0 • Clean Architecture & MVVM',
                style: AppText.inter(size: 11, color: AppColors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
