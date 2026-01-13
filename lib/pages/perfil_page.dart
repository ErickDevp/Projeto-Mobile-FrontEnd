import 'package:flutter/material.dart';
import '../services/treino_service.dart';
import '../dto/treino_response_dto.dart';
import 'ver_treino_page.dart'; // Importante para o botão "Ver Treino" funcionar

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final TreinoService _service = TreinoService();
  List<TreinoResponseDTO> _meusTreinos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarHistorico();
  }

  void _buscarHistorico() async {
    try {
      final lista = await _service.getHistoricoTreinos();
      setState(() {
        _meusTreinos = lista.reversed.toList(); // Mais recentes no topo
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      print("Erro ao buscar treinos: $e");
    }
  }

  // --- FUNÇÕES DE EXCLUSÃO (Novas) ---

  void _deletarTreino(int id) async {
    bool sucesso = await _service.deletarTreino(id);
    if (sucesso) {
      _buscarHistorico(); // Atualiza a lista
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
              Navigator.pop(ctx); // Fecha o alerta
              _deletarTreino(id); // Chama a exclusão
            },
          ),
        ],
      ),
    );
  }

  // --- FIM DAS FUNÇÕES ---

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
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF202020),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.grey),
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
                          const Text("Erick Santana", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatItem(valor: "${_meusTreinos.length}", label: "Treinos"),
                          const _StatItem(valor: "2 Dias", label: "Dias Ativo"),
                          const _StatItem(valor: "Hipertrofia", label: "Objetivo"),
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
              const CircleAvatar(radius: 20, backgroundColor: Colors.white),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Erick Santana", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(treino.dataCriacao.split('T')[0], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Spacer(),

              // MENU DE OPÇÕES (3 PONTINHOS)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                color: const Color(0xFF424242),
                onSelected: (opcao) {
                  if (opcao == 'ver') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerTreinoPage(treino: treino),
                      ),
                    );
                  } else if (opcao == 'editar') {
                    // Futuro: Editar
                  } else if (opcao == 'excluir') {
                    _confirmarExclusao(treino.id); // <--- AQUI CHAMA A EXCLUSÃO
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'ver',
                    child: Text('Ver Treino', style: TextStyle(color: Colors.white)),
                  ),
                  const PopupMenuItem<String>(
                    value: 'editar',
                    child: Text('Editar', style: TextStyle(color: Colors.white)),
                  ),
                  const PopupMenuItem<String>(
                    value: 'excluir',
                    child: Text('Excluir', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(treino.nomeRotina, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          const Row(
            children: [
              Expanded(flex: 4, child: Text("Nome", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text("Peso", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text("Reps", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text("Series", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            ],
          ),
          const Divider(color: Colors.grey),

          ...treino.exercicios.map((exercicio) {
            return _linhaExercicio(
              exercicio.nomeExercicio,
              "${exercicio.cargaTotalKg} kg",
              exercicio.repeticoes,
              "${exercicio.series}",
            );
          }).toList(),
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