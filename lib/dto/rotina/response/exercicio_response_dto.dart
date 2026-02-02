class ExercicioResponseDTO {
  final int? id;
  final String nomeExercicio;
  final int series;
  final String repeticoes;
  final double cargaTotalKg;
  final String observacoesEx;

  ExercicioResponseDTO({
    this.id,
    required this.nomeExercicio,
    required this.series,
    required this.repeticoes,
    required this.cargaTotalKg,
    required this.observacoesEx,
  });

  factory ExercicioResponseDTO.fromJson(Map<String, dynamic> json) {
    return ExercicioResponseDTO(
      id: json['id'],
      nomeExercicio: json['nomeExercicio'] ?? '',
      series: json['series'] ?? 0,
      repeticoes: json['repeticoes'] ?? '',
      cargaTotalKg: (json['cargaTotalKg'] as num?)?.toDouble() ?? 0.0,
      observacoesEx: json['observacoesEx'] ?? '',
    );
  }

  // ESTE MÉTODO É A PEÇA QUE FALTA:
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeExercicio': nomeExercicio,
      'series': series,
      'repeticoes': repeticoes,
      'cargaTotalKg': cargaTotalKg,
      'observacoesEx': observacoesEx,
    };
  }
}