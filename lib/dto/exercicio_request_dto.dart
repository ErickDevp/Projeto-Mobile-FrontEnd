class ExercicioRequestDTO {
  final String nome;
  final String? observacao;
  final int series;
  final int repeticoes;
  final double carga;

  // CORREÇÃO: Adicionamos as chaves {} para aceitar parâmetros nomeados
  ExercicioRequestDTO({
    required this.nome,
    this.observacao,
    required this.series,
    required this.repeticoes,
    required this.carga,
  });

  Map<String, dynamic> toJson() {
    return {
      'nomeExercicio': nome,
      'cargaTotalKg': carga,
      'series': series,
      'repeticoes': repeticoes,
      'observacao': observacao,
    };
  }
}