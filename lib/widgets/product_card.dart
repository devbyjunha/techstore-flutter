import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final isInWishlist = store.isInWishlist(product.id);
    final isInCart = store.isInCart(product.id);

    return GestureDetector(
      onTap: () => context.go('/product/${product.id}'),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.slate200.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.slate100),
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(Icons.image_not_supported, color: AppColors.slate400, size: 40),
                      ),
                    ),
                    if (product.isOnSale)
                      Positioned(
                        left: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.rose500,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: AppColors.rose500.withValues(alpha: 0.35), blurRadius: 8),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.bolt, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text('SALE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: GestureDetector(
                        onTap: () {
                          if (isInWishlist) {
                            store.removeFromWishlist(product.id);
                            store.addToast(type: ToastType.info, message: '찜 목록에서 제거되었습니다.');
                          } else {
                            store.addToWishlist(product);
                            store.addToast(type: ToastType.success, message: '찜 목록에 추가되었습니다.');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10), // p-2.5
                          decoration: BoxDecoration(
                            color: isInWishlist ? AppColors.rose500 : Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                          ),
                          child: Icon(
                            isInWishlist ? Icons.favorite : Icons.favorite_border,
                            color: isInWishlist ? Colors.white : AppColors.slate600,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.35,
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: AppColors.amber400),
                        const SizedBox(width: 4),
                        Text('${product.rating}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate700)),
                        Flexible(
                          child: Text(
                            ' (${_formatReviews(product.reviews)})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, color: AppColors.slate400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: _buildPrice()),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            store.addToCart(product);
                            store.addToast(type: ToastType.success, message: '장바구니에 추가되었습니다.');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10), // rounded-xl p-2.5
                            decoration: BoxDecoration(
                              color: isInCart ? AppColors.emerald500 : AppColors.indigo600,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                if (!isInCart)
                                  BoxShadow(color: AppColors.indigo600.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
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

  String _formatReviews(int n) => n.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  Widget _buildPrice() {
    if (product.isOnSale && product.originalPrice != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${formatPrice(product.originalPrice!)}원',
            style: const TextStyle(fontSize: 12, color: AppColors.slate400, decoration: TextDecoration.lineThrough),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: formatPrice(product.price),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.rose600),
                ),
                const TextSpan(
                  text: '원',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.slate500),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: formatPrice(product.price),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.slate900),
          ),
          const TextSpan(
            text: '원',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.slate500),
          ),
        ],
      ),
    );
  }
}
