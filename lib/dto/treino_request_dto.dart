import 'exercicio_request_dto.dart';

class TreinoRequestDTO {
  final String nomeRotina;
  final String duracaoEstimada;
  final String intensidade;
  final String observacao;
  final List<ExercicioRequestDTO> exercicios;

  TreinoRequestDTO({
    required this.nomeRotina,
    required this.exercicios,
    this.duracaoEstimada = "0",
    this.intensidade = "1",
    this.observacao = "",
  });

  Map<String, dynamic> toJson() {
    int duracaoInt = int.tryParse(duracaoEstimada.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    int intensidadeInt = int.tryParse(intensidade.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

    return {
      'nomeRotina': nomeRotina,
      'duracaoMin': duracaoInt,
      'intensidadeGeral': intensidadeInt,
      'observacoes': observacao,
      'exercicios': exercicios.map((e) => e.toJson()).toList(),
    };
  }
}