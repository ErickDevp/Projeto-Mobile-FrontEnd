class ExercicioRequestDTO {
  final String nomeExercicio;
  final int series;
  final String repeticoes;
  final double cargaTotalKg;
  final String observacoesEx;

  ExercicioRequestDTO({
    required this.nomeExercicio,
    required this.series,
    required this.repeticoes,
    required this.cargaTotalKg,
    required this.observacoesEx,
  });

  Map<String, dynamic> toJson() {
    return {
      'nomeExercicio': nomeExercicio,
      'series': series,
      'repeticoes': repeticoes,
      'cargaTotalKg': cargaTotalKg,
      'observacoesEx': observacoesEx,
    };
  }
}