class ProductSearchResult {

  final String productId;

  final String productName;

  final String storeName;

  final String? purchaseDate;

  final double unitPrice;

  final double totalPrice;

  final double quantity;

  ProductSearchResult({
    required this.productId,
    required this.productName,
    required this.storeName,
    required this.purchaseDate,
    required this.unitPrice,
    required this.totalPrice,
    required this.quantity,
  });

  factory ProductSearchResult.fromJson(
      Map<String, dynamic> json) {

    return ProductSearchResult(

      productId:
          json['productId'] ?? '',

      productName:
          json['productName'] ?? '',

      storeName:
          json['storeName'] ?? '',

      purchaseDate:
          json['purchaseDate'],

      unitPrice:
          (json['unitPrice'] ?? 0)
              .toDouble(),

      totalPrice:
          (json['totalPrice'] ?? 0)
              .toDouble(),

      quantity:
          (json['quantity'] ?? 0)
              .toDouble(),
    );
  }
}