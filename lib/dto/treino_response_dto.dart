import 'exercicio_response_dto.dart';

class TreinoResponseDTO {
  final int id;
  final String nomeRotina;
  final String dataCriacao;
  // Campos novos que o VerTreino precisa
  final String observacoes;
  final int duracaoMin;
  final int intensidadeGeral;

  final List<ExercicioResponseDTO> exercicios;

  TreinoResponseDTO({
    required this.id,
    required this.nomeRotina,
    required this.dataCriacao,
    this.observacoes = '', // Valor padrão se vier nulo
    this.duracaoMin = 0,   // Valor padrão
    this.intensidadeGeral = 0, // Valor padrão
    required this.exercicios,
  });

  factory TreinoResponseDTO.fromJson(Map<String, dynamic> json) {
    var list = json['exercicios'] as List? ?? [];
    List<ExercicioResponseDTO> exerciciosList =
    list.map((i) => ExercicioResponseDTO.fromJson(i)).toList();

    return TreinoResponseDTO(
      id: json['id'] ?? 0,
      nomeRotina: json['nomeRotina'] ?? 'Treino sem nome',
      dataCriacao: json['dataCriacao'] ?? '',
      observacoes: json['observacoes'] ?? '', // Se não vier do back, fica vazio
      duracaoMin: json['duracaoMin'] ?? 0,
      intensidadeGeral: json['intensidadeGeral'] ?? 0,
      exercicios: exerciciosList,
    );
  }
}