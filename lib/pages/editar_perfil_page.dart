import 'dart:io'; // Importante para lidar com arquivo
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Importante para abrir galeria
import '../dto/usuario_response_dto.dart';
import '../dto/usuario_request_dto.dart';
import '../services/usuario_service.dart';

class EditarPerfilPage extends StatefulWidget {
  final UsuarioResponseDTO usuarioAtual;

  const EditarPerfilPage({Key? key, required this.usuarioAtual}) : super(key: key);

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final UsuarioService _service = UsuarioService();
  final ImagePicker _picker = ImagePicker(); // O objeto que abre a galeria

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _objetivoController;

  bool _salvando = false;
  File? _fotoSelecionada; // Guarda a foto se o usuário escolher uma nova

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.usuarioAtual.nome);
    _emailController = TextEditingController(text: widget.usuarioAtual.email);
    _objetivoController = TextEditingController(text: widget.usuarioAtual.objetivo);
  }

  // Função para abrir a galeria
  Future<void> _escolherFoto() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.gallery);

    if (foto != null) {
      setState(() {
        _fotoSelecionada = File(foto.path);
      });

      // Opcional: Já enviar assim que escolher, ou esperar o botão Salvar.
      // Aqui vou deixar para enviar só quando clicar em SALVAR.
    }
  }

  void _salvarAlteracoes() async {
    setState(() => _salvando = true);

    // 1. Atualiza os dados de texto
    final novosDados = UsuarioRequestDTO(
      nome: _nomeController.text,
      email: _emailController.text,
      objetivo: _objetivoController.text,
    );

    bool sucessoTexto = await _service.atualizarPerfil(novosDados);

    // 2. Se tiver foto nova, envia também
    bool sucessoFoto = true;
    if (_fotoSelecionada != null) {
      sucessoFoto = await _service.uploadFotoPerfil(_fotoSelecionada!);
    }

    setState(() => _salvando = false);

    if (sucessoTexto && sucessoFoto) {
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Perfil atualizado!"), backgroundColor: Colors.green),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao atualizar (Verifique conexão)."), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // URL do servidor (Ajuste o IP se mudar)
    const String baseUrl = "http://192.168.1.17:8080";

    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Editar Perfil", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- ÁREA DA FOTO ---
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    // 1. Tem foto nova da galeria? Usa ela.
                    // 2. Tem foto antiga do banco? Usa ela.
                    // 3. Não tem nada? Fica null.
                    backgroundImage: _fotoSelecionada != null
                        ? FileImage(_fotoSelecionada!) as ImageProvider
                        : (widget.usuarioAtual.fotoPerfil != null
                        ? NetworkImage("$baseUrl${widget.usuarioAtual.fotoPerfil}")
                        : null),

                    // Ícone só aparece se não tiver NENHUMA imagem
                    child: (_fotoSelecionada == null && widget.usuarioAtual.fotoPerfil == null)
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _escolherFoto,
                    child: const Text("Alterar Foto", style: TextStyle(color: Colors.blueAccent)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- CAMPOS DE TEXTO ---
            _campoTexto("Nome", _nomeController),
            const SizedBox(height: 20),
            _campoTexto("Email", _emailController),
            const SizedBox(height: 20),
            _campoTexto("Objetivo", _objetivoController),

            const SizedBox(height: 50),

            // --- BOTÃO SALVAR ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                // Se estiver salvando, desabilita o botão (null)
                onPressed: _salvando ? null : _salvarAlteracoes,
                child: _salvando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Salvar", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoTexto(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF424242),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ],
    );
  }
}