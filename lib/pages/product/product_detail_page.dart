import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../models/purchase_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/purchase_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_image.dart';
import '../../widgets/purchase_card.dart';
import '../chat/chat_room_page.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  void _openChat(BuildContext context, ProductModel product, String myId) {
    final chat = context.read<ChatProvider>().getOrCreateChat(
          productId: product.id,
          buyerId: myId,
          sellerId: product.ownerId,
        );
    if (chat == null) return; // pembeli = penjual, tidak boleh
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatRoomPage(chatId: chat.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductProvider>().byId(productId);
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Barang')),
        body: const Center(child: Text('Barang tidak tersedia.')),
      );
    }

    final auth = context.watch<AuthProvider>();
    final me = auth.currentUser!;
    final seller = auth.userById(product.ownerId);
    final isOwner = product.ownerId == me.id;
    final purchases = context.watch<PurchaseProvider>();
    final myPurchase = purchases.latestFor(product.id, me.id);
    final ownerRequests =
        isOwner ? purchases.forProduct(product.id) : <PurchaseModel>[];

    final status = myPurchase?.status;
    final canRequest = status == null || status == PurchaseStatus.ditolak;
    final requestLabel = status == PurchaseStatus.menunggu
        ? 'Menunggu Keputusan'
        : status == PurchaseStatus.diterima
            ? 'Permintaan Diterima'
            : 'Ajukan Pembelian';

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Barang')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ProductImage(
                  imageKey: product.imageKey,
                  height: 260,
                  width: double.infinity,
                  iconSize: 96,
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: FavoriteButton(productId: product.id),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatRupiah(product.price),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.ivory,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Text(product.category,
                        style: const TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Deskripsi',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(product.description,
                      style: const TextStyle(height: 1.4)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.ivory,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text(
                            (seller?.name ?? '?')[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                seller?.name ?? '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Penjual',
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isOwner) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Ini adalah barang Anda.',
                      style: TextStyle(color: AppColors.grey),
                    ),
                    if (ownerRequests.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text('Permintaan Pembelian',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      for (final r in ownerRequests) ...[
                        PurchaseCard(purchase: r),
                        const SizedBox(height: 10),
                      ],
                    ],
                  ] else if (myPurchase != null) ...[
                    const SizedBox(height: 16),
                    PurchaseCard(purchase: myPurchase),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isOwner
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: 'Chat Penjual',
                        icon: Icons.chat_bubble_outline,
                        outlined: true,
                        onPressed: () => _openChat(context, product, me.id),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        label: requestLabel,
                        icon: Icons.shopping_bag_outlined,
                        onPressed: canRequest
                            ? () => showRequestPurchaseDialog(context, product)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
