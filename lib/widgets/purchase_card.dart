import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/purchase_provider.dart';
import '../theme/app_theme.dart';
import '../utils/helpers.dart';
import 'custom_button.dart';

Color statusColor(PurchaseStatus s) {
  switch (s) {
    case PurchaseStatus.menunggu:
      return AppColors.waiting;
    case PurchaseStatus.diterima:
      return AppColors.accepted;
    case PurchaseStatus.ditolak:
      return AppColors.rejected;
  }
}

IconData statusIcon(PurchaseStatus s) {
  switch (s) {
    case PurchaseStatus.menunggu:
      return Icons.hourglass_top;
    case PurchaseStatus.diterima:
      return Icons.check_circle;
    case PurchaseStatus.ditolak:
      return Icons.cancel;
  }
}

/// Label status dengan warna konsisten.
class StatusBadge extends StatelessWidget {
  final PurchaseStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final c = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon(status), size: 14, color: c),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: c,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog konfirmasi lalu membuat permintaan pembelian (dipakai di detail & chat).
Future<void> showRequestPurchaseDialog(
  BuildContext context,
  ProductModel product,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Ajukan Pembelian'),
      content: Text(
        'Ajukan pembelian "${product.name}" seharga '
        '${formatRupiah(product.price)}?\n\n',       
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Ajukan'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  final me = context.read<AuthProvider>().currentUser!;
  final error = context
      .read<PurchaseProvider>()
      .requestPurchase(product: product, buyerId: me.id);

  if (error == null) {
    // Pastikan percakapan ada agar penjual bisa menemukannya di menu Chat.
    context.read<ChatProvider>().getOrCreateChat(
          productId: product.id,
          buyerId: me.id,
          sellerId: product.ownerId,
        );
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error ?? 'Permintaan pembelian berhasil diajukan.'),
    ),
  );
}

/// Kartu permintaan pembelian. Tombol Terima/Tolak hanya muncul untuk
/// penjual produk tersebut dan hanya saat status masih Menunggu.
class PurchaseCard extends StatelessWidget {
  final PurchaseModel purchase;

  const PurchaseCard({super.key, required this.purchase});

  void _decide(BuildContext context, String sellerId, bool accept) {
    final ok = context.read<PurchaseProvider>().decide(
          purchaseId: purchase.id,
          sellerId: sellerId,
          accept: accept,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? (accept ? 'Permintaan diterima.' : 'Permintaan ditolak.')
              : 'Permintaan tidak dapat diproses.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final me = auth.currentUser;
    final buyer = auth.userById(purchase.buyerId);
    final seller = auth.userById(purchase.sellerId);
    final isSeller = me?.id == purchase.sellerId;
    final isBuyer = me?.id == purchase.buyerId;
    final canDecide = isSeller && purchase.status == PurchaseStatus.menunggu;

    String? note;
    if (isBuyer && purchase.status == PurchaseStatus.diterima) {
      note = 'Penjual menerima permintaan Anda. Atur pertemuan lewat chat.';
    } else if (isBuyer && purchase.status == PurchaseStatus.ditolak) {
      note = 'Penjual menolak permintaan ini.';
    } else if (isBuyer && purchase.status == PurchaseStatus.menunggu) {
      note = 'Menunggu keputusan penjual.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor(purchase.status).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Permintaan Pembelian',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              StatusBadge(status: purchase.status),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            purchase.productName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            formatRupiah(purchase.productPrice),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pembeli: ${buyer?.name ?? '-'}  |  Penjual: ${seller?.name ?? '-'}',
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          Text(
            'Diajukan: ${formatDateTime(purchase.createdAt)}',
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          if (note != null) ...[
            const SizedBox(height: 8),
            Text(
              note,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor(purchase.status),
              ),
            ),
          ],
          if (canDecide) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Tolak',
                    outlined: true,
                    color: AppColors.rejected,
                    icon: Icons.close,
                    onPressed: () => _decide(context, me!.id, false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: 'Terima',
                    color: AppColors.accepted,
                    icon: Icons.check,
                    onPressed: () => _decide(context, me!.id, true),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
