import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../dto/usuario_response_dto.dart';
import '../dto/usuario_request_dto.dart';

class UsuarioService {
  // Ajuste o IP se necessário
  final String _baseUrl = "http://192.168.1.17:8080";
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<UsuarioResponseDTO?> getMeuPerfil() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse("$_baseUrl/api/usuario/me"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return UsuarioResponseDTO.fromJson(jsonDecode(response.body));
      } else {
        print("Erro ao buscar perfil: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Erro de conexão ao buscar perfil: $e");
      return null;
    }
  }

  Future<bool> atualizarPerfil(UsuarioRequestDTO novosDados) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.put(
        Uri.parse("$_baseUrl/api/usuario/me"),
        headers: headers,
        body: jsonEncode(novosDados.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Erro ao atualizar: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de rede ao atualizar: $e");
      return false;
    }
  }

  Future<bool> uploadFotoPerfil(File imagem) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      var uri = Uri.parse("$_baseUrl/api/usuario/me/foto");

      var request = http.MultipartRequest('POST', uri);

      // Cabeçalho de autorização
      request.headers['Authorization'] = 'Bearer $token';

      // Adiciona o arquivo na requisição (o nome 'foto' deve ser igual ao @RequestParam do Java)
      request.files.add(await http.MultipartFile.fromPath('foto', imagem.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Erro no upload. Status: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Erro ao enviar foto: $e");
      return false;
    }
  }
}