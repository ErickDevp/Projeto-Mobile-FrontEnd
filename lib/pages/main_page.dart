import 'package:flutter/material.dart';
import 'registrar_treino_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _indiceAtual = 1;

  // Aqui estava o erro: trocamos InicioPage() por HomeContent()
  final List<Widget> _telas = [
    const Center(child: Text("Perfil (Em breve)", style: TextStyle(color: Colors.white))),
    const HomeContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      body: SafeArea(child: _telas[_indiceAtual]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) => setState(() => _indiceAtual = index),
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

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.grey)),
              const Text('Washers', style: TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 40),
            ],
          ),
erick          const SizedBox(height: 40),
          _botaoAzul(context, titulo: "+ Registrar Treino", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarTreinoPage()));
          }),
          const SizedBox(height: 16),
          _botaoAzul(context, titulo: "Minhas Rotinas", icone: Icons.list_alt, onTap: () {}),
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

  Widget _botaoAzul(BuildContext context, {required String titulo, required VoidCallback onTap, IconData? icone}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          if (icone != null) ...[Icon(icone, color: Colors.white), const SizedBox(width: 10)],
          Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}