import 'package:flutter/material.dart';
import '../dto/treino_request_dto.dart';
import '../dto/exercicio_request_dto.dart';
import '../services/treino_service.dart';

class AdicionarExerciciosPage extends StatefulWidget {
  // ADICIONAMOS ISSO PARA RECEBER OS DADOS
  final String nomeTreino;
  final String duracao;
  final String intensidade;
  final String obs;

  const AdicionarExerciciosPage({
    Key? key,
    required this.nomeTreino,
    required this.duracao,
    required this.intensidade,
    required this.obs,
  }) : super(key: key);

  @override
  State<AdicionarExerciciosPage> createState() => _AdicionarExerciciosPageState();
}

class _AdicionarExerciciosPageState extends State<AdicionarExerciciosPage> {
  // Controladores para o formulário de EXERCÍCIO
  final _nomeExercicioController = TextEditingController();
  final _cargaController = TextEditingController();
  final _repeticoesController = TextEditingController();
  final _seriesController = TextEditingController();
  final _obsExercicioController = TextEditingController();

  // Lista local para mostrar na tela o que estamos adicionando
  final List<Map<String, String>> _exerciciosAdicionados = [];

  void _adicionarNaLista() {
    if (_nomeExercicioController.text.isEmpty) return;

    setState(() {
      _exerciciosAdicionados.add({
        "nome": _nomeExercicioController.text,
        "carga": _cargaController.text,
        "reps": _repeticoesController.text,
        "series": _seriesController.text,
        "obs": _obsExercicioController.text,
      });
    });

    // Limpa os campos para o próximo
    _nomeExercicioController.clear();
    _cargaController.clear();
    _repeticoesController.clear();
    _seriesController.clear();
    _obsExercicioController.clear();

    // Esconde o teclado
    FocusScope.of(context).unfocus();
  }

  void _salvarTreinoCompleto() async {
    // 1. Validação básica
    if (_exerciciosAdicionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um exercício!')),
      );
      return;
    }

    // 2. Converte visual para DTO
    // CORREÇÃO AQUI: Adicionei os dois pontos (:) que faltavam e corrigi 'tryParse'
    List<ExercicioRequestDTO> listaExerciciosDto = _exerciciosAdicionados.map<ExercicioRequestDTO>((ex) {
      return ExercicioRequestDTO(
        nomeExercicio: ex['nome']!,
        series: int.tryParse(ex['series'] ?? '0') ?? 0,
        repeticoes: ex['reps'] ?? '0',
        cargaTotalKg: double.tryParse(ex['carga'] ?? '0') ?? 0.0,
        observacoesEx: ex['obs'] ?? '',
      );
    }).toList();

    // 3. Monta o Treino
    TreinoRequestDTO treinoNovo = TreinoRequestDTO(
      nome: widget.nomeTreino,
      duracaoEstimada: widget.duracao,
      intensidade: widget.intensidade,
      observacao: widget.obs,
      exercicios: listaExerciciosDto,
    );

    // 4. Chama o Service
    final service = TreinoService(); // Agora com o import lá em cima, isso vai funcionar

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salvando treino...')));

    // Chama o método que VOCÊ criou no service
    bool sucesso = await service.registrarTreino(treinoNovo);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Treino salvo com sucesso! 🚀')
        ),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Erro ao salvar. Tente novamente.')
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      appBar: AppBar(
        title: const Text("Adicionar Exercício", style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- FORMULÁRIO ---
            _label("Nome"),
            _inputEscuro(_nomeExercicioController, "Ex: Supino Reto"),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label("Carga"), _inputEscuro(_cargaController, "kg")])),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label("Repetições"), _inputEscuro(_repeticoesController, "12")])),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label("Séries"), _inputEscuro(_seriesController, "3")])),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_label("Observações"), const Text("Opcional", style: TextStyle(color: Colors.grey, fontSize: 12))],
            ),
            _inputEscuro(_obsExercicioController, "Ex: Drop-set na última", linhas: 2),

            const SizedBox(height: 16),

            // Botão ADICIONAR (Pequeno e Azul)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _adicionarNaLista,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                child: const Text("Adicionar", style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(color: Colors.grey),
            const Text("Exercícios", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // --- LISTA DE EXERCÍCIOS ADICIONADOS ---
            _exerciciosAdicionados.isEmpty
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("Sem exercícios...", style: TextStyle(color: Colors.grey)),
            )
                : ListView.builder(
              shrinkWrap: true, // Importante para lista dentro de ScrollView
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _exerciciosAdicionados.length,
              itemBuilder: (context, index) {
                final ex = _exerciciosAdicionados[index];
                return Card(
                  color: const Color(0xFF424242),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(ex['nome']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text("${ex['carga']}kg | ${ex['reps']} Reps | ${ex['series']} Series", style: const TextStyle(color: Colors.grey)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => setState(() => _exerciciosAdicionados.removeAt(index)),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Botão SALVAR FINAL
            ElevatedButton(
              onPressed: _salvarTreinoCompleto,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0), // Azul mais escuro
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Salvar Treino", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));

  Widget _inputEscuro(TextEditingController controller, String hint, {int linhas = 1}) {
    return TextField(
      controller: controller,
      maxLines: linhas,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: const Color(0xFF424242),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}