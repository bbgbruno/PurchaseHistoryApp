import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category.dart';

class CategoryService {
  final String baseUrl =
      'https://purchasehistoryapi.onrender.com/api';

  Future<List<Category>> getAll(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/categories?userId=$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar categorias');
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => Category.fromJson(e)).toList();
  }

  Future<void> create(String userId, String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'userId': userId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar categoria');
    }
  }

  Future<void> update(
      String id, String userId, String name) async {
    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar categoria');
    }
  }

  Future<void> delete(String id, String userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$id?userId=$userId'),
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir categoria');
    }
  }
}
