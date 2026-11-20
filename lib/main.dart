import 'package:flutter/material.dart';

import 'data/dummy_data.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/recommendation_screen.dart';
import 'screens/shop_profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/persona_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const DinoyoApp());

/// Routes that have no entry point in the Figma flow (admin + persona).
/// Change [initialRoute] to '/login', '/admin' or '/persona' to preview them.
const String initialRoute = '/';

class DinoyoApp extends StatelessWidget {
  const DinoyoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kampung Wisata Keramik Dinoyo',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: initialRoute,
      routes: {
        '/': (_) => const MainShell(),
        '/login': (_) => const LoginScreen(),
        '/admin': (_) => const AdminDashboardScreen(),
        '/persona': (_) => const PersonaScreen(),
      },
      onGenerateRoute: _generateRoute,
    );
  }
}

/// Route dengan parameter (juga bisa dibuka sebagai deep link di web):
/// * `/rekomendasi?q=kebutuhan` -> layar Rekomendasi Cerdas
/// * `/toko/{id}`               -> Profil Toko
Route<dynamic>? _generateRoute(RouteSettings settings) {
  final uri = Uri.parse(settings.name ?? '/');
  final seg = uri.pathSegments;
  if (seg.length == 1 && seg.first == 'rekomendasi') {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) =>
          RecommendationScreen(initialQuery: uri.queryParameters['q'] ?? ''),
    );
  }
  if (seg.length == 2 && seg.first == 'toko') {
    final match = dummyShops.where((s) => s.id == seg[1]);
    if (match.isEmpty) return null;
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => ShopProfileScreen(shop: match.first),
    );
  }
  return null;
}
