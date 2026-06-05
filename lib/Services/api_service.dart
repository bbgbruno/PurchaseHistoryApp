import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://purchasehistoryapi.onrender.com/api';

  static String? _userId;

  static void setUserId(String? userId) {
    _userId = userId;
  }

  static String? get userId => _userId;

  static String _withUser(String path) {
    if (_userId == null) return path;
    final separator = path.contains('?') ? '&' : '?';
    return '$path${separator}userId=$_userId';
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  static Future<http.Response> get(String path) async {
    return await http.get(
      Uri.parse('$baseUrl${_withUser(path)}'),
      headers: _headers,
    );
  }

  static Future<http.Response> post(
      String path, Map<String, dynamic> body) async {
    return await http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
      String path, Map<String, dynamic> body) async {
    return await http.put(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> patch(
      String path, Map<String, dynamic> body) async {
    return await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String path) async {
    return await http.delete(
      Uri.parse('$baseUrl${_withUser(path)}'),
      headers: _headers,
    );
  }
}
