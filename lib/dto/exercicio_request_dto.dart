class ExercicioRequestDTO {
  String nomeExercicio;
  int series;
  String repeticoes;
  double cargaTotalKg;
  String? observacoesEx;

  ExercicioRequestDTO({
    required this.nomeExercicio,
    required this.series,
    required this.repeticoes,
    required this.cargaTotalKg,
    this.observacoesEx,
  });

  // Converte o objeto Dart para um Mapa (para ser usado no jsonEncode)
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