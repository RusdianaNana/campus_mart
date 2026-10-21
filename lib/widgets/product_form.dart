import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import 'category_item.dart';
import 'custom_button.dart';

typedef ProductFormSubmit = void Function(
  String name,
  String description,
  int price,
  String category,
  String imageKey,
);

/// Form produk yang dipakai bersama oleh halaman Tambah dan Edit.
/// State lokal (kategori, gambar terpilih) dikelola dengan setState (Modul 4).
class ProductForm extends StatefulWidget {
  final ProductModel? initial;
  final String submitLabel;
  final ProductFormSubmit onSubmit;

  const ProductForm({
    super.key,
    this.initial,
    required this.submitLabel,
    required this.onSubmit,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late String _category;
  late String _imageKey;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _priceCtrl = TextEditingController(text: p == null ? '' : '${p.price}');
    _category = p?.category ?? kCategories.first;
    _imageKey = p?.imageKey ?? kImageOptions.first.key;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      _nameCtrl.text.trim(),
      _descCtrl.text.trim(),
      int.parse(_priceCtrl.text),
      _category,
      _imageKey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Gambar Barang',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: kImageOptions.map((o) {
              final selected = o.key == _imageKey;
              return GestureDetector(
                onTap: () => setState(() => _imageKey = o.key),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: o.color,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? AppColors.primaryDark : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: Icon(o.icon, color: Colors.white, size: 30),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Nama barang'),
            validator: (v) => (v == null || v.trim().length < 3)
                ? 'Nama barang minimal 3 karakter'
                : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _descCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Deskripsi',
              alignLabelWithHint: true,
            ),
            validator: (v) => (v == null || v.trim().length < 10)
                ? 'Deskripsi minimal 10 karakter'
                : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Harga',
              prefixText: 'Rp ',
            ),
            validator: (v) {
              final price = int.tryParse(v ?? '');
              if (price == null || price <= 0) {
                return 'Harga harus lebih dari 0';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const Text('Kategori',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kCategories
                .map((c) => CategoryItem(
                      label: c,
                      selected: c == _category,
                      onTap: () => setState(() => _category = c),
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),
          CustomButton(
            label: widget.submitLabel,
            icon: Icons.save,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
