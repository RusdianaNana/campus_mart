import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../utils/helpers.dart';

/// Permintaan pembelian + status (Menunggu / Diterima / Ditolak).
class PurchaseProvider extends ChangeNotifier {
  PurchaseProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;
  static const String _key = 'purchases';

  List<PurchaseModel> _purchases = [];

  /// Permintaan terbaru milik pembeli untuk produk tertentu.
  PurchaseModel? latestFor(String productId, String buyerId) {
    PurchaseModel? result;
    for (final p in _purchases) {
      if (p.productId == productId && p.buyerId == buyerId) {
        if (result == null || p.createdAt.isAfter(result.createdAt)) {
          result = p;
        }
      }
    }
    return result;
  }

  List<PurchaseModel> forProduct(String productId) {
    final list = _purchases.where((p) => p.productId == productId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// Mengembalikan pesan error, atau null jika berhasil.
  String? requestPurchase({
    required ProductModel product,
    required String buyerId,
  }) {
    if (product.ownerId == buyerId) {
      return 'Anda tidak dapat membeli barang milik sendiri.';
    }
    final last = latestFor(product.id, buyerId);
    if (last != null && last.status == PurchaseStatus.menunggu) {
      return 'Permintaan sebelumnya masih menunggu keputusan penjual.';
    }
    if (last != null && last.status == PurchaseStatus.diterima) {
      return 'Permintaan pembelian Anda sudah diterima penjual.';
    }
    _purchases.add(PurchaseModel(
      id: generateId('buy'),
      productId: product.id,
      productName: product.name,
      productPrice: product.price,
      buyerId: buyerId,
      sellerId: product.ownerId,
      status: PurchaseStatus.menunggu,
      createdAt: DateTime.now(),
    ));
    _save();
    notifyListeners();
    return null;
  }

  /// Hanya penjual produk yang boleh memutuskan, dan hanya saat masih Menunggu.
  bool decide({
    required String purchaseId,
    required String sellerId,
    required bool accept,
  }) {
    final i = _purchases.indexWhere((p) => p.id == purchaseId);
    if (i == -1) return false;
    final p = _purchases[i];
    if (p.sellerId != sellerId || p.status != PurchaseStatus.menunggu) {
      return false;
    }
    _purchases[i] = p.copyWith(
      status: accept ? PurchaseStatus.diterima : PurchaseStatus.ditolak,
    );
    _save();
    notifyListeners();
    return true;
  }

  void _load() {
    try {
      final raw = _prefs.getString(_key);
      if (raw == null) return;
      _purchases = (jsonDecode(raw) as List)
          .map((e) => PurchaseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      _purchases = [];
    }
  }

  void _save() {
    _prefs.setString(
        _key, jsonEncode(_purchases.map((p) => p.toJson()).toList()));
  }
}
