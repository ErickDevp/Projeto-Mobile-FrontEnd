import 'package:flutter/material.dart';
import 'adicionar_exercicios_page.dart';

class RegistrarTreinoPage extends StatefulWidget {
  const RegistrarTreinoPage({Key? key}) : super(key: key);

  @override
  State<RegistrarTreinoPage> createState() => _RegistrarTreinoPageState();
}

class _RegistrarTreinoPageState extends State<RegistrarTreinoPage> {
  final _nomeController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _intensidadeController = TextEditingController();
  final _obsController = TextEditingController();

  void _irParaProximoPasso() {
    // Validação simples
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dê um nome ao treino!')));
      return;
    }

    // Navega levando os dados junto!
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdicionarExerciciosPage(
          nomeTreino: _nomeController.text,
          duracao: _duracaoController.text,
          intensidade: _intensidadeController.text,
          obs: _obsController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030), // Fundo Dark
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Registrar Treino", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white), // Setinha branca
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo NOME
            _label("Nome"),
            _inputEscuro(_nomeController, "Ex: Treino de Peito"),
            const SizedBox(height: 20),

            // Linha Dupla: Duração e Intensidade
            // Linha Dupla: Duração e Intensidade
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Duração (min)"),
                      // Agora chama o teclado numérico
                      _inputEscuro(_duracaoController, "Ex: 60", tipoTeclado: TextInputType.number),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Intensidade (1-10)"), // Mudei o label para orientar
                      // Agora chama o teclado numérico
                      _inputEscuro(_intensidadeController, "Ex: 8", tipoTeclado: TextInputType.number),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Campo OBSERVAÇÕES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _label("Observações"),
                const Text("Opcional", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            _inputEscuro(_obsController, "Digite alguma observação...", linhas: 3),

            const SizedBox(height: 40),

            // Botão PRÓXIMO PASSO
            ElevatedButton(
              onPressed: _irParaProximoPasso,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Proximo Passo", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Icon(Icons.double_arrow, color: Colors.white, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para os Textos (Labels)
  Widget _label(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget auxiliar para os Campos Escuros (Cinza)
  Widget _inputEscuro(
      TextEditingController controller,
      String hint,
      {int linhas = 1, TextInputType tipoTeclado = TextInputType.text} // <--- Mudança aqui
      ) {
    return TextField(
      controller: controller,
      maxLines: linhas,
      keyboardType: tipoTeclado, // <--- E aqui: Define qual teclado abre no celular
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: const Color(0xFF424242),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}