class ProductHistoryItem {

  final String storeName;

  final String? purchaseDate;

  final double unitPrice;

  ProductHistoryItem({
    required this.storeName,
    required this.purchaseDate,
    required this.unitPrice,
  });

  factory ProductHistoryItem.fromJson(
      Map<String, dynamic> json) {

    return ProductHistoryItem(
      storeName:
          json['storeName'] ?? '',

      purchaseDate:
          json['purchaseDate'],

      unitPrice:
          (json['unitPrice'] ?? 0)
              .toDouble(),
    );
  }
}

class ProductDetails {

  final String productName;

  final double lowestPrice;

  final double highestPrice;

  final double averagePrice;

  final List<ProductHistoryItem> history;

  ProductDetails({
    required this.productName,
    required this.lowestPrice,
    required this.highestPrice,
    required this.averagePrice,
    required this.history,
  });

  factory ProductDetails.fromJson(
      Map<String, dynamic> json) {

    return ProductDetails(

      productName:
          json['productName'] ?? '',

      lowestPrice:
          (json['lowestPrice'] ?? 0)
              .toDouble(),

      highestPrice:
          (json['highestPrice'] ?? 0)
              .toDouble(),

      averagePrice:
          (json['averagePrice'] ?? 0)
              .toDouble(),

      history:
          (json['history'] as List)
              .map((e) =>
                  ProductHistoryItem
                      .fromJson(e))
              .toList(),
    );
  }
}