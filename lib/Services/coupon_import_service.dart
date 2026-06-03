import 'dart:convert';

import 'package:http/http.dart' as http;

class CouponImportService {
  final String baseUrl =
      'https://purchasehistoryapi.onrender.com/api';

  Future<void> submit(
      String userId, String accessKey) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cupons/imports'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'accessKey': accessKey,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao salvar chave.');
    }
  }
}
