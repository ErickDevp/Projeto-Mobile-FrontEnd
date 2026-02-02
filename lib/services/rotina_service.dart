import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // MUDOU AQUI
import '../dto/rotina/request/rotina_request_dto.dart';
import '../dto/rotina/response/rotina_response_dto.dart';

class RotinaService {
  final String _baseUrl = "http://10.0.0.4:8080";

  // Instancie o SecureStorage igual ao do AuthService
  final _storage = const FlutterSecureStorage();

  // Ajuste o método para ler do SecureStorage
  Future<String?> _getToken() async {
    // A chave DEVE ser 'jwt_token' para bater com o AuthService
    final String? token = await _storage.read(key: 'jwt_token');

    if (token == null || token.isEmpty) {
      print("🚨 ALERTA: Nenhum token encontrado no SecureStorage!");
    } else {
      print("✅ TOKEN RECUPERADO DO SECURE STORAGE: ${token.substring(0, 10)}...");
    }
    return token;
  }

  // --- POST: Criar uma nova rotina ---
  Future<bool> criarRotina(RotinaRequestDTO rotina) async {
    try {
      final url = Uri.parse("$_baseUrl/api/rotina/criar");
      final String corpoJson = jsonEncode(rotina.toJson());
      final String? token = await _getToken();

      print("--- [DEBUG POST] ---");
      print("URL: $url");
      print("PAYLOAD: $corpoJson");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token ?? ''}",
        },
        body: corpoJson,
      );

      // Logs solicitados para identificar o erro real no console
      print("STATUS CODE: ${response.statusCode}");
      print("RESPOSTA DO SERVIDOR: ${response.body}");

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("ERRO CRÍTICO NO POST: $e");
      return false;
    }
  }

  // --- GET: Listar todas as rotinas ---
  Future<List<RotinaResponseDTO>> listarRotinas() async {
    try {
      final url = Uri.parse("$_baseUrl/api/rotina");
      final String? token = await _getToken(); // Pegar o token!

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${token ?? ''}", // Enviar o token!
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((json) => RotinaResponseDTO.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Erro no GET Listar: $e");
      return [];
    }
  }

  // --- DELETE: Remover uma rotina por ID ---
  Future<bool> deletarRotina(int id) async {
    try {
      // Usamos o id.toString() para evitar qualquer erro de tipo na URL
      final url = Uri.parse("$_baseUrl/api/rotina/${id.toString()}");
      final String? token = await _getToken();

      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer ${token ?? ''}",
          "Content-Type": "application/json",
          "Accept": "application/json", // Alguns backends exigem saber o que aceitam de volta
        },
      );

      print("--- [DEBUG DELETE] ---");
      print("URL: $url");
      print("STATUS: ${response.statusCode}");

      // Se o status for 403, esse print vai nos salvar:
      if (response.statusCode == 403) {
        print("MOTIVO DO 403: ${response.body}");
      }

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("ERRO NO DELETE: $e");
      return false;
    }
  }
}