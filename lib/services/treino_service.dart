import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../dto/treino_request_dto.dart';
import '../dto/exercicio_request_dto.dart';

// TODO: Crie a classe modelo para a resposta do treino (baseada no TreinoResponseDTO)
// Por enquanto, usaremos 'dynamic' ou 'Map<String, dynamic>'

class TreinoService {
  // Endereço do seu Backend (use 10.0.2.2 para o Emulador Android)
  final String _baseUrl = "http://10.0.2.2:8080";
  final _storage = const FlutterSecureStorage();

  /// Busca o cabeçalho de autenticação (Token JWT).
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'jwt_token');

    // Retorna o cabeçalho pronto para ser usado nas requisições
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token', // Envia o Token JWT
    };
  }

  /// Busca o ID do usuário salvo no storage.
  Future<String?> _getUserId() async {
    return await _storage.read(key: 'usuario_id');
  }

  /// Busca o histórico de treinos do usuário no backend.
  Future<List<dynamic>> getHistoricoTreinos() async {
    try {
      final usuarioId = await _getUserId();
      if (usuarioId == null) {
        throw Exception('ID do usuário não encontrado.');
      }

      final headers = await _getAuthHeaders(); // Pega o cabeçalho com o Token

      // Chama a rota protegida GET /api/treinos/historico/{id}
      final response = await http.get(
        Uri.parse("$_baseUrl/api/treinos/historico/$usuarioId"),
        headers: headers, // Envia o cabeçalho de autenticação
      );

      if (response.statusCode == 200) {
        // Se sucesso (200 OK), decodifica o JSON (que é uma lista)
        List<dynamic> treinos = jsonDecode(response.body);
        return treinos;
      } else {
        // Trata erros (ex: 403 Forbidden se o token expirou)
        print("Erro ao buscar histórico: ${response.statusCode}");
        return []; // Retorna lista vazia em caso de falha
      }
    } catch (e) {
      print("Erro de rede ao buscar histórico: $e");
      return []; // Retorna lista vazia em caso de erro
    }
  }

  Future<bool> registrarTreino(TreinoRequestDTO treinoParaSalvar) async {
    try {
      final usuarioId = await _getUserId();
      if (usuarioId == null) {
        throw Exception('ID do usuário não encontrado.');
      }

      final headers = await _getAuthHeaders(); // Pega o cabeçalho com o Token

      // Converte o objeto DTO do Treino para JSON
      // Precisamos de um método .toJson() nos nossos DTOs
      String body = jsonEncode(treinoParaSalvar.toJson());

      // Chama a rota protegida POST /api/treinos/registrar/{id}
      final response = await http.post(
        Uri.parse("$_baseUrl/api/treinos/registrar/$usuarioId"),
        headers: headers, // Envia o cabeçalho de autenticação
        body: body,
      );

      if (response.statusCode == 201) {
        // Sucesso (201 Created)
        return true;
      } else {
        // Trata erros (ex: 400 Bad Request se a validação falhar)
        print("Erro ao registrar treino: ${response.statusCode}");
        print("Corpo: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de rede ao registrar treino: $e");
      return false;
    }
  }
}