import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import '../utils/helpers.dart';

/// Katalog produk bersama untuk SEMUA akun.
class ProductProvider extends ChangeNotifier {
  ProductProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;
  static const String _key = 'products';

  List<ProductModel> _products = []; // terbaru di urutan pertama

  List<ProductModel> get products => List.unmodifiable(_products);

  ProductModel? byId(String id) {
    for (final p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<ProductModel> byOwner(String ownerId) =>
      _products.where((p) => p.ownerId == ownerId).toList();

  List<ProductModel> search({String query = '', String category = 'Semua'}) {
    final q = query.trim().toLowerCase();
    return _products.where((p) {
      final okCategory = category == 'Semua' || p.category == category;
      final okQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
      return okCategory && okQuery;
    }).toList();
  }

  void addProduct({
    required String name,
    required String description,
    required int price,
    required String category,
    required String imageKey,
    required String ownerId,
  }) {
    _products.insert(
      0,
      ProductModel(
        id: generateId('prod'),
        name: name,
        description: description,
        price: price,
        category: category,
        imageKey: imageKey,
        ownerId: ownerId,
        createdAt: DateTime.now(),
      ),
    );
    _save();
    notifyListeners();
  }

  void updateProduct(ProductModel updated) {
    final i = _products.indexWhere((p) => p.id == updated.id);
    if (i == -1) return;
    _products[i] = updated;
    _save();
    notifyListeners();
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    _save();
    notifyListeners();
  }

  void _load() {
    try {
      final raw = _prefs.getString(_key);
      if (raw == null) {
        // Pertama kali dijalankan: isi katalog dengan barang contoh.
        _products = _seedProducts();
        _save();
        return;
      }
      _products = (jsonDecode(raw) as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      _products = [];
    }
  }

  void _save() {
    _prefs.setString(
        _key, jsonEncode(_products.map((p) => p.toJson()).toList()));
  }

  /// Barang contoh. u1 = penjual, u2 = pembeli (lihat AuthProvider.demoUsers).
  List<ProductModel> _seedProducts() {
    final now = DateTime.now();
    ProductModel item(int i, String name, String desc, int price,
        String category, String imageKey, String ownerId) {
      return ProductModel(
        id: 'seed_$i',
        name: name,
        description: desc,
        price: price,
        category: category,
        imageKey: imageKey,
        ownerId: ownerId,
        createdAt: now.subtract(Duration(hours: i)),
      );
    }

    return [
      item(1, 'Kalkulator Scientific Casio fx-991',
          'Kalkulator ilmiah, kondisi mulus, baterai baru. Cocok untuk kuliah teknik dan statistik.',
          180000, 'Alat Kuliah', 'assets/kalkulator.jpeg', 'u1'),
      item(2, 'Kipas Portabel USB',
          'Kipas genggam isi ulang via USB, 3 tingkat kecepatan. Pemakaian 5 bulan, masih kencang.',
          45000, 'Elektronik', 'assets/kipas.jpeg', 'u1'),
      item(3, 'Power Bank 10.000 mAh',
          'Power bank dua port USB, sehat dan tidak menggembung. Termasuk kabel pengisi.',
          110000, 'Elektronik', 'assets/powerbank.jpeg', 'u2'),
      item(4, 'Mouse Wireless',
          'Mouse nirkabel dengan receiver USB, klik masih empuk. Baterai AA belum termasuk.',
          50000, 'Elektronik', 'assets/mouse.jpeg', 'u1'),
      item(5, 'Penggaris dan Set Gambar Teknik',
          'Satu set penggaris, busur, dan jangka untuk mata kuliah gambar teknik. Lengkap.',
          40000, 'Alat Kuliah', 'assets/penggaris.jpeg', 'u2'),
      item(6, 'Buku Kalkulus Edisi 9',
          'Buku teks Kalkulus, ada sedikit coretan pensil di beberapa halaman. Sampul utuh.',
          75000, 'Buku', 'assets/kalkulus.jpeg', 'u2'),
      item(7, 'Buku Pemrograman Dart dan Flutter',
          'Buku panduan Flutter untuk pemula, bersih tanpa coretan. Cocok untuk belajar mandiri.',
          65000, 'Buku', 'assets/bukuflutter.jpeg', 'u1'),
      item(8, 'Jaket Almamater Ukuran L',
          'Jaket almamater ukuran L, bahan tebal, resleting lancar. Dipakai satu semester.',
          90000, 'Pakaian', 'assets/alma.jpeg', 'u2'),
      item(9, 'Lampu Belajar LED',
          'Lampu meja LED dengan leher fleksibel dan tiga tingkat terang. Hemat listrik.',
          55000, 'Perabot', 'assets/lampu.jpeg', 'u1'),
      item(10, 'Kursi Lipat Belajar',
          'Kursi lipat ringan, mudah disimpan di kamar kos. Rangka kokoh, dudukan masih bagus.',
          85000, 'Perabot', 'assets/kursi.jpeg', 'u2'),
      item(11, 'Tas Ransel Laptop',
          'Tas ransel muat laptop 15 inci dengan banyak kantong. Ada sedikit noda di bagian bawah.',
          120000, 'Lainnya', 'assets/tas.jpeg', 'u1'),
      item(12, 'Botol Minum Tumbler 750 ml',
          'Tumbler stainless tahan panas dan dingin, tutup rapat tidak bocor.',
          35000, 'Lainnya', 'assets/tumbler.jpeg', 'u2'),
    ];
  }
}