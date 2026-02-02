class ExercicioRequestDTO {
  final int? treinoId;
  final String nomeExercicio;
  final int series;
  final String repeticoes;
  final double cargaTotalKg;
  final String observacoesEx;

  ExercicioRequestDTO({
    this.treinoId,
    required this.nomeExercicio,
    required this.series,
    required this.repeticoes,
    required this.cargaTotalKg,
    required this.observacoesEx,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nomeExercicio': nomeExercicio,
      'series': series,
      'repeticoes': repeticoes,
      'cargaTotalKg': cargaTotalKg,
      'observacoesEx': observacoesEx,
    };

    // Só adiciona o treinoId se ele não for nulo.
    // Isso evita enviar "treinoId: null" para o Java em criações novas.
    if (treinoId != null) {
      data['treinoId'] = treinoId;
    }

    return data;
  }
}