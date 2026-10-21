import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/purchase_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/helpers.dart';
import '../../widgets/purchase_card.dart';
import 'chat_room_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final me = auth.currentUser!;
    final products = context.watch<ProductProvider>();
    final purchases = context.watch<PurchaseProvider>();

    // Tampilkan chat yang sudah berisi pesan atau punya permintaan pembelian.
    final chats = context
        .watch<ChatProvider>()
        .chatsForUser(me.id)
        .where((c) =>
            c.messages.isNotEmpty ||
            purchases.latestFor(c.productId, c.buyerId) != null)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: chats.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  'Belum ada percakapan.\n'
                  'Buka detail barang lalu tekan "Chat Penjual".',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: chats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final chat = chats[i];
                final otherId =
                    chat.buyerId == me.id ? chat.sellerId : chat.buyerId;
                final other = auth.userById(otherId);
                final product = products.byId(chat.productId);
                final purchase =
                    purchases.latestFor(chat.productId, chat.buyerId);
                final last = chat.lastMessage;

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomPage(chatId: chat.id),
                    ),
                  ),
                  child: Container(
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
                            (other?.name ?? '?')[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                other?.name ?? '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                product?.name ?? 'Barang dihapus',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                last?.text ?? 'Permintaan pembelian diajukan',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13, color: AppColors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formatTime(chat.lastActivity),
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.grey),
                            ),
                            if (purchase != null) ...[
                              const SizedBox(height: 6),
                              StatusBadge(status: purchase.status),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
