import 'package:flutter/material.dart';
import '../../services/rotina_template_service.dart';
import '../../dto/rotinaTemplate/response/rotina_template_todos_response_dto.dart';

class ExplorarRotinasPage extends StatefulWidget {
  const ExplorarRotinasPage({super.key});

  @override
  State<ExplorarRotinasPage> createState() => _ExplorarRotinasPageState();
}

class _ExplorarRotinasPageState extends State<ExplorarRotinasPage> {
  final RotinaTemplateService _templateService = RotinaTemplateService();

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
          "Explorar Rotinas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<RotinaTemplateTodosResponseDTO>>(
        future: _templateService.listarTemplates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Erro ao carregar templates", style: TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhuma rotina disponível.", style: TextStyle(color: Colors.white70)));
          }

          final templates = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              return _buildTemplateCard(templates[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildTemplateCard(RotinaTemplateTodosResponseDTO template) {
    String diasFormatados = template.dias.map((d) => d.dia).join("   ");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection("Nome", template.nome),
          const Divider(color: Colors.white24, height: 20),

          // AGORA COMO DESCRIÇÃO
          _buildInfoSection("Descrição", template.descricao),
          const Divider(color: Colors.white24, height: 20),

          _buildInfoSection("Dias", diasFormatados),
          const Divider(color: Colors.white24, height: 20),

          Row(
            children: [
              Expanded(child: _buildInfoSection("Objetivo", template.objetivo)),
              Expanded(child: _buildInfoSection("Nível", template.nivel)),
              IconButton(
                onPressed: () {}, // Lógica para clonar
                icon: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
              IconButton(
                onPressed: () {}, // Lógica para visualizar
                icon: const Icon(Icons.visibility_outlined, color: Colors.white, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        Text(
          value.isEmpty ? "Sem descrição disponível" : value,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}