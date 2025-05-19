import 'package:flutter/material.dart';
import 'package:stolen_items_app/config/routes/routes.dart';
import 'package:stolen_items_app/config/themes/app_theme.dart';
import 'package:stolen_items_app/presentation/screens/auth/login_screen.dart';

/// Ponto de entrada principal do aplicativo
/// 
/// Define o tema, rotas e configurações globais do aplicativo
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Objetos Roubados',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
      home: const LoginScreen(),
    );
  }
}
