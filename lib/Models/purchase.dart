class Purchase {
  final String id;
  final String? purchaseDate;
  final double totalValue;
  final String storeName;

  Purchase({
    required this.id,
    required this.purchaseDate,
    required this.totalValue,
    required this.storeName,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'] ?? '',
      purchaseDate: json['purchaseDate'],
      totalValue: (json['totalValue'] ?? 0).toDouble(),
      storeName: json['storeName'] ?? '',
    );
  }
}
