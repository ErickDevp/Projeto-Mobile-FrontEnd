class UsuarioResponseDTO {
  final int id;
  final String nome;
  final String email;
  final int totalTreino;
  final int diasAtivo;
  final String objetivo;
  final String? fotoPerfil;

  UsuarioResponseDTO({
    required this.id,
    required this.nome,
    required this.email,
    required this.totalTreino,
    required this.diasAtivo,
    required this.objetivo,
    this.fotoPerfil,
  });

  factory UsuarioResponseDTO.fromJson(Map<String, dynamic> json) {
    return UsuarioResponseDTO(
      id: json['id'] ?? 0,
      nome: json['nome']?.toString() ?? 'Usuário',
      email: json['email']?.toString() ?? '',

      // Aqui está o segredo: chaves idênticas ao Insomnia
      totalTreino: json['totalTreino'] ?? 0,
      diasAtivo: json['diasAtivo'] ?? 0,
      objetivo: json['objetivo']?.toString() ?? 'NÃO DEFINIDO',
      fotoPerfil: json['fotoPerfil'],
    );
  }
}