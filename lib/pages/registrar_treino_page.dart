import 'package:flutter/material.dart';
// Importa seus DTOs (verifique o caminho)
import '../dto/exercicio_request_dto.dart';
import '../dto/treino_request_dto.dart';
// Importa o serviço
import '../services/treino_service.dart';

class RegistrarTreinoPage extends StatefulWidget {
  const RegistrarTreinoPage({Key? key}) : super(key: key);

  @override
  State<RegistrarTreinoPage> createState() => _RegistrarTreinoPageState();
}

class _RegistrarTreinoPageState extends State<RegistrarTreinoPage> {
  // Chaves
  final _formKey = GlobalKey<FormState>();
  final _formExercicioKey = GlobalKey<FormState>(); // Para o Pop-up

  // Controladores da Sessão
  final _nomeRotinaController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _intensidadeController = TextEditingController();
  final _observacoesController = TextEditingController();

  // Controladores do Pop-up (movidos para dentro do método)

  // Lista de exercícios
  final List<ExercicioRequestDTO> _exerciciosAdicionados = [];

  // Serviços e Status
  final _treinoService = TreinoService();
  bool _isLoading = false;

  // Método para salvar o treino completo
  Future<void> _salvarTreino() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_exerciciosAdicionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você deve adicionar pelo menos um exercício.')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    final treinoDTO = TreinoRequestDTO(
      nomeRotina: _nomeRotinaController.text,
      duracaoMin: _duracaoController.text.isNotEmpty ? int.tryParse(_duracaoController.text) : null,
      intensidadeGeral: _intensidadeController.text.isNotEmpty ? int.tryParse(_intensidadeController.text) : null,
      observacoes: _observacoesController.text,
      exercicios: _exerciciosAdicionados,
    );

    bool sucesso = await _treinoService.registrarTreino(treinoDTO);

    setState(() { _isLoading = false; });

    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treino salvo com sucesso!')),
      );
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar o treino.')),
      );
    }
  }


  // Método que abre o Pop-up (AlertDialog)
  Future<void> _mostrarFormularioExercicio() async {
    // Controladores do Pop-up (criados aqui)
    final nomeExController = TextEditingController();
    final seriesController = TextEditingController();
    final repsController = TextEditingController();
    final cargaController = TextEditingController();
    final obsExController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text('Adicionar Exercício', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Form(
              key: _formExercicioKey, // Usa a chave do pop-up
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: nomeExController,
                    decoration: InputDecoration(labelText: 'Nome do Exercício'),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'O nome é obrigatório';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: seriesController,
                    decoration: InputDecoration(labelText: 'Séries (Ex: 4)'),
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty || int.tryParse(value) == null) return 'Insira um número válido';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: repsController,
                    decoration: InputDecoration(labelText: 'Repetições (Ex: 10, 8, 8)'),
                    style: TextStyle(color: Colors.white),
                  ),
                  TextFormField(
                    controller: cargaController,
                    decoration: InputDecoration(labelText: 'Carga (Kg) (Ex: 55.0)'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty || double.tryParse(value) == null) return 'Insira um número válido';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: obsExController,
                    decoration: InputDecoration(labelText: 'Observações (Opcional)'),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.white70)),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Adicionar', style: TextStyle(color: Colors.blue[400])),
              onPressed: () {
                if (_formExercicioKey.currentState!.validate()) {
                  final novoExercicio = ExercicioRequestDTO(
                    nomeExercicio: nomeExController.text,
                    series: int.parse(seriesController.text),
                    repeticoes: repsController.text,
                    cargaTotalKg: double.parse(cargaController.text),
                    observacoesEx: obsExController.text.isNotEmpty ? obsExController.text : null,
                  );
                  setState(() {
                    _exerciciosAdicionados.add(novoExercicio);
                  });
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nomeRotinaController.dispose();
    _duracaoController.dispose();
    _intensidadeController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Novo Treino"),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      // CORREÇÃO: O SingleChildScrollView DEVE estar aqui
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SEÇÃO 1: DETALHES DA SESSÃO ---
              Text(
                "Detalhes da Sessão",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _nomeRotinaController,
                decoration: InputDecoration(labelText: "Nome da Rotina (Ex: Treino A)"),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor, insira um nome para a rotina';
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _duracaoController,
                decoration: InputDecoration(labelText: "Duração (minutos)"),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                // Adicionando validador opcional
                validator: (value) {
                  if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                    return 'Insira um número válido (ex: 60)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Adicionando os campos que faltavam (Intensidade e Observações da Sessão)
              TextFormField(
                controller: _intensidadeController,
                decoration: InputDecoration(labelText: "Intensidade (0-10)"),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final n = int.tryParse(value);
                    if (n == null || n < 0 || n > 10) {
                      return 'Insira um número entre 0 e 10';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _observacoesController,
                decoration: InputDecoration(labelText: "Observações da Sessão (Opcional)"),
                style: TextStyle(color: Colors.white),
              ),

              // --- SEÇÃO 2: EXERCÍCIOS ---
              Divider(color: Colors.grey[700], height: 40),
              Text(
                "Exercícios",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              _exerciciosAdicionados.isEmpty
                  ? Center(
                child: Text("Nenhum exercício adicionado.", style: TextStyle(color: Colors.grey)),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _exerciciosAdicionados.length,
                itemBuilder: (context, index) {
                  final ex = _exerciciosAdicionados[index];
                  return Card(
                    color: Colors.grey[800],
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(ex.nomeExercicio, style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                        '${ex.series} séries | ${ex.repeticoes} reps | ${ex.cargaTotalKg} Kg',
                        style: TextStyle(color: Colors.white70),
                      ),
                      // TODO: Adicionar um botão de remover (trailing)
                    ),
                  );
                },
              ),

              SizedBox(height: 16),
              OutlinedButton.icon(
                icon: Icon(Icons.add),
                label: Text("Adicionar Exercício"),
                onPressed: _mostrarFormularioExercicio,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[400],
                  side: BorderSide(color: Colors.blue[400]!),
                ),
              ),

              // --- SEÇÃO 3: SALVAR ---
              SizedBox(height: 40),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _salvarTreino,
                child: Text("Salvar Treino"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}