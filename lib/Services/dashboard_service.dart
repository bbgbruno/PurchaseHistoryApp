import 'dart:convert';

import 'api_service.dart';

class CategorySummary {
  final String categoryName;
  final double totalCurrentMonth;
  final double totalLastMonth;

  CategorySummary({
    required this.categoryName,
    required this.totalCurrentMonth,
    required this.totalLastMonth,
  });

  factory CategorySummary.fromJson(
      Map<String, dynamic> json) {
    return CategorySummary(
      categoryName: json['categoryName'] ?? '',
      totalCurrentMonth:
          (json['totalCurrentMonth'] ?? 0).toDouble(),
      totalLastMonth:
          (json['totalLastMonth'] ?? 0).toDouble(),
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
  Future<DashboardData> get() async {
    final response = await ApiService.get('/dashboard');

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao carregar dashboard');
    }

    return DashboardData.fromJson(
        jsonDecode(response.body));
  }
}
