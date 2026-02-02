import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../dto/rotinaTemplate/response/rotina_template_todos_response_dto.dart';

class RotinaTemplateService {
  final String _baseUrl = "http://10.0.0.4:8080";
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<List<RotinaTemplateTodosResponseDTO>> listarTemplates() async {
    try {
      final url = Uri.parse("$_baseUrl/api/rotina/explore");
      final String? token = await _getToken();

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${token ?? ''}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((json) => RotinaTemplateTodosResponseDTO.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Erro no TemplateService: $e");
      return [];
    }
  }
}