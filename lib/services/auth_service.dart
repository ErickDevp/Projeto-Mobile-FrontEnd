import 'dart:convert'; // 1. Para codificar/decodificar JSON
import 'package:http/http.dart' as http; // 2. Para fazer as chamadas HTTP
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 3. Para armazenar o token JWT

class AuthService {

  // 4. Endereço do seu Backend Spring Boot
  // Use 10.0.2.2 em vez de 'localhost' se estiver usando um Emulador Android
  final String _baseUrl = "http://10.0.2.2:8080";

  // 5. Instância do armazenamento seguro
  final _storage = const FlutterSecureStorage();

  /// Tenta registrar um novo usuário no backend.
  Future<bool> register(String nome, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/register"), // 6. Endpoint de Cadastro
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // 7. Informa ao Spring que é JSON
        },
        body: jsonEncode({ // 8. Converte o objeto Dart em JSON
          'nome': nome,
          'email': email,
          'senha': senha,
        }),
      );

      // 9. Verifica se o backend retornou "201 Created"
      if (response.statusCode == 201) {
        return true; // Sucesso
      } else {
        // Você pode tratar outros erros aqui (ex: email já existe)
        print("Falha no registro: ${response.body}");
        return false; // Falha
      }
    } catch (e) {
      // Captura erros de rede (ex: backend desligado)
      print("Erro de rede no registro: $e");
      return false;
    }
  }

  /// Tenta fazer login no backend e armazena o token JWT.
  Future<bool> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/login"), // 10. Endpoint de Login
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({ // 11. Envia o DTO de Login
          'email': email,
          'senha': senha,
        }),
      );

      // 12. Verifica se o backend retornou "200 OK"
      if (response.statusCode == 200) {
        // 13. Pega o Token JWT (string) do corpo da resposta
        final String token = response.body;

        // 14. Armazena o token de forma segura no dispositivo
        await _storage.write(key: 'jwt_token', value: token);

        return true; // Sucesso
      } else {
        // Você pode tratar "401 Unauthorized" (Credenciais Inválidas) aqui
        print("Falha no login: ${response.body}");
        return false; // Falha
      }
    } catch (e) {
      print("Erro de rede no login: $e");
      return false;
    }
  }

  /// Busca o token JWT armazenado no dispositivo.
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  /// Remove o token JWT do dispositivo (Logout).
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}