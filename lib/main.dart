import 'package:flutter/material.dart';
// 1. Importa a sua nova página de login
import 'pages/login_page.dart';

void main() {
  runApp(const FitTrackerProApp());
}

class FitTrackerProApp extends StatelessWidget {
  const FitTrackerProApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 2. MaterialApp é o widget raiz do seu aplicativo
    return MaterialApp(
      title: 'Fit Tracker Pro', // Título do App
      debugShowCheckedModeBanner: false, // Remove a faixa "Debug" no canto

      // 3. Define o tema escuro para combinar com o Figma
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900], // Fundo padrão das telas
        inputDecorationTheme: InputDecorationTheme( // Estilo padrão dos campos de texto
          filled: true,
          fillColor: Colors.grey[800],
          labelStyle: TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData( // Estilo padrão dos botões
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),

      // 4. Define a LoginPage como a tela inicial (home)
      home: const LoginPage(),
    );
  }
}