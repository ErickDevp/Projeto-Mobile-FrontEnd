import 'package:flutter/material.dart';
import '../dto/rotina/request/rotina_request_dto.dart'; // Importe seu DTO
import 'adicionar_exercicio_rotina.dart';

class RegistrarDetalhesTreinoPage extends StatefulWidget {
  // Alterado: Agora recebe o objeto DTO completo da tela anterior
  final RotinaRequestDTO rotina;

  const RegistrarDetalhesTreinoPage({
    Key? key,
    required this.rotina,
  }) : super(key: key);

  @override
  State<RegistrarDetalhesTreinoPage> createState() => _RegistrarDetalhesTreinoPageState();
}

class _RegistrarDetalhesTreinoPageState extends State<RegistrarDetalhesTreinoPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores da TELA 2
  final _diaController = TextEditingController();
  final _nomeTreinoController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _intensidadeController = TextEditingController();
  final _obsTreinoController = TextEditingController();

  // Lista para o Dropdown de dias (para bater com o Enum do Java)
  String _diaSelecionado = "SEGUNDA";
  final List<String> _diasDaSemana = [
    "SEGUNDA", "TERCA", "QUARTA", "QUINTA", "SEXTA", "SABADO", "DOMINGO"
  ];

  @override
  void dispose() {
    _diaController.dispose();
    _nomeTreinoController.dispose();
    _duracaoController.dispose();
    _intensidadeController.dispose();
    _obsTreinoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.rotina.nome, // Mostra o nome vindo da Tela 1
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Configurar Treino",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),

              // 1. DIA (Alterado para Dropdown para evitar erro de digitação no Enum do Java)
              _label("Dia da Semana"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _diaSelecionado,
                    dropdownColor: const Color(0xFF333333),
                    style: const TextStyle(color: Colors.white),
                    isExpanded: true,
                    items: _diasDaSemana.map((String dia) {
                      return DropdownMenuItem(value: dia, child: Text(dia));
                    }).toList(),
                    onChanged: (novo) => setState(() => _diaSelecionado = novo!),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 2. NOME DO TREINO
              _label("Nome do Treino"),
              _inputEscuro(_nomeTreinoController, "Ex: Treino A - Superior"),
              const SizedBox(height: 15),

              // 3. DURAÇÃO E INTENSIDADE
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Duração (min)"),
                        _inputEscuro(_duracaoController, "60", tipoTeclado: TextInputType.number),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Intensidade (1-10)"),
                        _inputEscuro(_intensidadeController, "7", tipoTeclado: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // 4. OBSERVAÇÕES DO TREINO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label("Observações do Treino"),
                  const Text("Opcional", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              _inputEscuro(_obsTreinoController, "Focar na execução lenta...", linhas: 3),

              const SizedBox(height: 40),

              Center(
                child: SizedBox(
                  width: 200,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdicionarExercicioRotina(
                              // Passamos o objeto rotina completo
                              rotina: widget.rotina,
                              // Passamos os dados deste dia específico
                              diaSelecionado: _diaSelecionado,
                              nomeTreino: _nomeTreinoController.text,
                              duracao: int.tryParse(_duracaoController.text) ?? 60,
                              intensidade: int.tryParse(_intensidadeController.text) ?? 3,
                              obsTreino: _obsTreinoController.text,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Adicionar Exercícios", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.fitness_center, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 2),
      child: Text(texto, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _inputEscuro(TextEditingController controller, String hint, {int linhas = 1, TextInputType tipoTeclado = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: linhas,
      keyboardType: tipoTeclado,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF333333),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) {
        if (linhas == 1 && (value == null || value.trim().isEmpty)) {
          return "Campo obrigatório";
        }
        return null;
      },
    );
  }
}