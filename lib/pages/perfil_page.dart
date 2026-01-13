import 'package:flutter/material.dart';
import '../services/treino_service.dart';
import '../services/usuario_service.dart';
import '../dto/treino_response_dto.dart';
import '../dto/usuario_response_dto.dart';
import 'ver_treino_page.dart';
import 'editar_perfil_page.dart'; // <--- Importante: Import da tela de editar

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // Instancia os serviços
  final TreinoService _treinoService = TreinoService();
  final UsuarioService _usuarioService = UsuarioService();

  List<TreinoResponseDTO> _meusTreinos = [];
  UsuarioResponseDTO? _usuario; // Guarda os dados do usuário (Nome, Email, Objetivo)
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  // Busca dados do Usuário + Histórico de Treinos
  void _carregarDados() async {
    setState(() => _carregando = true);

    try {
      final dadosUsuario = await _usuarioService.getMeuPerfil();
      final listaTreinos = await _treinoService.getHistoricoTreinos();

      if (mounted) {
        setState(() {
          _usuario = dadosUsuario;
          _meusTreinos = listaTreinos.reversed.toList(); // Mais recentes primeiro
          _carregando = false;
        });
      }
    } catch (e) {
      print("Erro ao carregar dados: $e");
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  // --- LÓGICA DE EXCLUSÃO (IGUAL AO QUE JÁ TINHA) ---
  void _deletarTreino(int id) async {
    bool sucesso = await _treinoService.deletarTreino(id);
    if (sucesso) {
      _carregarDados(); // Recarrega para atualizar o contador de treinos
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Treino excluído!"), backgroundColor: Colors.redAccent),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao excluir.")),
        );
      }
    }
  }

  void _confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF424242),
        title: const Text("Excluir Treino?", style: TextStyle(color: Colors.white)),
        content: const Text("Essa ação não pode ser desfeita.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text("Cancelar", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text("EXCLUIR", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(ctx);
              _deletarTreino(id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _cabecalhoPerfil(),
          Expanded(
            child: _meusTreinos.isEmpty
                ? const Center(child: Text("Nenhum treino registrado ainda.", style: TextStyle(color: Colors.white)))
                : ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: _meusTreinos.length,
              itemBuilder: (context, index) {
                final treino = _meusTreinos[index];
                return _cardTreinoHistorico(treino);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cabecalhoPerfil() {
    // 1. Defina o endereço do seu backend aqui (igual ao do Service)
    const String baseUrl = "http://192.168.1.17:8080";

    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF202020),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- AQUI COMEÇA A MÁGICA DA FOTO ---
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: _usuario != null && _usuario!.fotoPerfil != null
                    ? NetworkImage("$baseUrl${_usuario!.fotoPerfil}")
                    : null,
                child: _usuario?.fotoPerfil == null
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              _usuario?.nome ?? "Carregando...",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings, color: Colors.white),
                            onPressed: () {
                              if (_usuario != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditarPerfilPage(usuarioAtual: _usuario!),
                                  ),
                                ).then((atualizou) {
                                  if (atualizou == true) {
                                    _carregarDados();
                                  }
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Aqui mantemos a correção do contador de treinos que fizemos antes
                          _StatItem(valor: "${_meusTreinos.length}", label: "Treinos"),
                          _StatItem(valor: "${_usuario?.diasAtivo ?? 0} Dias", label: "Dias Ativo"),
                          _StatItem(valor: _usuario?.objetivo ?? "-", label: "Objetivo"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardTreinoHistorico(TreinoResponseDTO treino) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF424242),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: _usuario?.fotoPerfil != null ? NetworkImage("http://192.168.1.17:8080${_usuario!.fotoPerfil}") : null,
                child: _usuario?.fotoPerfil == null ? const Icon(Icons.person, size: 20, color: Colors.grey) : null,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_usuario?.nome ?? "Usuário", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(treino.dataCriacao.split('T')[0], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                color: const Color(0xFF424242),
                onSelected: (opcao) {
                  if (opcao == 'ver') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VerTreinoPage(treino: treino)));
                  } else if (opcao == 'excluir') {
                    _confirmarExclusao(treino.id);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'ver', child: Text('Ver Treino', style: TextStyle(color: Colors.white))),
                  const PopupMenuItem<String>(value: 'excluir', child: Text('Excluir', style: TextStyle(color: Colors.redAccent))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(treino.nomeRotina, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          // Mostra apenas os 3 primeiros exercícios
          ...treino.exercicios.take(3).map((ex) => _linhaExercicio(ex.nomeExercicio, "${ex.cargaTotalKg} kg", ex.repeticoes, "${ex.series}")).toList(),
          if (treino.exercicios.length > 3)
            const Padding(padding: EdgeInsets.only(top: 8), child: Center(child: Text("...", style: TextStyle(color: Colors.grey)))),
        ],
      ),
    );
  }

  Widget _linhaExercicio(String nome, String peso, String reps, String series) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(nome, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Expanded(flex: 2, child: Text(peso, style: const TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(reps, style: const TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(series, style: const TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String valor;
  final String label;
  const _StatItem({required this.valor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(valor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}