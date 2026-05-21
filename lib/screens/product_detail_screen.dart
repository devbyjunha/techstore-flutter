import '../widgets/network_product_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/primary_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    Product? product;
    for (final p in products) {
      if (p.id == widget.productId) {
        product = p;
        break;
      }
    }

    if (product == null) {
      return AppScaffold(
        showFooter: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('상품을 찾을 수 없습니다', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextButton(onPressed: () => context.go('/'), child: const Text('홈으로 돌아가기')),
            ],
          ),
        ),
      );
    }

    final p = product;
    final store = context.watch<StoreProvider>();
    final isInWishlist = store.isInWishlist(p.id);
    final isInCart = store.isInCart(p.id);

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
                label: const Text('상품 목록으로 돌아가기'),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 1024;
                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: AspectRatio(aspectRatio: 1, child: ClipRRect(borderRadius: BorderRadius.circular(12), child: NetworkProductImage(imageUrl: p.image, fit: BoxFit.cover)))),
                            const SizedBox(width: 32),
                            Expanded(child: _ProductInfo(product: p, quantity: _quantity, onQuantity: (q) => setState(() => _quantity = q), isInWishlist: isInWishlist, isInCart: isInCart, store: store)),
                          ],
                        )
                      : Column(
                          children: [
                            AspectRatio(aspectRatio: 1, child: ClipRRect(borderRadius: BorderRadius.circular(12), child: NetworkProductImage(imageUrl: p.image, fit: BoxFit.cover))),
                            const SizedBox(height: 24),
                            _ProductInfo(product: p, quantity: _quantity, onQuantity: (q) => setState(() => _quantity = q), isInWishlist: isInWishlist, isInCart: isInCart, store: store),
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

class _ProductInfo extends StatelessWidget {
  final Product product;
  final int quantity;
  final ValueChanged<int> onQuantity;
  final bool isInWishlist;
  final bool isInCart;
  final StoreProvider store;

  const _ProductInfo({
    required this.product,
    required this.quantity,
    required this.onQuantity,
    required this.isInWishlist,
    required this.isInCart,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(product.description, style: const TextStyle(color: AppColors.slate600, fontSize: 16, height: 1.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.amber400, size: 20),
              Text(' ${product.rating}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Text(' (${product.reviews}개의 리뷰)', style: const TextStyle(color: AppColors.slate500)),
            ],
          ),
          const SizedBox(height: 16),
          Text('${formatPrice(product.price)}원', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.accent)),
          Text('카테고리: ${product.category}', style: const TextStyle(color: AppColors.slate500, fontSize: 14)),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('수량:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 16),
              DropdownButton<int>(
                value: quantity,
                items: [1, 2, 3, 4, 5].map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                onChanged: (v) => onQuantity(v ?? 1),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                if (isInWishlist) {
                  store.removeFromWishlist(product.id);
                } else {
                  store.addToWishlist(product);
                }
              },
              icon: Icon(isInWishlist ? Icons.favorite : Icons.favorite_border),
              label: Text(isInWishlist ? '찜한 상품' : '찜하기'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.rose500,
                side: BorderSide(color: AppColors.rose500, width: 2),
                backgroundColor: isInWishlist ? AppColors.rose500 : null,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                store.addToCart(product);
                store.addToast(type: ToastType.success, message: '장바구니에 추가되었습니다.');
              },
              icon: const Icon(Icons.shopping_cart_outlined),
              label: Text(isInCart ? '장바구니에 추가됨' : '장바구니에 담기'),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.accent, side: const BorderSide(color: AppColors.accent, width: 2)),
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: '바로 주문하기',
            icon: Icons.credit_card,
            onPressed: () {
              store.addToCart(product);
              context.go('/cart');
            },
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          const Text('상품 특징', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...['최신 기술 적용', '품질 보증', '무료 배송', '30일 환불 보장']
              .map((f) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('• $f', style: const TextStyle(color: AppColors.slate600)))),
        ],
      ),
    );
  }
}
