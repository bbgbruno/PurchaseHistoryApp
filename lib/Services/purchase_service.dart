import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/purchase.dart';

class PurchaseService {
  final String baseUrl =
      'https://purchasehistoryapi.onrender.com/api';

  Future<List<Purchase>> getAll() async {
    final response = await http.get(
      Uri.parse('$baseUrl/purchases'),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar compras');
    }

    final List data = jsonDecode(response.body);

    return data
        .map((e) => Purchase.fromJson(e))
        .toList();
  }
}
