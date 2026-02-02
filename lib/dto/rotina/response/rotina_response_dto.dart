import 'dia_response_dto.dart';

class RotinaResponseDTO {
  final int? id;
  final String nome;
  final String? dataInicio;
  final List<DiaResponseDTO> dias;

  RotinaResponseDTO({
    this.id,
    required this.nome,
    this.dataInicio,
    required this.dias,
  });

  factory RotinaResponseDTO.fromJson(Map<String, dynamic> json) {
    return RotinaResponseDTO(
      id: json['id'],
      nome: json['nome'] ?? '',
      dataInicio: json['dataInicio'],
      dias: (json['dias'] as List? ?? [])
          .map((d) => DiaResponseDTO.fromJson(d))
          .toList(),
    );
  }
}