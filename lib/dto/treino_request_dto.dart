// lib/models/treino_request_dto.dart
import 'exercicio_request_dto.dart';

class TreinoRequestDTO {
  String nomeRotina;
  int? duracaoMin;
  int? intensidadeGeral;
  String? observacoes;
  List<ExercicioRequestDTO> exercicios;

  TreinoRequestDTO({
    required this.nomeRotina,
    this.duracaoMin,
    this.intensidadeGeral,
    this.observacoes,
    required this.exercicios,
  });

  // Converte o objeto Dart (e sua lista) para um Mapa
  Map<String, dynamic> toJson() {
    return {
      'nomeRotina': nomeRotina,
      'duracaoMin': duracaoMin,
      'intensidadeGeral': intensidadeGeral,
      'observacoes': observacoes,
      // Mapeia a lista de objetos Exercicio para uma lista de Mapas
      'exercicios': exercicios.map((ex) => ex.toJson()).toList(),
    };
  }
}