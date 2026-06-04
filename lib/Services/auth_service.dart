import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_service.dart';

class AuthResult {
  final String token;
  final String id;
  final String name;
  final String email;
  final bool isActive;

  AuthResult({
    required this.token,
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    return AuthResult(
      token: json['token'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}

class AuthService {
  Future<AuthResult> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse(
          '${ApiService.baseUrl}/auth/login'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 401) {
      final body = jsonDecode(response.body);
      throw Exception(
          body['message'] ??
              'Credenciais inválidas.');
    }

    if (response.statusCode != 200) {
      throw Exception('Erro ao fazer login.');
    }

    final result = AuthResult.fromJson(
        jsonDecode(response.body));
    ApiService.setToken(result.token);
    return result;
  }

  Future<void> register(String name, String email,
      String password) async {
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/users'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 409) {
      throw Exception(
          'E-mail já cadastrado.');
    }

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar conta.');
    }
  }

  Future<void> forgotPassword(
      String email, String newPassword) async {
    final response = await http.post(
      Uri.parse(
          '${ApiService.baseUrl}/auth/forgot-password'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'email': email,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 404) {
      throw Exception(
          'E-mail não encontrado.');
    }

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao redefinir senha.');
    }
  }
}
