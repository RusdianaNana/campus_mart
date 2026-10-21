import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final me = context.watch<AuthProvider>().currentUser;
    final ids = me == null
        ? <String>[]
        : context.watch<FavoriteProvider>().favoriteIdsOf(me.id);
    final productProvider = context.watch<ProductProvider>();
    final products = <ProductModel>[];
    for (final id in ids) {
      final p = productProvider.byId(id);
      if (p != null) products.add(p);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: ProductGrid(
        products: products,
        emptyMessage: 'Belum ada barang favorit.\n'
            'Tekan ikon hati pada barang untuk menyimpannya.',
      ),
    );
  }
}
