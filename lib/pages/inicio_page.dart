import 'package:flutter/material.dart';
import '../services/treino_service.dart'; // Importa o serviço que busca os treinos

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  // 1. Instância do nosso serviço de treino
  final TreinoService _treinoService = TreinoService();

  // 2. Variável para armazenar o futuro (a requisição) dos treinos
  late Future<List<dynamic>> _treinosFuture;

  @override
  void initState() {
    super.initState();
    // 3. Inicia a busca pelos treinos assim que a tela é carregada
    _loadTreinos();
  }

  // 4. Método para carregar (ou recarregar) os treinos
  void _loadTreinos() {
    setState(() {
      _treinosFuture = _treinoService.getHistoricoTreinos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 5. AppBar (Barra Superior)
      appBar: AppBar(
        title: Text(
          'FIT TRACKER PRO', // Substituído "Washers"
          style: TextStyle(
            color: Colors.blue[400], // Cor do Figma
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

      // 6. FutureBuilder: Constrói a UI baseada no estado da requisição
      body: FutureBuilder<List<dynamic>>(
        future: _treinosFuture, // O que ele deve "esperar"
        builder: (context, snapshot) {

          // 7. CASO: Carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 8. CASO: Erro
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar treinos: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          // 9. CASO: Sucesso (Dados Recebidos)
          else if (snapshot.hasData) {
            final treinos = snapshot.data!;

            // 10. CASO: Sucesso, mas lista vazia
            if (treinos.isEmpty) {
              return Center(
                child: Text(
                  'Nenhum treino registrado ainda.',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              );
            }

            // 11. CASO: Sucesso e lista com dados!
            // Exibe a lista de treinos (usando ListView.builder para performance)
            return ListView.builder(
              itemCount: treinos.length,
              itemBuilder: (context, index) {
                final treino = treinos[index];
                // TODO: Mapear 'treino' (que é um Map<String, dynamic>) para um objeto Treino
                // e construir o card bonito do Figma.

                // --- Placeholder Simples (Card de Exemplo) ---
                return Card(
                  color: Colors.grey[850],
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          treino['nomeRotina'] ?? 'Treino Matinal', // Nome da Rotina
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          // Formata a data (ex: 2025-10-19T12:30:00 -> 19/10/2025)
                          // Precisaria de um pacote (como 'intl') para formatar melhor
                          'Data: ${treino['dataTreino']?.split('T')[0] ?? ''}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Duração: ${treino['duracaoMin'] ?? 'N/A'} min',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 12),
                        // TODO: Iterar sobre treino['exercicios'] para mostrar a tabela
                        //
                      ],
                    ),
                  ),
                );
                // --- Fim do Placeholder ---
              },
            );
          }

          // 12. CASO: Estado desconhecido
          else {
            return Center(child: Text('Iniciando...', style: TextStyle(color: Colors.white)));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadTreinos, // Botão de recarregar (temporário)
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}