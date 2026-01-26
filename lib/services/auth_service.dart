import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Use o seu IP correto aqui
  final String _baseUrl = "http://192.168.1.14:8080";

  final _storage = const FlutterSecureStorage();

  Future<bool> register(String nome, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/register"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
      );

      // O backend agora retorna 200 OK com o Token também no registro
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Já faz o login automático ao registrar
        await _salvarDadosDoUsuario(response.body);
        return true;
      } else {
        print("Falha no registro: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de rede no registro: $e");
      return false;
    }
  }

  Future<bool> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/login"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        // AQUI ESTAVA O ERRO: Agora chamamos uma função para separar os dados
        await _salvarDadosDoUsuario(response.body);
        return true;
      } else {
        print("Falha no login: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de rede no login: $e");
      return false;
    }
  }

  // --- FUNÇÃO NOVA: Salva Token, ID e Nome ---
  Future<void> _salvarDadosDoUsuario(String jsonBody) async {
    // 1. Decodifica o JSON
    final Map<String, dynamic> dados = jsonDecode(jsonBody);

    // 2. Extrai os valores
    String token = dados['token'];
    int id = dados['id'];       // O Backend mandou como número
    String nome = dados['nome'];

    // 3. Salva no celular
    await _storage.write(key: 'jwt_token', value: token);
    await _storage.write(key: 'user_id', value: id.toString()); // Convertemos ID para String para salvar
    await _storage.write(key: 'user_name', value: nome);

    print("Login salvo! ID: $id, Nome: $nome"); // Log para conferência
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Novo método para pegar o ID quando precisar
  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<bool> recuperarSenha(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/forgot-password"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Erro ao solicitar senha: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de rede: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_id');   // Limpa o ID também
    await _storage.delete(key: 'user_name'); // Limpa o Nome também
  }
}