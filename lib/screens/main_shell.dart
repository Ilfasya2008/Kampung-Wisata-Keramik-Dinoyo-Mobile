import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'directory_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';

/// Tab indexes of the public bottom navigation.
class AppTab {
  static const beranda = 0;
  static const sejarah = 1;
  static const direktori = 2;
  static const tentang = 3;
  static const kontak = 4;
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = AppTab.beranda});
  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  static const _items = [
    NavItem('Beranda', Icons.home_outlined),
    NavItem('Sejarah', Icons.schedule),
    NavItem('Direktori', Icons.storefront_outlined),
    NavItem('Tentang', Icons.info_outline),
    NavItem('Kontak', Icons.phone_outlined),
  ];

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onNavigate: _go),
          const HistoryScreen(),
          const DirectoryScreen(),
          AboutScreen(onNavigate: _go),
          ContactScreen(onNavigate: _go),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        items: _items,
        currentIndex: _index,
        onTap: _go,
      ),
    );
  }
}
