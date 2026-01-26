import 'package:flutter/material.dart';
import '../dto/treino_response_dto.dart';
import '../dto/exercicio_response_dto.dart';

class VerTreinoPage extends StatelessWidget {
  final TreinoResponseDTO treino;

  const VerTreinoPage({Key? key, required this.treino}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Ver Treino", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do Treino
            Center(
              child: Text(
                treino.nomeRotina,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Observação Geral (Só mostra se tiver texto)
            if (treino.observacoes.isNotEmpty) ...[
              const Text("Observação", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              Text(
                treino.observacoes,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              const SizedBox(height: 20),
            ],

            const Divider(color: Colors.grey),
            const SizedBox(height: 10),

            // Linha de Duração e Intensidade
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoDestaque("Duração", "${treino.duracaoMin} Min"),
                _infoDestaque("Intensidade", "${treino.intensidadeGeral}/10"),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20),

            // Título da Lista
            const Center(
              child: Text("Exercícios", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 15),

            // Gera a lista de exercícios
            ...treino.exercicios.map((ex) => _itemExercicioDetalhado(ex)).toList(),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para mostrar Duração/Intensidade
  Widget _infoDestaque(String label, String valor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(color: Colors.white70, fontSize: 16)),
      ],
    );
  }

  // Widget que desenha cada cartão de exercício na lista
  Widget _itemExercicioDetalhado(ExercicioResponseDTO ex) {
    bool temObservacao = ex.observacoesEx.isNotEmpty && ex.observacoesEx != 'null';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF424242),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cabeçalho da Tabela (Nome, Peso, Reps, Series)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _colunaTexto("Nome", ex.nomeExercicio, align: CrossAxisAlignment.start)),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: _colunaTexto("Peso", "${ex.cargaTotalKg} kg")),
              Expanded(flex: 2, child: _colunaTexto("Reps", ex.repeticoes)),
              Expanded(flex: 1, child: _colunaTexto("Series", "${ex.series}")),
            ],
          ),

          // 2. Observação do Exercício (Aparece logo abaixo se existir)
          if (temObservacao) ...[
            const SizedBox(height: 12),
            Text(
              ex.observacoesEx,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget auxiliar para as colunas de texto (CORRIGIDO: Agora está dentro da classe)
  Widget _colunaTexto(String label, String valor, {CrossAxisAlignment align = CrossAxisAlignment.center}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}