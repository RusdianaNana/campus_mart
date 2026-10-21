enum PurchaseStatus { menunggu, diterima, ditolak }

extension PurchaseStatusX on PurchaseStatus {
  String get label {
    switch (this) {
      case PurchaseStatus.menunggu:
        return 'Menunggu';
      case PurchaseStatus.diterima:
        return 'Diterima';
      case PurchaseStatus.ditolak:
        return 'Ditolak';
    }
  }
}

class PurchaseModel {
  final String id;
  final String productId;
  final String productName; // salinan agar tetap tampil jika produk dihapus
  final int productPrice;
  final String buyerId;
  final String sellerId;
  final PurchaseStatus status;
  final DateTime createdAt;

  const PurchaseModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.buyerId,
    required this.sellerId,
    required this.status,
    required this.createdAt,
  });

  PurchaseModel copyWith({PurchaseStatus? status}) => PurchaseModel(
        id: id,
        productId: productId,
        productName: productName,
        productPrice: productPrice,
        buyerId: buyerId,
        sellerId: sellerId,
        status: status ?? this.status,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'productName': productName,
        'productPrice': productPrice,
        'buyerId': buyerId,
        'sellerId': sellerId,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        id: json['id'] as String,
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        productPrice: json['productPrice'] as int,
        buyerId: json['buyerId'] as String,
        sellerId: json['sellerId'] as String,
        status: PurchaseStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => PurchaseStatus.menunggu,
        ),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
