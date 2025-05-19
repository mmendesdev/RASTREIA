import 'package:flutter/material.dart';
import 'package:stolen_items_app/presentation/screens/auth/login_screen.dart';
import 'package:stolen_items_app/presentation/screens/auth/register_screen.dart';
import 'package:stolen_items_app/presentation/screens/home/home_screen.dart';
import 'package:stolen_items_app/presentation/screens/items/item_list_screen.dart';
import 'package:stolen_items_app/presentation/screens/items/item_detail_screen.dart';
import 'package:stolen_items_app/presentation/screens/items/item_form_screen.dart';
import 'package:stolen_items_app/presentation/screens/settings/settings_screen.dart';

/// Classe que define as rotas do aplicativo
class AppRoutes {
  // Constantes para as rotas nomeadas
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String itemList = '/items';
  static const String itemDetail = '/items/detail';
  static const String itemForm = '/items/form';
  static const String settings = '/settings';
  
  // Mapa de rotas para o MaterialApp
  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    itemList: (context) => const ItemListScreen(),
    itemDetail: (context) => const ItemDetailScreen(),
    itemForm: (context) => const ItemFormScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
