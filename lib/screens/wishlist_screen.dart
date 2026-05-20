import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/primary_button.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    if (store.wishlist.isEmpty) {
      return AppScaffold(
        body: _EmptyWishlist(),
      );
    }

    return AppScaffold(
      body: PageContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.arrow_back),
                label: const Text('홈으로 돌아가기'),
              ),
              const Text('찜한 상품', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text('총 ${store.wishlist.length}개의 상품을 찜했습니다', style: const TextStyle(color: AppColors.slate600)),
              const SizedBox(height: 32),
              ProductGrid(
                products: store.wishlist.map((item) => _WishlistCard(item: item)).toList(),
              ),
              const SizedBox(height: 48),
              Center(
                child: Wrap(
                  spacing: 16,
                  children: [
                    FilledButton(
                      onPressed: () {
                        for (final item in store.wishlist) {
                          store.addToCart(item.product);
                        }
                        store.addToast(type: ToastType.success, message: '모든 상품이 장바구니에 추가되었습니다.');
                      },
                      style: FilledButton.styleFrom(backgroundColor: AppColors.emerald500),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text('모든 상품 장바구니에 추가', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => context.go('/cart'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent, width: 2)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text('장바구니 보기', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  final WishlistItem item;

  const _WishlistCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final store = context.read<StoreProvider>();
    final p = item.product;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(imageUrl: p.image, fit: BoxFit.cover),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    onPressed: () {
                      store.removeFromWishlist(p.id);
                      store.addToast(type: ToastType.info, message: '찜 목록에서 제거되었습니다.');
                    },
                    style: IconButton.styleFrom(backgroundColor: AppColors.rose500),
                    icon: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('★ ${p.rating} (${p.reviews})', style: const TextStyle(fontSize: 13, color: AppColors.slate500)),
                Text('${formatPrice(p.price)}원', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          store.addToCart(p);
                          store.addToast(type: ToastType.success, message: '장바구니에 추가되었습니다.');
                        },
                        icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                        label: const Text('장바구니'),
                        style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/product/${p.id}'),
                        child: const Text('상세보기'),
                      ),
                    ),
                  ],
                ),
                Text('찜한 날짜: ${item.addedAt.year}.${item.addedAt.month}.${item.addedAt.day}',
                    style: const TextStyle(fontSize: 11, color: AppColors.slate500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          children: [
            TextButton.icon(onPressed: () => context.go('/'), icon: const Icon(Icons.arrow_back), label: const Text('홈으로 돌아가기')),
            const Icon(Icons.favorite_border, size: 80, color: AppColors.slate200),
            const SizedBox(height: 24),
            const Text('찜한 상품이 없습니다', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('아직 찜한 상품이 없어요.\n마음에 드는 상품을 찜해보세요!', textAlign: TextAlign.center, style: TextStyle(color: AppColors.slate600, fontSize: 18)),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              children: [
                PrimaryButton(label: '상품 둘러보기', onPressed: () => context.go('/')),
                OutlinedButton(
                  onPressed: () => context.go('/search'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.rose600, side: const BorderSide(color: AppColors.rose500, width: 2)),
                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), child: Text('상품 검색하기')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
