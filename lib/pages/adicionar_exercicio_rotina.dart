import 'package:flutter/material.dart';
import '../dto/rotina/request/exercicio_request_dto.dart';
import '../dto/rotina/request/treino_request_dto.dart';
import '../dto/rotina/request/dia_request_dto.dart';
import '../dto/rotina/request/rotina_request_dto.dart';
import '../services/rotina_service.dart';

class AdicionarExercicioRotina extends StatefulWidget {
  final RotinaRequestDTO rotina;
  final String diaSelecionado;
  final String nomeTreino;
  final int duracao;
  final int intensidade;
  final String obsTreino;

  const AdicionarExercicioRotina({
    Key? key,
    required this.rotina,
    required this.diaSelecionado,
    required this.nomeTreino,
    required this.duracao,
    required this.intensidade,
    required this.obsTreino,
  }) : super(key: key);

  @override
  State<AdicionarExercicioRotina> createState() => _AdicionarExercicioRotinaState();
}

class _AdicionarExercicioRotinaState extends State<AdicionarExercicioRotina> {
  final _nomeExercicioController = TextEditingController();
  final _cargaController = TextEditingController();
  final _repeticoesController = TextEditingController();
  final _seriesController = TextEditingController();
  final _obsExercicioController = TextEditingController();

  final List<ExercicioRequestDTO> _exerciciosDoDia = [];

  @override
  void dispose() {
    _nomeExercicioController.dispose();
    _cargaController.dispose();
    _repeticoesController.dispose();
    _seriesController.dispose();
    _obsExercicioController.dispose();
    super.dispose();
  }

  void _adicionarNaLista() {
    if (_nomeExercicioController.text.trim().isEmpty) return;

    setState(() {
      _exerciciosDoDia.add(ExercicioRequestDTO(
        nomeExercicio: _nomeExercicioController.text,
        series: int.tryParse(_seriesController.text) ?? 0,
        repeticoes: _repeticoesController.text,
        cargaTotalKg: double.tryParse(_cargaController.text) ?? 0.0,
        observacoesEx: _obsExercicioController.text,
      ));
    });
    _limparCamposExercicio();
  }

  void _limparCamposExercicio() {
    _nomeExercicioController.clear();
    _cargaController.clear();
    _repeticoesController.clear();
    _seriesController.clear();
    _obsExercicioController.clear();
    FocusScope.of(context).unfocus(); // Fecha o teclado
  }

  void _salvarDiaERecomecar() {
    if (_exerciciosDoDia.isEmpty) {
      _mostrarAlerta('Adicione exercícios antes de salvar este dia!');
      return;
    }

    final diaDto = DiaRequestDTO(
      dia: widget.diaSelecionado,
      treino: TreinoRequestDTO(
        nomeTreino: widget.nomeTreino,
        duracaoMin: widget.duracao,
        intensidadeGeral: widget.intensidade,
        observacoes: widget.obsTreino,
        exercicios: List.from(_exerciciosDoDia),
      ),
    );

    widget.rotina.dias.add(diaDto);

    Navigator.pop(context); // Volta para escolher outro dia

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dia ${widget.diaSelecionado} adicionado com sucesso!')),
    );
  }

  void _finalizarESalvarNoBanco() async {
    // Se a lista temporária tem itens, precisamos "fechar" este dia antes de enviar
    if (_exerciciosDoDia.isNotEmpty) {
      // Verifica se o dia atual já não foi adicionado via "+ Outro Dia"
      bool jaExiste = widget.rotina.dias.any((d) => d.dia == widget.diaSelecionado);

      if (!jaExiste) {
        final ultimoDia = DiaRequestDTO(
          dia: widget.diaSelecionado,
          treino: TreinoRequestDTO(
            nomeTreino: widget.nomeTreino,
            duracaoMin: widget.duracao,
            intensidadeGeral: widget.intensidade,
            observacoes: widget.obsTreino,
            exercicios: List.from(_exerciciosDoDia),
          ),
        );
        widget.rotina.dias.add(ultimoDia);
      }
    }

    if (widget.rotina.dias.isEmpty) {
      _mostrarAlerta('Adicione pelo menos um treino completo!');
      return;
    }

    final service = RotinaService();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CircularProgressIndicator(color: Colors.blue))
    );

    bool sucesso = await service.criarRotina(widget.rotina);

    if (!mounted) return;
    Navigator.pop(context); // Fecha o loading

    if (sucesso) {
      _mostrarSucesso('Rotina salva com sucesso!');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      _mostrarErro('Erro ao salvar no servidor. Verifique os dados.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        title: const Text("Adicionar Exercício", style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            _label("Exercício"),
            _inputEscuro(_nomeExercicioController, "Ex: Supino Reto"),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: _colunaInput("Carga", _cargaController, "kg")),
                const SizedBox(width: 10),
                Expanded(child: _colunaInput("Reps", _repeticoesController, "12")),
                const SizedBox(width: 10),
                Expanded(child: _colunaInput("Séries", _seriesController, "4")),
              ],
            ),
            const SizedBox(height: 15),
            _label("Observações"),
            _inputEscuro(_obsExercicioController, "Opcional", linhas: 2),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _adicionarNaLista,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Adicionar na Lista", style: TextStyle(color: Colors.white)),
              ),
            ),
            const Divider(color: Colors.grey, height: 40),
            Center(
                child: Text(
                    "Treino de ${widget.diaSelecionado}",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                )
            ),
            const SizedBox(height: 15),
            ..._exerciciosDoDia.map((ex) => _cardExercicio(ex)).toList(),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: _rodape(),
    );
  }

  // --- Widgets Auxiliares ---

  Widget _cardExercicio(ExercicioRequestDTO ex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFF333333), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(ex.nomeExercicio, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              if (ex.observacoesEx.isNotEmpty)
                Text(ex.observacoesEx, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ]),
          ),
          Text("${ex.cargaTotalKg}kg", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          const SizedBox(width: 15),
          Text("${ex.series}x${ex.repeticoes}", style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _rodape() {
    return Container(
      color: const Color(0xFF222222),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _salvarDiaERecomecar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF333333),
                minimumSize: const Size(double.infinity, 50),
                // CORREÇÃO: side em vez de borderSide
                side: const BorderSide(color: Colors.blueAccent),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("+ Outro Dia", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: _finalizarESalvarNoBanco,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4285F4),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Salvar Rotina", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- Funções de Feedback ---
  void _mostrarAlerta(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  void _mostrarErro(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(msg)));
  void _mostrarSucesso(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text(msg)));

  Widget _label(String text) => Text(text, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold));
  Widget _colunaInput(String label, TextEditingController controller, String hint) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label(label), _inputEscuro(controller, hint, tipoTeclado: TextInputType.number)]);
  Widget _inputEscuro(TextEditingController controller, String hint, {int linhas = 1, TextInputType tipoTeclado = TextInputType.text}) => TextField(controller: controller, maxLines: linhas, keyboardType: tipoTeclado, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.grey, fontSize: 12), filled: true, fillColor: const Color(0xFF333333), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.all(12)));
}