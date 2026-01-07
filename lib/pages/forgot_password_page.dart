import 'package:flutter/material.dart';
import 'package:fit_tracker_pro_app/pages/registrar_treino_page.dart';

// Usamos StatefulWidget porque a tela MUDARÁ (troca de abas)
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // PILAR 1: ESTADO DA NAVEGAÇÃO
  int _indiceAtual = 1; // 0 = Perfil, 1 = Treino (Home)

  // Lista com as telas que vão aparecer no meio
  final List<Widget> _telas = [
    const Center(child: Text("Perfil (Em breve)", style: TextStyle(color: Colors.white))),
    const HomeContent(), // Extraímos o conteúdo para um Widget separado (Organização)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030), // Cor do Figma

      // O Body muda dinamicamente baseado no índice
      body: SafeArea(
        child: _telas[_indiceAtual],
      ),

      // Barra de Navegação Inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual, // Qual ícone pintar de azul?
        onTap: (index) {
          setState(() {
            _indiceAtual = index; // Atualiza o índice e redesenha a tela
          });
        },
        backgroundColor: const Color(0xFF202020),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Treino'),
        ],
      ),
    );
  }
}

// --- Conteúdo da Aba HOME ---
class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PILAR 2: LAYOUT (Column e Padding)
    return Padding(
      padding: const EdgeInsets.all(24.0), // Espaçamento das bordas
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Estica os botões
        children: [
          // Linha do Topo (Avatar + Texto)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.grey)),
              const Text('Washers', style: TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 40), // Gambiarra visual para centralizar o título compensando o avatar
            ],
          ),
          const SizedBox(height: 40),

          // PILAR 3: REUSO DE CÓDIGO (Chamando a "fábrica" de botões)

          // Botão 1: Registrar (Leva para outra tela)
          _botaoAzul(
            context,
            titulo: "+ Registrar Treino",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarTreinoPage()));
            },
          ),

          const SizedBox(height: 16),

          // Botão 2: Apenas um print por enquanto
          _botaoAzul(
            context,
            titulo: "Minhas Rotinas",
            icone: Icons.list_alt,
            onTap: () => print("Minhas Rotinas"),
          ),

          const SizedBox(height: 30),
          const Text("Rotinas", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          _botaoAzul(context, titulo: "Criar Rotina", icone: Icons.edit_note, onTap: () {}),
          const SizedBox(height: 16),
          _botaoAzul(context, titulo: "Explorar Rotinas", icone: Icons.search, onTap: () {}),
        ],
      ),
    );
  }

  // A FÁBRICA DE BOTÕES (Método auxiliar para não repetir código)
  Widget _botaoAzul(BuildContext context, {required String titulo, required VoidCallback onTap, IconData? icone}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        // Se tiver ícone, mostra ele, senão não mostra nada
        children: [
          if (icone != null) ...[Icon(icone, color: Colors.white), const SizedBox(width: 10)],
          Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}