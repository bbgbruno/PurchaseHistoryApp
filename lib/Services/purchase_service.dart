import 'dart:convert';

import '../models/purchase.dart';
import '../models/purchase_item.dart';
import 'api_service.dart';

class PurchaseService {
  Future<List<Purchase>> getAll() async {
    final response = await ApiService.get('/purchases');

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
    final response = await ApiService.get(
        '/purchases/$purchaseId/items');

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
    final response = await ApiService.patch(
      '/purchase-items/$itemId/product-category',
      {'categoryId': categoryId},
    );

    if (response.statusCode != 204) {
      throw Exception(
          'Erro ao atualizar categoria');
    }
  }

  Future<void> delete(String purchaseId) async {
    final response = await ApiService.delete(
        '/purchases/$purchaseId');

    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir compra');
    }
  }
}
