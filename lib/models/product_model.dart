const List<String> kCategories = [
  'Elektronik',
  'Alat Kuliah',
  'Buku',
  'Pakaian',
  'Perabot',
  'Lainnya',
];

class ProductModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final String category;
  final String imageKey;
  final String ownerId; // identitas pemilik (UserModel.id)
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageKey,
    required this.ownerId,
    required this.createdAt,
  });

  ProductModel copyWith({
    String? name,
    String? description,
    int? price,
    String? category,
    String? imageKey,
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageKey: imageKey ?? this.imageKey,
      ownerId: ownerId,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'imageKey': imageKey,
        'ownerId': ownerId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: json['price'] as int,
        category: json['category'] as String,
        imageKey: json['imageKey'] as String,
        ownerId: json['ownerId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
