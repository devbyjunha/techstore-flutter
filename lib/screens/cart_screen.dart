import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/products.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/primary_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    if (store.cart.isEmpty) {
      return AppScaffold(
        body: _EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: '장바구니가 비어있습니다',
          subtitle: '아직 장바구니에 담은 상품이 없어요.\n마음에 드는 상품을 찾아보세요!',
          primaryLabel: '상품 둘러보기',
          onPrimary: () => context.go('/'),
        ),
      );
    }

    final totalPrice = store.cart.fold<int>(0, (sum, item) => sum + item.product.price * item.quantity);
    final totalItems = store.cartItemCount;

    return AppScaffold(
      body: PageContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BackLink(onTap: () => context.go('/')),
              const Text('장바구니', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text('총 $totalItems개의 상품이 담겨있습니다', style: const TextStyle(color: AppColors.slate600)),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 1024;
                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _CartList(store: store)),
                            const SizedBox(width: 32),
                            SizedBox(width: 360, child: _OrderSummary(totalItems: totalItems, totalPrice: totalPrice, onClear: store.clearCart)),
                          ],
                        )
                      : Column(
                          children: [
                            _CartList(store: store),
                            const SizedBox(height: 24),
                            _OrderSummary(totalItems: totalItems, totalPrice: totalPrice, onClear: store.clearCart),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  final StoreProvider store;

  const _CartList({required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...store.cart.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(imageUrl: item.product.image, width: 96, height: 96, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(item.product.category, style: const TextStyle(fontSize: 13, color: AppColors.slate500)),
                        Text('${formatPrice(item.product.price)}원',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _QtyButton(icon: Icons.remove, onTap: () {
                        store.updateCartQuantity(item.product.id, item.quantity - 1);
                        store.addToast(type: ToastType.info, message: item.quantity <= 1 ? '상품이 장바구니에서 제거되었습니다.' : '수량이 업데이트되었습니다.');
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      _QtyButton(icon: Icons.add, onTap: () {
                        store.updateCartQuantity(item.product.id, item.quantity + 1);
                        store.addToast(type: ToastType.success, message: '수량이 업데이트되었습니다.', durationMs: 1500);
                      }),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${formatPrice(item.product.price * item.quantity)}원',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.rose500, size: 20),
                        onPressed: () {
                          store.removeFromCart(item.product.id);
                          store.addToast(type: ToastType.info, message: '상품이 장바구니에서 제거되었습니다.');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )),
        TextButton(
          onPressed: () {
            store.clearCart();
            store.addToast(type: ToastType.info, message: '장바구니가 비워졌습니다.');
          },
          child: const Text('장바구니 비우기', style: TextStyle(color: AppColors.rose600)),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(border: Border.all(color: AppColors.slate200), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final int totalItems;
  final int totalPrice;
  final VoidCallback onClear;

  const _OrderSummary({required this.totalItems, required this.totalPrice, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('주문 요약', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _SummaryRow('상품 수량', '$totalItems개'),
          _SummaryRow('상품 금액', '${formatPrice(totalPrice)}원'),
          const _SummaryRow('배송비', '무료', valueColor: AppColors.emerald500),
          const Divider(height: 24),
          _SummaryRow('총 결제금액', '${formatPrice(totalPrice)}원', bold: true),
          const SizedBox(height: 24),
          PrimaryButton(label: '주문하기', icon: Icons.credit_card, onPressed: () {}),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/'),
            child: const Text('쇼핑 계속하기'),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text('쿠폰/할인', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: TextField(decoration: InputDecoration(hintText: '쿠폰 코드 입력', isDense: true, border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: AppColors.slate600), child: const Text('적용')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const _SummaryRow(this.label, this.value, {this.valueColor, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.slate600, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                color: valueColor ?? (bold ? AppColors.slate900 : AppColors.slate600),
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                fontSize: bold ? 18 : 14,
              )),
        ],
      ),
    );
  }
}

class _BackLink extends StatelessWidget {
  final VoidCallback onTap;
  const _BackLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: TextButton.icon(onPressed: onTap, icon: const Icon(Icons.arrow_back, size: 20), label: const Text('홈으로 돌아가기')),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String primaryLabel;
  final VoidCallback onPrimary;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          children: [
            _BackLink(onTap: () => context.go('/')),
            Icon(icon, size: 80, color: AppColors.slate200),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.slate600, fontSize: 18)),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              children: [
                PrimaryButton(label: primaryLabel, onPressed: onPrimary),
                OutlinedButton(
                  onPressed: () => context.go('/search'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent, width: 2)),
                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), child: Text('상품 검색하기', style: TextStyle(fontWeight: FontWeight.w600))),
                ),
              ],
            ),
            const SizedBox(height: 64),
            const Text('인기 상품을 확인해보세요', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            ...products.take(3).map((p) => ListTile(
                  title: Text(p.name),
                  subtitle: Text('${formatPrice(p.price)}원'),
                  trailing: TextButton(onPressed: () => context.go('/product/${p.id}'), child: const Text('상품 보기')),
                )),
          ],
        ),
      ),
    );
  }
}
