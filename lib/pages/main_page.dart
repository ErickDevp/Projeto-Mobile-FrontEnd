import 'package:flutter/material.dart';
import 'home_content.dart'; // Importa a aba de Ações (Treino)
import 'perfil_page.dart';  // Importa a aba de Histórico (Perfil)

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _indiceAtual = 0; // Começa na aba 0 (Perfil)

  // Lista das telas que o App vai alternar
  final List<Widget> _telas = [
    const PerfilPage(),   // Índice 0: Tela de Perfil/Histórico (Feed)
    const HomeContent(),  // Índice 1: Tela de Botões/Ações (Treino)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      body: SafeArea(
        child: _telas[_indiceAtual], // Mostra a tela baseada no índice clicado
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) => setState(() => _indiceAtual = index),
        backgroundColor: const Color(0xFF202020),
        selectedItemColor: Colors.blueAccent, // Ou White, como preferir
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Treino'),
        ],
      ),
    );
  }
}