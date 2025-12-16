import 'package:flutter/material.dart';

// TODO: Crie e importe os arquivos das suas telas de aba
import 'inicio_page.dart';
// import 'profile_tab.dart'; // Tela "Perfil"
import 'treino_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 1. Controla qual aba está selecionada. Começa na aba 0 (Perfil).
  int _selectedIndex = 1; // Baseado no seu Figma, parece que "Perfil" é a primeira aba

  // 2. Lista de telas (widgets) que a barra de navegação irá controlar
  // Por enquanto, usaremos placeholders (widgets de texto simples)
  static const List<Widget> _pages = <Widget>[
    // Aba 0: Perfil
    Center(
      child: Text('Tela Perfil', style: TextStyle(color: Colors.white)),
    ),


    InicioPage(),

    TreinoPage(),
  ];

  // 3. Função chamada quando o usuário clica em uma aba
  void _onItemTapped(int index) {
    setState(() { // Atualiza o estado
      _selectedIndex = index; // Define a nova aba selecionada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 4. O corpo da tela muda baseado na aba selecionada
      body: _pages.elementAt(_selectedIndex),

      // 5. A Barra de Navegação Inferior (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Item 0: Perfil
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person), // Ícone quando selecionado
            label: 'Perfil',
          ),

          // Item 1: Início
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),

          // Item 2: Treino
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            activeIcon: Icon(Icons.fitness_center),
            label: 'Treino',
          ),
        ],
        currentIndex: _selectedIndex, // Informa qual item está ativo
        onTap: _onItemTapped, // Função a ser chamada ao tocar

        // Estilização para combinar com o tema escuro
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.blue[400], // Cor do item ativo
        unselectedItemColor: Colors.white70, // Cor dos itens inativos
      ),
    );
  }
}
