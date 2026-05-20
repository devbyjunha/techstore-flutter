import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/products.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  final bool saleOnly;

  const ProductsScreen({super.key, this.saleOnly = false});

  @override
  Widget build(BuildContext context) {
    final displayed = saleOnly ? products.where((p) => p.isOnSale).toList() : products;
    final saleCount = products.where((p) => p.isOnSale).length;

    return AppScaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.slate200)),
            ),
            child: PageContainer(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('홈으로'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.slate600),
                    ),
                    const SizedBox(height: 16),
                    Text(saleOnly ? '특가 상품' : '전체 상품',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.slate900)),
                    const SizedBox(height: 8),
                    Text(
                      saleOnly
                          ? '지금 할인 중인 ${displayed.length}개의 특가 상품'
                          : 'TechStore의 모든 상품 ${displayed.length}개를 만나보세요',
                      style: const TextStyle(color: AppColors.slate600),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      children: [
                        _FilterChip(
                          label: '전체 (${products.length})',
                          selected: !saleOnly,
                          onTap: () => context.go('/products'),
                        ),
                        _FilterChip(
                          label: '특가 ($saleCount)',
                          selected: saleOnly,
                          color: AppColors.rose500,
                          onTap: () => context.go('/products?sale=true'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          PageContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: displayed.isEmpty
                  ? Column(
                      children: [
                        const Icon(Icons.auto_awesome, size: 48, color: AppColors.slate200),
                        const SizedBox(height: 16),
                        const Text('표시할 상품이 없습니다', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 24),
                        PrimaryButton(label: '전체 상품 보기', onPressed: () => context.go('/products')),
                      ],
                    )
                  : ProductGrid(products: displayed.map((p) => ProductCard(product: p)).toList()),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.accent;
    return Material(
      color: selected ? c : AppColors.slate100,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: selected ? Colors.white : AppColors.slate600,
              )),
        ),
      ),
    );
  }
}
