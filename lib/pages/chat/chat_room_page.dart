import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/message_model.dart';
import '../../models/purchase_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/purchase_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/product_image.dart';
import '../../widgets/purchase_card.dart';
import '../product/product_detail_page.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatId;

  const ChatRoomPage({super.key, required this.chatId});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final me = context.read<AuthProvider>().currentUser!;
    context.read<ChatProvider>().sendMessage(
          chatId: widget.chatId,
          senderId: me.id,
          text: text,
        );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>().byId(widget.chatId);
    if (chat == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        body: const Center(child: Text('Percakapan tidak ditemukan.')),
      );
    }

    final auth = context.watch<AuthProvider>();
    final me = auth.currentUser!;
    final isBuyer = chat.buyerId == me.id;
    final other = auth.userById(isBuyer ? chat.sellerId : chat.buyerId);
    final product = context.watch<ProductProvider>().byId(chat.productId);
    final purchase = context
        .watch<PurchaseProvider>()
        .latestFor(chat.productId, chat.buyerId);
    final canRequest = isBuyer &&
        product != null &&
        (purchase == null || purchase.status == PurchaseStatus.ditolak);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(other?.name ?? 'Chat',
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w700)),
            Text(
              product?.name ?? 'Barang dihapus',
              style: const TextStyle(fontSize: 12, color: AppColors.grey),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Bagian atas (info produk + permintaan) dibatasi tingginya agar
          // tidak menutupi daftar pesan saat keyboard terbuka.
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                children: [
                  if (product != null)
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailPage(productId: product.id),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.ivory,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ProductImage(
                                imageKey: product.imageKey,
                                width: 44,
                                height: 44,
                                iconSize: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                    formatRupiah(product.price),
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: AppColors.grey),
                          ],
                        ),
                      ),
                    ),
                  if (purchase != null) ...[
                    const SizedBox(height: 8),
                    PurchaseCard(purchase: purchase),
                  ],
                  if (canRequest) ...[
                    const SizedBox(height: 8),
                    CustomButton(
                      label: 'Ajukan Pembelian',
                      icon: Icons.shopping_bag_outlined,
                      onPressed: () =>
                          showRequestPurchaseDialog(context, product),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            child: chat.messages.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada pesan. Mulai percakapan!',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: chat.messages.length,
                    itemBuilder: (context, i) {
                      final m = chat.messages[chat.messages.length - 1 - i];
                      return _Bubble(message: m, isMine: m.senderId == me.id);
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              color: AppColors.ivory,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan...',
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;

  const _Bubble({required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : AppColors.ivory,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          border: isMine ? null : Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMine ? Colors.white : AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatTime(message.createdAt),
              style: TextStyle(
                fontSize: 10,
                color: isMine ? Colors.white70 : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
