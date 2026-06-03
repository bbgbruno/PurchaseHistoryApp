import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/purchase.dart';
import '../models/purchase_item.dart';

class PurchaseService {
  final String baseUrl =
      'https://purchasehistoryapi.onrender.com/api';

  Future<List<Purchase>> getAll({String? userId}) async {
    var url = '$baseUrl/purchases';

    if (userId != null) {
      url += '?userId=$userId';
    }

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar compras');
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => Purchase.fromJson(e))
        .toList();
  }

  Future<List<PurchaseItem>> getItems(
      String purchaseId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/purchases/$purchaseId/items'),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao carregar itens da compra');
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => PurchaseItem.fromJson(e))
        .toList();
  }

  Future<void> updateProductCategory(
      String itemId, String? categoryId) async {
    final response = await http.patch(
      Uri.parse(
          '$baseUrl/purchase-items/$itemId/product-category'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'categoryId': categoryId,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception(
          'Erro ao atualizar categoria');
    }
  }

  Future<void> delete(String purchaseId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/purchases/$purchaseId'),
    );

    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir compra');
    }
  }
}
