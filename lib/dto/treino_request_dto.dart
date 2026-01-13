import 'exercicio_request_dto.dart';

class TreinoRequestDTO {
  final String nome;
  final String duracaoEstimada;
  final String intensidade;
  final String observacao;
  final List<ExercicioRequestDTO> exercicios;

  TreinoRequestDTO({
    required this.nome,
    required this.duracaoEstimada,
    required this.intensidade,
    required this.observacao,
    required this.exercicios,
  });

  Map<String, dynamic> toJson() {

    int duracaoInt = int.tryParse(duracaoEstimada.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // ATENÇÃO: Seu backend espera um NÚMERO para intensidade.
    // Por enquanto, vou tentar ler um número. Se escrever texto ("Alta"), vai enviar 1.
    int intensidadeInt = int.tryParse(intensidade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

    return {
      // TRADUÇÃO PARA O JAVA:
      'nomeRotina': nome,              // Java: nomeRotina
      'duracaoMin': duracaoInt,        // Java: duracaoMin (Integer)
      'intensidadeGeral': intensidadeInt, // Java: intensidadeGeral (Integer)
      'observacoes': observacao,       // Java: observacoes (Plural)

      'exercicios': exercicios.map((e) => e.toJson()).toList(),
    };
  }
}