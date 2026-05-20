import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/cart_screen.dart';
import '../screens/category_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/mypage_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/products_screen.dart';
import '../screens/search_screen.dart';
import '../screens/wishlist_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/products',
      builder: (context, state) {
        final saleOnly = state.uri.queryParameters['sale'] == 'true';
        return ProductsScreen(saleOnly: saleOnly);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final q = state.uri.queryParameters['q'];
        return SearchScreen(initialQuery: q);
      },
    ),
    GoRoute(path: '/wishlist', builder: (_, __) => const WishlistScreen()),
    GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/mypage', builder: (_, __) => const MyPageScreen()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/category/:category',
      builder: (context, state) {
        final slug = state.pathParameters['category']!;
        return CategoryScreen(categorySlug: slug);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('페이지를 찾을 수 없습니다', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          TextButton(onPressed: () => context.go('/'), child: const Text('홈으로')),
        ],
      ),
    ),
  ),
);
