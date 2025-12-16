import 'package:flutter/material.dart';
import 'registrar_treino_page.dart';

class TreinoPage extends StatelessWidget {
  const TreinoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar (Barra Superior) - Similar à da InícioPage
      appBar: AppBar(
        title: Text(
          'FIT TRACKER PRO', // Título
          style: TextStyle(
            color: Colors.blue[400],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey[900], // Fundo escuro
        centerTitle: true,
        elevation: 0, // Sem sombra
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              // TODO: Navegar para a Tela de Notificações
            },
          ),
        ],
      ),

      // Corpo da tela com os botões
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Alinha no topo
          crossAxisAlignment: CrossAxisAlignment.stretch, // Estica os botões
          children: [
            const SizedBox(height: 20), // Espaçamento do topo

            // Botão "+ Iniciar Treino"
            ElevatedButton(
              child: Text('Iniciar Treino', style: TextStyle(color: Colors.white, fontSize: 18)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const RegistrarTreinoPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                padding: EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30), // Espaço

            // Título "Rotinas"
            Text(
              'Rotinas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Botão "Criar Rotina"
            OutlinedButton.icon(
              icon: Icon(Icons.edit_outlined, color: Colors.blue[400]),
              label: Text('Criar Rotina', style: TextStyle(color: Colors.blue[400], fontSize: 16)),
              onPressed: () {
                // TODO: Navegar para a tela de criação de rotina
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue[400]!),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botão "Explorar Rotinas"
            OutlinedButton.icon(
              icon: Icon(Icons.search, color: Colors.blue[400]),
              label: Text('Explorar Rotinas', style: TextStyle(color: Colors.blue[400], fontSize: 16)),
              onPressed: () {
                // TODO: Navegar para a tela de explorar rotinas
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue[400]!),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}