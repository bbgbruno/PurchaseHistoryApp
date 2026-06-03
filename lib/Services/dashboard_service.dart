import 'dart:convert';

import 'package:http/http.dart' as http;

class CategorySummary {
  final String categoryName;
  final double totalSpent;

  CategorySummary({
    required this.categoryName,
    required this.totalSpent,
  });

  factory CategorySummary.fromJson(
      Map<String, dynamic> json) {
    return CategorySummary(
      categoryName: json['categoryName'] ?? '',
      totalSpent:
          (json['totalSpent'] ?? 0).toDouble(),
    );
  }
}

class DashboardData {
  final double totalCurrentMonth;
  final double totalLastMonth;
  final List<CategorySummary> categories;

  DashboardData({
    required this.totalCurrentMonth,
    required this.totalLastMonth,
    required this.categories,
  });

  factory DashboardData.fromJson(
      Map<String, dynamic> json) {
    return DashboardData(
      totalCurrentMonth:
          (json['totalCurrentMonth'] ?? 0).toDouble(),
      totalLastMonth:
          (json['totalLastMonth'] ?? 0).toDouble(),
      categories: (json['categories'] as List)
          .map((e) =>
              CategorySummary.fromJson(e))
          .toList(),
    );
  }
}

class DashboardService {
  final String baseUrl =
      'https://purchasehistoryapi.onrender.com/api';

  Future<DashboardData> get(String userId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/dashboard?userId=$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao carregar dashboard');
    }

    return DashboardData.fromJson(
        jsonDecode(response.body));
  }
}
