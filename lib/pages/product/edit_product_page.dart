import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_form.dart';

class EditProductPage extends StatelessWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Barang')),
      body: ProductForm(
        initial: product,
        submitLabel: 'Simpan Perubahan',
        onSubmit: (name, description, price, category, imageKey) {
          context.read<ProductProvider>().updateProduct(
                product.copyWith(
                  name: name,
                  description: description,
                  price: price,
                  category: category,
                  imageKey: imageKey,
                ),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perubahan disimpan.')),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
