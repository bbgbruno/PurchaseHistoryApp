import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthResult {
  final String id;
  final String name;
  final String email;
  final bool isActive;

  AuthResult({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}

class AuthService {
  final String baseUrl =
      'https://purchasehistoryapi.onrender.com/api';

  Future<AuthResult> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 401) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Credenciais inválidas.');
    }

    if (response.statusCode != 200) {
      throw Exception('Erro ao fazer login.');
    }

    return AuthResult.fromJson(
        jsonDecode(response.body));
  }

  Future<void> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 409) {
      throw Exception('E-mail já cadastrado.');
    }

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar conta.');
    }
  }

  Future<void> forgotPassword(
      String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 404) {
      throw Exception('E-mail não encontrado.');
    }

    if (response.statusCode != 200) {
      throw Exception('Erro ao redefinir senha.');
    }
  }
}
