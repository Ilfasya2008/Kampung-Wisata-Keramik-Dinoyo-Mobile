import 'package:flutter/material.dart';

import 'screens/admin_dashboard_screen.dart';
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
    );
  }
}
