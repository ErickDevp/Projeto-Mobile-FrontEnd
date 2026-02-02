import 'package:flutter/material.dart';
import '../dto/rotina/request/rotina_request_dto.dart'; // Certifique-se do caminho correto
import 'registrar_detalhes_treino_page.dart';

class CriarRotinaScreen extends StatefulWidget {
  const CriarRotinaScreen({Key? key}) : super(key: key);

  @override
  State<CriarRotinaScreen> createState() => _CriarRotinaScreenState();
}

class _CriarRotinaScreenState extends State<CriarRotinaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _obsController = TextEditingController();

  void _validarEViajar() {
    if (_formKey.currentState!.validate()) {
      // 1. Criamos o DTO principal aqui.
      // Ele começa com a lista de dias vazia.
      final novaRotina = RotinaRequestDTO(
        nome: _nomeController.text,
        descricao: _obsController.text.isEmpty ? "Sem observações" : _obsController.text,
        dataInicio: DateTime.now().toString().split(' ')[0], // Formato YYYY-MM-DD
        dias: [],
      );

      // 2. Passamos o objeto INTEIRO para a próxima página
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrarDetalhesTreinoPage(
            rotina: novaRotina,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Criar Rotina", style: TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              _label("Nome da Rotina"),
              TextFormField(
                controller: _nomeController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle("Ex: Emagrecimento Jan/2026"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, digite o nome da rotina';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label("Observações Gerais"),
                  const Text("Opcional", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              TextFormField(
                controller: _obsController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: _inputStyle("Ex: Focar em cardio nos finais de treino"),
              ),

              const SizedBox(height: 40),

              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _validarEViajar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Configurar Dias", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.calendar_month, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(texto, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFF333333),
      errorStyle: const TextStyle(color: Colors.redAccent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(18),
    );
  }
}