import 'dart:convert';

import 'api_service.dart';

class CategorySummary {
  final String categoryId;
  final String categoryName;
  final double totalCurrentMonth;
  final double totalLastMonth;

  CategorySummary({
    required this.categoryId,
    required this.categoryName,
    required this.totalCurrentMonth,
    required this.totalLastMonth,
  });

  factory CategorySummary.fromJson(
      Map<String, dynamic> json) {
    return CategorySummary(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      totalCurrentMonth:
          (json['totalCurrentMonth'] ?? 0).toDouble(),
      totalLastMonth:
          (json['totalLastMonth'] ?? 0).toDouble(),
    );
  }
}

class CategoryProductItem {
  final String productId;
  final String productName;
  final double quantity;
  final double totalPrice;

  CategoryProductItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
  });

  factory CategoryProductItem.fromJson(
      Map<String, dynamic> json) {
    return CategoryProductItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }
}

class CategoryProductsData {
  final String categoryId;
  final String categoryName;
  final List<CategoryProductItem> currentMonth;
  final List<CategoryProductItem> lastMonth;

  CategoryProductsData({
    required this.categoryId,
    required this.categoryName,
    required this.currentMonth,
    required this.lastMonth,
  });

  factory CategoryProductsData.fromJson(
      Map<String, dynamic> json) {
    return CategoryProductsData(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      currentMonth: (json['currentMonth'] as List)
          .map((e) =>
              CategoryProductItem.fromJson(e))
          .toList(),
      lastMonth: (json['lastMonth'] as List)
          .map((e) =>
              CategoryProductItem.fromJson(e))
          .toList(),
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

  Future<CategoryProductsData> getCategoryProducts(
      String categoryId) async {
    final response = await ApiService.get(
        '/dashboard/category/$categoryId/products');

    if (response.statusCode != 200) {
      throw Exception(
          'Erro ao carregar detalhes da categoria');
    }

    return CategoryProductsData.fromJson(
        jsonDecode(response.body));
  }
}
