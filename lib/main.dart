import 'package:flutter/material.dart';
import 'package:stolen_items_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stolen_items_app/config/firebase_options.dart';

/// Ponto de entrada do aplicativo
void main() async {
  // Garante que o Flutter esteja inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Inicia o aplicativo
  runApp(const App());
}
