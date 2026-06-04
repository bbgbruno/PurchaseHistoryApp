import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://purchasehistoryapi.onrender.com/api';

  static String? _token;

  static void setToken(String? token) {
    _token = token;
  }

  static Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Future<http.Response> get(String path) async {
    return await http.get(
      Uri.parse('$baseUrl$path'),
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
      Uri.parse('$baseUrl$path'),
      headers: _headers,
    );
  }

  static Future<http.Response> uploadFile(
      String path, String filePath, String fieldName) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$path'),
    );
    if (_token != null) {
      request.headers['Authorization'] = 'Bearer $_token';
    }
    request.files.add(await http.MultipartFile.fromPath(
        fieldName, filePath));
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  static Future<http.Response> uploadBytes(
      String path, List<int> bytes, String fileName) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$path'),
    );
    if (_token != null) {
      request.headers['Authorization'] = 'Bearer $_token';
    }
    request.files.add(http.MultipartFile.fromBytes(
        'file', bytes,
        filename: fileName));
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
