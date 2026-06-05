import 'dart:convert';

import '../models/category.dart';
import 'api_service.dart';

class CategoryService {
  Future<List<Category>> getAll() async {
    final response =
        await ApiService.get('/categories');

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao carregar categorias');
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => Category.fromJson(e))
        .toList();
  }

  Future<void> create(String name) async {
    final response = await ApiService.post(
        '/categories', {'name': name, 'userId': ApiService.userId});

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar categoria');
    }
  }

  Future<void> update(
      String id, String name) async {
    final response = await ApiService.put(
        '/categories/$id', {'name': name, 'userId': ApiService.userId});

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao atualizar categoria');
    }
  }

  Future<void> delete(String id) async {
    final response =
        await ApiService.delete('/categories/$id');

    if (response.statusCode != 204) {
      throw Exception(
          'Erro ao excluir categoria');
    }
  }
}
