import 'package:flutter/material.dart';

import '../utils/helpers.dart';

/// Menampilkan foto (jika imageKey berupa path assets) atau ikon berwarna.
class ProductImage extends StatelessWidget {
  final String imageKey;
  final double? width;
  final double? height;
  final double iconSize;

  const ProductImage({
    super.key,
    required this.imageKey,
    this.width,
    this.height,
    this.iconSize = 56,
  });

  Widget _iconVersion() {
    final option = imageOptionFor(imageKey);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(option.color, Colors.white, 0.45)!,
            option.color,
          ],
        ),
      ),
      child: Center(
        child: Icon(option.icon, size: iconSize, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageKey.startsWith('assets/')) {
      return SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          imageKey,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _iconVersion(),
        ),
      );
    }
    return _iconVersion();
  }
}