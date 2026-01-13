import 'package:flutter/material.dart';
import 'registrar_treino_page.dart'; // Importante para o botão funcionar

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabeçalho personalizado do usuário
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.grey)),
              const Text('Washers', style: TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 40),

          // --- BOTÕES DE AÇÃO ---

          // 1. Registrar Treino (Funcional)
          _botaoAzul(context, titulo: "+ Registrar Treino", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarTreinoPage()));
          }),

          const SizedBox(height: 16),

          // 2. Minhas Rotinas
          _botaoAzul(context, titulo: "Minhas Rotinas", icone: Icons.list_alt, onTap: () {}),

          const SizedBox(height: 30),
          const Text("Rotinas", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // 3. Criar Rotina
          _botaoAzul(context, titulo: "Criar Rotina", icone: Icons.edit_note, onTap: () {}),

          const SizedBox(height: 16),

          // 4. Explorar
          _botaoAzul(context, titulo: "Explorar Rotinas", icone: Icons.search, onTap: () {}),
        ],
      ),
    );
  }

  // A "Fábrica de Botões" para evitar repetição de código
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