import 'message_model.dart';

/// Satu chat = kombinasi produk + pembeli + penjual.
class ChatModel {
  final String id;
  final String productId;
  final String buyerId;
  final String sellerId;
  final DateTime createdAt;
  final List<MessageModel> messages;

  ChatModel({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.createdAt,
    List<MessageModel>? messages,
  }) : messages = messages ?? [];

  MessageModel? get lastMessage => messages.isEmpty ? null : messages.last;

  DateTime get lastActivity => lastMessage?.createdAt ?? createdAt;

  bool involves(String userId) => buyerId == userId || sellerId == userId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'buyerId': buyerId,
        'sellerId': sellerId,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['id'] as String,
        productId: json['productId'] as String,
        buyerId: json['buyerId'] as String,
        sellerId: json['sellerId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        messages: (json['messages'] as List)
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
