import 'package:flutter/material.dart';

/// Membuat ID unik sederhana berbasis waktu.
String generateId(String prefix) =>
    '${prefix}_${DateTime.now().microsecondsSinceEpoch}';

/// 150000 -> Rp150.000
String formatRupiah(int value) {
  final s = value.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp$b';
}

String _two(int n) => n.toString().padLeft(2, '0');

String formatTime(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';

String formatDateTime(DateTime d) =>
    '${_two(d.day)}/${_two(d.month)}/${d.year} ${formatTime(d)}';

/// Pilihan "gambar" produk (tanpa file asset / izin galeri).
class ProductImageOption {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  const ProductImageOption({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });
}

const List<ProductImageOption> kImageOptions = [
  ProductImageOption(
      key: 'headphones',
      label: 'Headphone',
      icon: Icons.headphones,
      color: Color(0xFFD7B899)),
  ProductImageOption(
      key: 'laptop',
      label: 'Laptop',
      icon: Icons.laptop_mac,
      color: Color(0xFFC9D1C4)),
  ProductImageOption(
      key: 'book',
      label: 'Buku',
      icon: Icons.menu_book,
      color: Color(0xFFE6CFA9)),
  ProductImageOption(
      key: 'shirt',
      label: 'Pakaian',
      icon: Icons.checkroom,
      color: Color(0xFFD9C2C2)),
  ProductImageOption(
      key: 'bike',
      label: 'Sepeda',
      icon: Icons.pedal_bike,
      color: Color(0xFFBFCFD6)),
  ProductImageOption(
      key: 'phone',
      label: 'Ponsel',
      icon: Icons.smartphone,
      color: Color(0xFFCFC3DA)),
  ProductImageOption(
      key: 'chair',
      label: 'Perabot',
      icon: Icons.chair,
      color: Color(0xFFD8C7B0)),
  ProductImageOption(
      key: 'bag',
      label: 'Tas',
      icon: Icons.shopping_bag,
      color: Color(0xFFE3D5C0)),
  ProductImageOption(
      key: 'calculator',
      label: 'Kalkulator',
      icon: Icons.calculate,
      color: Color(0xFFB9C6D6)),
  ProductImageOption(
      key: 'fan',
      label: 'Kipas',
      icon: Icons.air,
      color: Color(0xFFBFD8D2)),
  ProductImageOption(
      key: 'battery',
      label: 'Power bank',
      icon: Icons.battery_charging_full,
      color: Color(0xFFC8D6B9)),
  ProductImageOption(
      key: 'lamp',
      label: 'Lampu',
      icon: Icons.lightbulb,
      color: Color(0xFFE8D6A0)),
  ProductImageOption(
      key: 'ruler',
      label: 'Penggaris',
      icon: Icons.straighten,
      color: Color(0xFFD6BFB9)),
  ProductImageOption(
      key: 'mouse',
      label: 'Mouse',
      icon: Icons.mouse,
      color: Color(0xFFC3C9D9)),
  ProductImageOption(
      key: 'bottle',
      label: 'Botol minum',
      icon: Icons.local_drink,
      color: Color(0xFFB9D3DA)),
];

ProductImageOption imageOptionFor(String key) => kImageOptions.firstWhere(
      (o) => o.key == key,
      orElse: () => kImageOptions.first,
    );
