import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../dto/treino_request_dto.dart';
import '../dto/treino_response_dto.dart';
import 'dart:convert';

class TreinoService {
  final String _baseUrl = "http://192.168.1.14:8080";

  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String?> _getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<List<TreinoResponseDTO>> getHistoricoTreinos() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse("$_baseUrl/api/treino"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);

        return body.map((item) => TreinoResponseDTO.fromJson(item)).toList();
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
      final usuarioId = await _getUserId();
      if (usuarioId == null) {
        print("ERRO: Usuário não logado (ID null).");
        return false;
      }

      final headers = await _getAuthHeaders();
      String body = jsonEncode(treinoParaSalvar.toJson());

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

  /// Deleta um treino pelo ID
  Future<bool> deletarTreino(int idTreino) async {
    try {
      final headers = await _getAuthHeaders();

      // Assume que no Java a rota é DELETE /api/treino/{id}
      final response = await http.delete(
        Uri.parse("$_baseUrl/api/treino/$idTreino"),
        headers: headers,
      );

      // 200 (OK) ou 204 (No Content) significam sucesso
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print("Erro ao deletar. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Erro de rede ao deletar: $e");
      return false;
    }
  }

  Future<bool> atualizarTreino(int id, TreinoRequestDTO treino) async {
    final url = Uri.parse('$_baseUrl/api/treino/$id');

    try {
      // 1. AQUI ESTÁ A CORREÇÃO:
      // Usamos o método auxiliar que VOCÊ JÁ TEM na classe.
      // Ele busca do FlutterSecureStorage com a chave 'jwt_token' correta.
      final headers = await _getAuthHeaders();

      final response = await http.put(
        url,
        headers: headers, // Enviamos o cabeçalho certinho
        body: jsonEncode(treino.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Erro Back-end: ${response.statusCode} - Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de conexão no Flutter: $e");
      return false;
    }
  }
}
