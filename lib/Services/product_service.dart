import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_search_result.dart';

import '../models/product_details.dart';

class ProductService {

  /*
  ==========================================================
  URL API
  ==========================================================
  */

  final String baseUrl =
      'http://localhost:5299/api';

  /*
  ==========================================================
  SEARCH
  ==========================================================
  */

  Future<List<ProductSearchResult>> search(
      String term) async {

    final response = await http.get(
      Uri.parse(
        '$baseUrl/products/search?term=$term',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar produtos');
    }

    final List data =
        jsonDecode(response.body);

    return data
        .map((e) =>
            ProductSearchResult.fromJson(e))
        .toList();
  }

  Future<ProductDetails> getDetails(
    String productId) async {

  final response = await http.get(
    Uri.parse(
      '$baseUrl/products/history/$productId',
    ),
  );

  final data =
      jsonDecode(response.body);

  return ProductDetails.fromJson(data);
}


}