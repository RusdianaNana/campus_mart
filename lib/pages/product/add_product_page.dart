import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_form.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: ProductForm(
        submitLabel: 'Simpan Barang',
        onSubmit: (name, description, price, category, imageKey) {
          final me = context.read<AuthProvider>().currentUser!;
          context.read<ProductProvider>().addProduct(
                name: name,
                description: description,
                price: price,
                category: category,
                imageKey: imageKey,
                ownerId: me.id,
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Barang berhasil disimpan.')),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
