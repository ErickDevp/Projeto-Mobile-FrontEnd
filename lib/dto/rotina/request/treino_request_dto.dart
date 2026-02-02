import 'exercicio_request_dto.dart';

class TreinoRequestDTO {
  final String nomeTreino;
  final int duracaoMin;
  final int intensidadeGeral;
  final String observacoes;
  final List<ExercicioRequestDTO> exercicios;

  TreinoRequestDTO({
    required this.nomeTreino,
    required this.duracaoMin,
    required this.intensidadeGeral,
    required this.observacoes,
    required this.exercicios,
  });

  Map<String, dynamic> toJson() => {
    'nomeTreino': nomeTreino,
    'duracaoMin': duracaoMin,
    'intensidadeGeral': intensidadeGeral,
    'observacoes': observacoes,
    'exercicios': exercicios.map((e) => e.toJson()).toList(),
  };
}