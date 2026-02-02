import '../../rotina/response/dia_response_dto.dart';

class RotinaTemplateTodosResponseDTO {
  final num id;
  final String nome;
  final String descricao;
  final String objetivo;
  final String nivel;
  final List<DiaResponseDTO> dias;

  RotinaTemplateTodosResponseDTO({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.objetivo,
    required this.nivel,
    required this.dias,
  });

  factory RotinaTemplateTodosResponseDTO.fromJson(Map<String, dynamic> json) {
    return RotinaTemplateTodosResponseDTO(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      objetivo: json['objetivo'] ?? '',
      nivel: json['nivel'] ?? '',
      // Mapeia a lista de dias do JSON para a lista de DTOs do Flutter
      dias: (json['dias'] as List?)
          ?.map((d) => DiaResponseDTO.fromJson(d))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'objetivo': objetivo,
      'nivel': nivel,
      'dias': dias.map((d) => d.toJson()).toList(),
    };
  }
}