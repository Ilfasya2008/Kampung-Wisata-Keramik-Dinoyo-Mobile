import 'package:flutter/material.dart';
import 'core/di/injection_container.dart';
import 'features/auth/presentation/views/login_screen.dart';
import 'features/auth/presentation/views/register_screen.dart';
import 'features/shops/presentation/views/admin_dashboard_screen.dart';
import 'screens/main_shell.dart';
import 'screens/persona_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.init();
  runApp(const DinoyoApp());
}

class DinoyoApp extends StatelessWidget {
  const DinoyoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kampung Wisata Keramik Dinoyo',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => MainShell(
              authViewModel: InjectionContainer.authViewModel,
              shopViewModel: InjectionContainer.shopViewModel,
              historyViewModel: InjectionContainer.historyViewModel,
              aiViewModel: InjectionContainer.aiViewModel,
              notificationService: InjectionContainer.notificationService,
            ),
        '/login': (_) => LoginScreen(
              authViewModel: InjectionContainer.authViewModel,
            ),
        '/register': (_) => RegisterScreen(
              authViewModel: InjectionContainer.authViewModel,
            ),
        '/admin': (_) => AdminDashboardScreen(
              shopViewModel: InjectionContainer.shopViewModel,
              authViewModel: InjectionContainer.authViewModel,
            ),
        '/persona': (_) => const PersonaScreen(),
      },
    );
  }
}
