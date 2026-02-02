import 'exercicio_response_dto.dart';

class TreinoResponseDTO {
  final int? id;
  final String nomeTreino;
  final String? dataTreino;
  final int duracaoMin;
  final int intensidadeGeral;
  final String observacoes;
  final List<ExercicioResponseDTO> exercicios;

  TreinoResponseDTO({
    this.id,
    required this.nomeTreino,
    this.dataTreino,
    required this.duracaoMin,
    required this.intensidadeGeral,
    required this.observacoes,
    required this.exercicios,
  });

  factory TreinoResponseDTO.fromJson(Map<String, dynamic> json) {
    return TreinoResponseDTO(
      id: json['id'],
      nomeTreino: json['nomeTreino'] ?? '',
      dataTreino: json['dataTreino'],
      duracaoMin: json['duracaoMin'] ?? 0,
      intensidadeGeral: json['intensidadeGeral'] ?? 0,
      observacoes: json['observacoes'] ?? '',
      exercicios: (json['exercicios'] as List? ?? [])
          .map((e) => ExercicioResponseDTO.fromJson(e))
          .toList(),
    );
  }

  // ADICIONE ESTE MÉTODO:
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeTreino': nomeTreino,
      'dataTreino': dataTreino,
      'duracaoMin': duracaoMin,
      'intensidadeGeral': intensidadeGeral,
      'observacoes': observacoes,
      // Se o ExercicioResponseDTO não tiver toJson, ele dará erro aqui:
      'exercicios': exercicios.map((e) => e.toJson()).toList(),
    };
  }
}