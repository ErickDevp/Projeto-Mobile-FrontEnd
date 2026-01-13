class ExercicioResponseDTO {
  final String nomeExercicio;
  final double cargaTotalKg;
  final String repeticoes;
  final int series;
  final String observacoesEx; // <--- NOVO: Observação do exercício

  ExercicioResponseDTO({
    required this.nomeExercicio,
    required this.cargaTotalKg,
    required this.repeticoes,
    required this.series,
    required this.observacoesEx,
  });

  factory ExercicioResponseDTO.fromJson(Map<String, dynamic> json) {
    return ExercicioResponseDTO(
      nomeExercicio: json['nomeExercicio']?.toString() ?? 'Sem nome',
      cargaTotalKg: (json['cargaTotalKg'] ?? 0).toDouble(),
      repeticoes: json['repeticoes']?.toString() ?? '0',
      series: json['series'] ?? 0,
      observacoesEx: json['observacoesEx']?.toString() ?? '', // Pega a obs ou vazio
    );
  }
}

class TreinoResponseDTO {
  final int id;
  final String nomeRotina;
  final String dataCriacao;
  final int duracaoMin;       // <--- NOVO
  final int intensidadeGeral; // <--- NOVO
  final String observacoes;   // <--- NOVO: Observação geral do treino
  final List<ExercicioResponseDTO> exercicios;

  TreinoResponseDTO({
    required this.id,
    required this.nomeRotina,
    required this.dataCriacao,
    required this.duracaoMin,
    required this.intensidadeGeral,
    required this.observacoes,
    required this.exercicios,
  });

  factory TreinoResponseDTO.fromJson(Map<String, dynamic> json) {
    var listaExercicios = json['exercicios'] as List? ?? [];

    return TreinoResponseDTO(
      id: json['id'] ?? 0,
      nomeRotina: json['nomeRotina']?.toString() ?? 'Treino Sem Nome',
      dataCriacao: json['criado_em']?.toString() ?? DateTime.now().toString(),
      duracaoMin: json['duracaoMin'] ?? 0,
      intensidadeGeral: json['intensidadeGeral'] ?? 0,
      observacoes: json['observacoes']?.toString() ?? '',
      exercicios: listaExercicios.map((e) => ExercicioResponseDTO.fromJson(e)).toList(),
    );
  }
}