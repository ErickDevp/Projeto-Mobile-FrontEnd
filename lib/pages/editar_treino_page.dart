import 'package:flutter/material.dart';
import '../dto/treino_response_dto.dart';
import '../dto/treino_request_dto.dart';
import '../dto/exercicio_request_dto.dart';
import '../dto/exercicio_response_dto.dart';
import '../services/treino_service.dart';

class EditarTreinoPage extends StatefulWidget {
  final TreinoResponseDTO treino;

  const EditarTreinoPage({Key? key, required this.treino}) : super(key: key);

  @override
  State<EditarTreinoPage> createState() => _EditarTreinoPageState();
}

class _EditarTreinoPageState extends State<EditarTreinoPage> {
  final TreinoService _service = TreinoService();

  // Controladores do Treino
  late TextEditingController _nomeController;
  late TextEditingController _duracaoController;
  late TextEditingController _intensidadeController; // Agora é Controller de texto
  late TextEditingController _obsTreinoController;

  late List<ExercicioResponseDTO> _exerciciosLocais;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.treino.nomeRotina);
    _duracaoController = TextEditingController(text: widget.treino.duracaoMin.toString());

    // Inicializa a intensidade com o valor que veio do banco (convertido para texto)
    _intensidadeController = TextEditingController(text: widget.treino.intensidadeGeral.toString());

    _obsTreinoController = TextEditingController(text: widget.treino.observacoes ?? "");
    _exerciciosLocais = List.from(widget.treino.exercicios);
  }

  // --- POPUP PARA EDITAR EXERCÍCIO (AGORA COM NOME) ---
  void _abrirPopupEditarExercicio(int index) {
    final exercicio = _exerciciosLocais[index];

    // Controladores do Exercício
    final nomeExCtrl = TextEditingController(text: exercicio.nomeExercicio); // <--- Novo: Nome
    final pesoCtrl = TextEditingController(text: exercicio.cargaTotalKg.toString());
    final repsCtrl = TextEditingController(text: exercicio.repeticoes);
    final seriesCtrl = TextEditingController(text: exercicio.series.toString());
    final obsExCtrl = TextEditingController(text: exercicio.observacoesEx ?? "");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF424242),
        title: const Text("Editar Exercício", style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Campo para alterar o NOME DO EXERCÍCIO
              TextField(
                controller: nomeExCtrl,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: "Nome do Exercício",
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 15),

              _campoPopup("Peso (kg)", pesoCtrl, isDecimal: true),
              const SizedBox(height: 10),
              _campoPopup("Repetições", repsCtrl),
              const SizedBox(height: 10),
              _campoPopup("Séries", seriesCtrl),
              const SizedBox(height: 10),

              // Campo Observação do Exercício
              TextField(
                controller: obsExCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Obs. do Exercício",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              double novoPeso = double.tryParse(pesoCtrl.text.replaceAll(',', '.')) ?? 0.0;
              int novasSeries = int.tryParse(seriesCtrl.text) ?? 0;

              setState(() {
                _exerciciosLocais[index] = ExercicioResponseDTO(
                  id: exercicio.id,
                  nomeExercicio: nomeExCtrl.text, // <--- Salvando o nome novo
                  cargaTotalKg: novoPeso,
                  repeticoes: repsCtrl.text,
                  series: novasSeries,
                  observacoesEx: obsExCtrl.text,
                );
              });
              Navigator.pop(ctx);
            },
            child: const Text("Salvar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- AÇÃO DE SALVAR TUDO ---
  void _salvarTreinoGeral() async {
    setState(() => _salvando = true);

    List<ExercicioRequestDTO> listaParaEnvio = _exerciciosLocais.map((e) {
      return ExercicioRequestDTO(
        nomeExercicio: e.nomeExercicio,
        cargaTotalKg: e.cargaTotalKg,
        repeticoes: e.repeticoes,
        series: e.series,
        observacoesEx: e.observacoesEx,
      );
    }).toList();

    // Mantendo envio como STRING para respeitar seu DTO atual
    TreinoRequestDTO treinoAtualizado = TreinoRequestDTO(
      nomeRotina: _nomeController.text,
      duracaoEstimada: _duracaoController.text,
      intensidade: _intensidadeController.text, // <--- Envia o texto digitado (ex: "8")
      observacao: _obsTreinoController.text,
      exercicios: listaParaEnvio,
    );

    bool sucesso = await _service.atualizarTreino(widget.treino.id, treinoAtualizado);

    setState(() => _salvando = false);

    if (sucesso) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Treino salvo com sucesso!"), backgroundColor: Colors.green),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao salvar."), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Editar Treino", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Nome do Treino
            TextField(
              controller: _nomeController,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: "Nome do Treino",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
            const Divider(color: Colors.grey),

            // Campos Duração e Intensidade (Agora Texto Simples)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _duracaoController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Duração (min)",
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.timer, color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField( // <--- Mudado para TextField Simples
                    controller: _intensidadeController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Intensidade (1-10)", // Instrução visual
                      labelStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.local_fire_department, color: Colors.orange),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Observações Gerais
            TextField(
              controller: _obsTreinoController,
              style: const TextStyle(color: Colors.white70),
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Observações Gerais",
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.note, color: Colors.grey),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
            const SizedBox(height: 20),

            // Cabeçalho da Lista
            const Row(
              children: [
                Expanded(flex: 4, child: Text("Exercício", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text("Carga", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text("Reps", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center)),
                SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 10),

            // Lista de Exercícios
            Expanded(
              child: ListView.builder(
                itemCount: _exerciciosLocais.length,
                itemBuilder: (context, index) {
                  final ex = _exerciciosLocais[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF424242),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ex.nomeExercicio, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                if (ex.observacoesEx != null && ex.observacoesEx!.isNotEmpty)
                                  Text(
                                    ex.observacoesEx!,
                                    style: const TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            )
                        ),
                        Expanded(flex: 2, child: Text("${ex.cargaTotalKg} kg", style: const TextStyle(color: Colors.blueAccent), textAlign: TextAlign.center)),
                        Expanded(flex: 2, child: Text(ex.repeticoes, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),

                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                          onPressed: () => _abrirPopupEditarExercicio(index),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            // Botão Salvar
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _salvando ? null : _salvarTreinoGeral,
                child: _salvando
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Salvar Alterações", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para inputs menores do popup
  Widget _campoPopup(String label, TextEditingController controller, {bool isDecimal = false}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
      ),
    );
  }
}