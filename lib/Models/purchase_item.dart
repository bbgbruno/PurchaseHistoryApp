class PurchaseItem {
  final String id;
  final String purchaseId;
  final String? productId;
  final String originalDescription;
  final String? productCode;
  final String? ncmCode;
  final String? ean;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double totalPrice;

  PurchaseItem({
    required this.id,
    required this.purchaseId,
    required this.productId,
    required this.originalDescription,
    required this.productCode,
    required this.ncmCode,
    required this.ean,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory PurchaseItem.fromJson(
      Map<String, dynamic> json) {
    return PurchaseItem(
      id: json['id'] ?? '',
      purchaseId: json['purchaseId'] ?? '',
      productId: json['productId'],
      originalDescription:
          json['originalDescription'] ?? '',
      productCode: json['productCode'],
      ncmCode: json['ncmCode'],
      ean: json['ean'],
      quantity:
          (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'],
      unitPrice:
          (json['unitPrice'] ?? 0).toDouble(),
      totalPrice:
          (json['totalPrice'] ?? 0).toDouble(),
    );
  }
}
