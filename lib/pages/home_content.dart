import 'package:flutter/material.dart';
import 'registrar_treino_page.dart';
import '../services/usuario_service.dart';
import '../dto/usuario_response_dto.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final UsuarioService _usuarioService = UsuarioService();
  UsuarioResponseDTO? _usuario; // Só para pegar a foto

  // URL do seu backend
  final String baseUrl = "http://192.168.1.17:8080";

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    try {
      final dados = await _usuarioService.getMeuPerfil();
      if (mounted) {
        setState(() {
          _usuario = dados;
        });
      }
    } catch (e) {
      print("Erro ao carregar foto na home: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- CABEÇALHO ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FOTO DINÂMICA (Muda conforme o usuário)
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                // Tem foto? Baixa do servidor. Não tem? Null.
                backgroundImage: _usuario?.fotoPerfil != null
                    ? NetworkImage("$baseUrl${_usuario!.fotoPerfil}")
                    : null,
                // Não tem foto? Mostra o ícone cinza.
                child: _usuario?.fotoPerfil == null
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),

              // TÍTULO FIXO (Mantido "Washers")
              const Text(
                  'Washers',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  )
              ),

              // Espaço vazio para equilibrar o Row (opcional, pode manter ou tirar)
              const SizedBox(width: 40),
            ],
          ),
          const SizedBox(height: 40),

          // --- BOTÕES DE AÇÃO (Mantidos iguais) ---

          _botaoAzul(context, titulo: "+ Registrar Treino", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrarTreinoPage()));
          }),

          const SizedBox(height: 16),
          _botaoAzul(context, titulo: "Minhas Rotinas", icone: Icons.list_alt, onTap: () {}),

          const SizedBox(height: 30),
          const Text("Rotinas", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          _botaoAzul(context, titulo: "Criar Rotina", icone: Icons.edit_note, onTap: () {}),

          const SizedBox(height: 16),
          _botaoAzul(context, titulo: "Explorar Rotinas", icone: Icons.search, onTap: () {}),
        ],
      ),
    );
  }

  Widget _botaoAzul(BuildContext context, {required String titulo, required VoidCallback onTap, IconData? icone}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          if (icone != null) ...[Icon(icone, color: Colors.white), const SizedBox(width: 10)],
          Text(titulo, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}