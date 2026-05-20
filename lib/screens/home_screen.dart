import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/constants.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _featuredCount = 8;

  @override
  Widget build(BuildContext context) {
    final store = context.read<StoreProvider>();
    final featured = products.take(_featuredCount).toList();
    final saleCount = products.where((p) => p.isOnSale).length;

    return AppScaffold(
      body: Column(
        children: [
          _HeroSection(
            saleCount: saleCount,
            onBrowse: () => context.go('/products'),
            onSale: () => context.go('/products?sale=true'),
            onTestNotification: () {
              store.addNotification(
                title: '테스트 알림',
                message: '알림 기능이 정상적으로 작동합니다!',
                type: NotificationType.success,
                actionUrl: '/search',
              );
            },
          ),
          PageContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, c) {
                      final isWide = c.maxWidth >= 640;
                      return isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(child: _sectionHeader()),
                                _sectionActions(context, saleCount),
                              ],
                            )
                          : Column(
                              children: [
                                _sectionHeader(),
                                const SizedBox(height: 16),
                                _sectionActions(context, saleCount),
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 48),
                  ProductGrid(
                    products: featured.map((p) => ProductCard(product: p)).toList(),
                  ),
                  if (products.length > _featuredCount) ...[
                    const SizedBox(height: 48),
                    Text('외 ${products.length - _featuredCount}개의 상품이 더 있습니다',
                        style: const TextStyle(color: AppColors.slate600)),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: '전체 ${products.length}개 상품 보기',
                      icon: Icons.arrow_forward,
                      onPressed: () => context.go('/products'),
                    ),
                  ],
                  const SizedBox(height: 96),
                  const Text('카테고리별 탐색',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.slate900)),
                  const SizedBox(height: 8),
                  const Text('원하는 카테고리에서 바로 쇼핑하세요', style: TextStyle(color: AppColors.slate600)),
                  const SizedBox(height: 40),
                  _CategorySection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('인기 상품', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.slate900)),
          const SizedBox(height: 8),
          Text('베스트셀러 미리보기 · 전체 ${products.length}개 상품', style: const TextStyle(color: AppColors.slate600)),
        ],
      );

  Widget _sectionActions(BuildContext context, int saleCount) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        PrimaryButton(label: '전체 상품 보기', icon: Icons.arrow_forward, onPressed: () => context.go('/products'), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), fontSize: 14),
        TextButton(
          onPressed: () => context.go('/products?sale=true'),
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFFF1F2),
            foregroundColor: AppColors.rose600,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('특가만 보기', style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final int saleCount;
  final VoidCallback onBrowse;
  final VoidCallback onSale;
  final VoidCallback onTestNotification;

  const _HeroSection({
    required this.saleCount,
    required this.onBrowse,
    required this.onSale,
    required this.onTestNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.slate950,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.8),
                  radius: 1.2,
                  colors: [AppColors.accent.withValues(alpha: 0.45), Colors.transparent],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 96),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 768),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 14, color: Color(0xFFC7D2FE)),
                          SizedBox(width: 8),
                          Text('2024 프리미엄 테크 컬렉션', style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('기술의 미래를', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [Color(0xFFA5B4FC), Color(0xFFC4B5FD), Color(0xFFD8B4FE)],
                      ).createShader(b),
                      child: const Text('지금 경험하세요', textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Apple, Samsung 등 글로벌 브랜드의 최신 제품을 합리적인 가격으로. TechStore만의 프리미엄 쇼핑 경험.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.slate400, fontSize: 18, height: 1.6),
                    ),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        PrimaryButton(label: '상품 둘러보기', icon: Icons.arrow_forward, onPressed: onBrowse),
                        OutlinedButton(
                          onPressed: onSale,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                            backgroundColor: Colors.white.withValues(alpha: 0.05),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text('특가 $saleCount개 보기', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 64),
                    LayoutBuilder(
                      builder: (context, c) {
                        final cols = c.maxWidth >= 640 ? 3 : 1;
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: cols,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: cols == 1 ? 3 : 1.5,
                          children: const [
                            _TrustBadge(icon: Icons.local_shipping, label: '무료 배송', desc: '5만원 이상 주문 시'),
                            _TrustBadge(icon: Icons.shield, label: '정품 보증', desc: '100% 공식 유통'),
                            _TrustBadge(icon: Icons.auto_awesome, label: '프리미엄 케어', desc: '전문 A/S 지원'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String desc;

  const _TrustBadge({required this.icon, required this.label, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFA5B4FC), size: 24),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          Text(desc, style: const TextStyle(color: AppColors.slate400, fontSize: 14)),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final cols = c.maxWidth >= 1024 ? 4 : c.maxWidth >= 768 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 32,
            mainAxisSpacing: 32,
            childAspectRatio: 0.85,
          ),
          itemCount: homeCategories.length,
          itemBuilder: (context, index) {
            final cat = homeCategories[index];
            final catProducts = products.where((p) => p.category == cat.name).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () => context.go('/category/${cat.slug}'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: cat.gradient),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: cat.gradient.first.withValues(alpha: 0.3), blurRadius: 12)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cat.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                        Row(
                          children: [
                            Text('${catProducts.length}개', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...catProducts.take(2).map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ProductCard(product: p),
                    )),
              ],
            );
          },
        );
      },
    );
  }
}
