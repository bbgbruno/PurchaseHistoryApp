class Purchase {
  final String id;
  final String? purchaseDate;
  final double totalValue;
  final String storeName;
  final int totalItems;
  final int categorizedItems;

  Purchase({
    required this.id,
    required this.purchaseDate,
    required this.totalValue,
    required this.storeName,
    required this.totalItems,
    required this.categorizedItems,
  });

  bool get isFullyCategorized =>
      totalItems > 0 && totalItems == categorizedItems;

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'] ?? '',
      purchaseDate: json['purchaseDate'],
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      storeName: json['storeName'] ?? '',
      totalItems: json['totalItems'] ?? 0,
      categorizedItems: json['categorizedItems'] ?? 0,
    );
  }
}
