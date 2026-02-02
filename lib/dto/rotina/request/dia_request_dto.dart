import 'treino_request_dto.dart';

class DiaRequestDTO {
  final int? id;
  final String dia; // Ex: "SEGUNDA", "TERCA" (conforme seu Enum Java)
  final TreinoRequestDTO treino;

  DiaRequestDTO({this.id, required this.dia, required this.treino});

  Map<String, dynamic> toJson() => {
    'id': id,
    'dia': dia,
    'treino': treino.toJson(),
  };
}