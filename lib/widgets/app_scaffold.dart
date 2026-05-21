import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/layout.dart';
import 'footer.dart';
import 'gnb.dart';
import 'toast_overlay.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final bool showFooter;

  const AppScaffold({
    super.key,
    required this.body,
    this.showFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    // 초기 배포 구조: Stack/그라데이션/커스텀 ScrollPhysics 없음 → 웹 스크롤 체감 유지
    return ToastOverlay(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const GNB(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    body,
                    if (showFooter) const AppFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const PageContainer({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      ),
    );
  }
}

/// Next.js: grid gap-6, viewport breakpoints sm:2 lg:3 xl:4
class ProductGrid extends StatelessWidget {
  final List<Widget> products;
  final int? crossAxisCount;
  final double gap;

  const ProductGrid({
    super.key,
    required this.products,
    this.crossAxisCount,
    this.gap = 24,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportW = MediaQuery.sizeOf(context).width;
        final cols = crossAxisCount ?? productGridColumnsForViewport(viewportW);
        final itemWidth = (constraints.maxWidth - gap * (cols - 1)) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: products
              .map((w) => SizedBox(width: itemWidth, child: w))
              .toList(),
        );
      },
    );
  }
}
