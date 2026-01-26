class ExercicioResponseDTO {
  final int id;
  final String nomeExercicio;
  final double cargaTotalKg;
  final String repeticoes;
  final int series;
  final String observacoesEx;

  ExercicioResponseDTO({
    required this.id,
    required this.nomeExercicio,
    required this.cargaTotalKg,
    required this.repeticoes,
    required this.series,
    required this.observacoesEx,
  });

  factory ExercicioResponseDTO.fromJson(Map<String, dynamic> json) {
    return ExercicioResponseDTO(
      id: json['id'] ?? 0,
      nomeExercicio: json['nomeExercicio'] ?? '',
      cargaTotalKg: (json['cargaTotalKg'] as num? ?? 0).toDouble(),
      repeticoes: json['repeticoes'] ?? '',
      series: json['series'] ?? 0,
      observacoesEx: json['observacoesEx'] ?? '',
    );
  }
}