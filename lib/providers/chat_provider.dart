import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../utils/helpers.dart';

/// Percakapan bersama: pembeli & penjual membaca data yang SAMA.
class ChatProvider extends ChangeNotifier {
  ChatProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;
  static const String _key = 'chats';

  List<ChatModel> _chats = [];

  ChatModel? byId(String id) {
    for (final c in _chats) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Chat milik [userId], diurutkan dari aktivitas terbaru.
  List<ChatModel> chatsForUser(String userId) {
    final list = _chats.where((c) => c.involves(userId)).toList();
    list.sort((a, b) => b.lastActivity.compareTo(a.lastActivity));
    return list;
  }

  /// Mengambil chat yang sudah ada, atau membuat baru.
  /// Mengembalikan null jika pembeli = penjual (tidak boleh chat ke diri sendiri).
  ChatModel? getOrCreateChat({
    required String productId,
    required String buyerId,
    required String sellerId,
  }) {
    if (buyerId == sellerId) return null;
    for (final c in _chats) {
      if (c.productId == productId &&
          c.buyerId == buyerId &&
          c.sellerId == sellerId) {
        return c;
      }
    }
    final chat = ChatModel(
      id: generateId('chat'),
      productId: productId,
      buyerId: buyerId,
      sellerId: sellerId,
      createdAt: DateTime.now(),
    );
    _chats.add(chat);
    _save();
    notifyListeners();
    return chat;
  }

  bool sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) {
    final chat = byId(chatId);
    final clean = text.trim();
    if (chat == null || clean.isEmpty || !chat.involves(senderId)) {
      return false;
    }
    chat.messages.add(MessageModel(
      id: generateId('msg'),
      chatId: chatId,
      senderId: senderId,
      text: clean,
      createdAt: DateTime.now(),
    ));
    _save();
    notifyListeners();
    return true;
  }

  void _load() {
    try {
      final raw = _prefs.getString(_key);
      if (raw == null) return;
      _chats = (jsonDecode(raw) as List)
          .map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      _chats = [];
    }
  }

  void _save() {
    _prefs.setString(_key, jsonEncode(_chats.map((c) => c.toJson()).toList()));
  }
}
