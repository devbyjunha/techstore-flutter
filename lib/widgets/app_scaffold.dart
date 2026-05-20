import 'package:flutter/material.dart';
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
    return ToastOverlay(
      child: Scaffold(
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
    this.maxWidth = 1280,
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

class ProductGrid extends StatelessWidget {
  final List<dynamic> products;
  final int crossAxisCount;

  const ProductGrid({
    super.key,
    required this.products,
    this.crossAxisCount = 0,
  });

  int _columns(double width) {
    if (crossAxisCount > 0) return crossAxisCount;
    if (width >= 1280) return 4;
    if (width >= 1024) return 3;
    if (width >= 640) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _columns(constraints.maxWidth);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.72,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => products[index],
        );
      },
    );
  }
}
