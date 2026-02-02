import 'package:flutter/material.dart';
import '../../services/rotina_service.dart';
import '../../dto/rotina/response/rotina_response_dto.dart';

class MinhasRotinasPage extends StatefulWidget {
  const MinhasRotinasPage({super.key});

  @override
  State<MinhasRotinasPage> createState() => _MinhasRotinasPageState();
}

class _MinhasRotinasPageState extends State<MinhasRotinasPage> {
  final RotinaService _rotinaService = RotinaService();
  late Future<List<RotinaResponseDTO>> _rotinasFuture;

  @override
  void initState() {
    super.initState();
    _carregarRotinas();
  }

  void _carregarRotinas() {
    setState(() {
      _rotinasFuture = _rotinaService.listarRotinas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Minhas Rotinas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<RotinaResponseDTO>>(
        future: _rotinasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar rotinas", style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma rotina encontrada", style: TextStyle(color: Colors.white54)));
          }

          final rotinas = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rotinas.length,
            itemBuilder: (context, index) {
              return _buildRotinaCard(rotinas[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildRotinaCard(RotinaResponseDTO rotina) {
    // AJUSTE: Mudei para d.dia para resolver o erro do seu print 2
    // Se o seu DTO usa outro nome, verifique o arquivo DiaResponseDTO
    String diasFormatados = rotina.dias.map((d) => d.dia).join("   ");

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Nome", style: TextStyle(color: Colors.grey, fontSize: 11)),
              Text("Data", style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  rotina.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                rotina.dataInicio ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Dias", style: TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  diasFormatados,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              InkWell(
                onTap: () => _confirmarExclusao(rotina),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarExclusao(RotinaResponseDTO rotina) async {
    bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text("Excluir Rotina", style: TextStyle(color: Colors.white)),
        content: Text("Deseja apagar a rotina \"${rotina.nome}\"?",
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      // AJUSTE: Adicionado o '!' e verificação de nulo para resolver o erro do print 3
      if (rotina.id != null) {
        final sucesso = await _rotinaService.deletarRotina(rotina.id!.toInt());
        if (sucesso) {
          _carregarRotinas();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Rotina removida com sucesso!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro ao remover rotina no servidor.")),
          );
        }
      }
    }
  }
}