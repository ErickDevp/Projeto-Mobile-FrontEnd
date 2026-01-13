import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Imports dos DTOs
import '../dto/treino_request_dto.dart'; // Usado para ENVIAR (Registrar)
import '../dto/treino_response_dto.dart'; // <--- NOVO: Usado para RECEBER (Listar)

class TreinoService {
  // ⚠️ ATENÇÃO: Confirme se seu IP fixo é .17 ou .9 (vimos isso mais cedo)
  final String _baseUrl = "http://192.168.1.17:8080";

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
    return await _storage.read(key: 'user_id');
  }

  /// Busca o histórico de treinos e já converte para o DTO correto
  // MUDANÇA AQUI: Retorna List<TreinoResponseDTO> em vez de List<dynamic>
  Future<List<TreinoResponseDTO>> getHistoricoTreinos() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse("$_baseUrl/api/treino"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Converte o JSON puro para a nossa Lista de Objetos
        List<dynamic> body = jsonDecode(response.body);

        // A mágica acontece aqui: mapeamos cada item do JSON para o DTO
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
}
