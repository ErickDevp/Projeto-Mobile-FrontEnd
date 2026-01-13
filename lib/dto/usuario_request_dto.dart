class UsuarioRequestDTO {
  final String nome;
  final String email;
  final String objetivo;

  UsuarioRequestDTO({
    required this.nome,
    required this.email,
    required this.objetivo,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'objetivo': objetivo,
    };
  }
}