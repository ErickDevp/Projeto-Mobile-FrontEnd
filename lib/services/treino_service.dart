import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../dto/treino_request_dto.dart';
// import '../dto/exercicio_request_dto.dart'; // Mantenha descomentado se seu projeto precisar

class TreinoService {
  // Endereço do Backend (Seu IP Local)
  final String _baseUrl = "http://192.168.1.9:8080";

  final _storage = const FlutterSecureStorage();

  /// Busca o cabeçalho de autenticação (Token JWT).
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  /// Busca o ID do usuário salvo no storage.
  Future<String?> _getUserId() async {
    // Chave corrigida para bater com o AuthService
    return await _storage.read(key: 'user_id');
  }

  /// Busca o histórico de treinos do usuário no backend.
  Future<List<dynamic>> getHistoricoTreinos() async {
    try {
      final headers = await _getAuthHeaders();

      // 🚨 CORREÇÃO DE URL:
      // No Java: @GetMapping em "/api/treino" retorna a lista.
      // Não precisa passar ID na URL, o Token já identifica o usuário.
      final response = await http.get(
        Uri.parse("$_baseUrl/api/treino"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> treinos = jsonDecode(response.body);
        return treinos;
      } else {
        print("Erro ao buscar histórico. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Erro de rede ao buscar histórico: $e");
      return [];
    }
  }

  /// Salva um novo treino no backend.
  Future<bool> registrarTreino(TreinoRequestDTO treinoParaSalvar) async {
    try {
      // Verificação de segurança apenas
      final usuarioId = await _getUserId();
      if (usuarioId == null) {
        print("ERRO: Usuário não logado (ID null).");
        return false;
      }

      final headers = await _getAuthHeaders();
      String body = jsonEncode(treinoParaSalvar.toJson());

      // 🚨 CORREÇÃO DE URL:
      // No Java: @PostMapping("/criar") em "/api/treino"
      // URL Final: http://.../api/treino/criar
      final response = await http.post(
        Uri.parse("$_baseUrl/api/treino/criar"),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Treino salvo com sucesso!");
        return true;
      } else {
        print("Erro ao registrar treino. Status: ${response.statusCode}");
        print("Mensagem: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de rede ao registrar treino: $e");
      return false;
    }
  }
}