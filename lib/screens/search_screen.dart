import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  List<Product> _results = products;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _filter(widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filter(String query) {
    if (query.trim().isEmpty) {
      setState(() => _results = products);
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _results = products
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.initialQuery ?? '';

    return AppScaffold(
      body: PageContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Text(query.isNotEmpty ? '"$query" 검색 결과' : '상품 검색',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                query.isNotEmpty ? '${_results.length}개의 상품을 찾았습니다' : '찾고 싶은 상품을 검색해보세요',
                style: const TextStyle(color: AppColors.slate600, fontSize: 18),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                onSubmitted: _filter,
                decoration: InputDecoration(
                  hintText: '상품명, 설명, 카테고리로 검색...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.close), onPressed: () {
                          _controller.clear();
                          _filter('');
                        })
                      : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),
              if (_results.isNotEmpty)
                ProductGrid(products: _results.map((p) => ProductCard(product: p)).toList())
              else
                _EmptyResults(onKeyword: (k) {
                  _controller.text = k;
                  _filter(k);
                }),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  final ValueChanged<String> onKeyword;

  const _EmptyResults({required this.onKeyword});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          const Icon(Icons.search, size: 64, color: AppColors.slate400),
          const SizedBox(height: 16),
          const Text('검색 결과가 없습니다', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('다른 키워드로 검색해보시거나 카테고리를 확인해보세요', style: TextStyle(color: AppColors.slate600)),
          const SizedBox(height: 24),
          const Text('추천 검색어:', style: TextStyle(fontSize: 14, color: AppColors.slate500)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['노트북', '스마트폰', '태블릿', '이어폰', '스마트워치']
                .map((k) => ActionChip(
                      label: Text(k),
                      onPressed: () => onKeyword(k),
                      backgroundColor: const Color(0xFFDBEAFE),
                      labelStyle: const TextStyle(color: Color(0xFF1D4ED8)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
