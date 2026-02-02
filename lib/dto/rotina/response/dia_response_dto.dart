import 'treino_response_dto.dart';

class DiaResponseDTO {
  final int? id;
  final String dia;
  final TreinoResponseDTO? treino;

  DiaResponseDTO({this.id, required this.dia, this.treino});

  factory DiaResponseDTO.fromJson(Map<String, dynamic> json) {
    return DiaResponseDTO(
      id: json['id'],
      dia: json['dia'] ?? '',
      treino: json['treino'] != null
          ? TreinoResponseDTO.fromJson(json['treino'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dia': dia,
      'treino': treino?.toJson(),
    };
  }
}