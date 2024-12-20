import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:menu_app/pages/login_page.dart';

// Inicializa Firebase.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Casino App',
      home: LoginPage(),

    );
  }
}
