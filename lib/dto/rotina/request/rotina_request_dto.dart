import 'dia_request_dto.dart';

class RotinaRequestDTO {
  final String nome;
  final String descricao;
  final String dataInicio; // LocalDate vira String no JSON (ISO 8601: "yyyy-MM-dd")
  final List<DiaRequestDTO> dias;

  RotinaRequestDTO({
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    required this.dias,
  });

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'descricao': descricao,
    'dataInicio': dataInicio,
    'dias': dias.map((d) => d.toJson()).toList(),
  };
}