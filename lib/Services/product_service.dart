import 'dart:convert';

import '../models/product_search_result.dart';
import '../models/product_details.dart';
import 'api_service.dart';

class ProductService {
  Future<List<ProductSearchResult>> search(
      String term) async {
    final response = await ApiService.get(
        '/products/search?term=$term');

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar produtos');
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) =>
            ProductSearchResult.fromJson(e))
        .toList();
  }

  Future<ProductDetails> getDetails(
      String productId) async {
    final response = await ApiService.get(
        '/products/history/$productId');

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao carregar detalhes');
    }

    final data = jsonDecode(response.body);

    return ProductDetails.fromJson(data);
  }
}
