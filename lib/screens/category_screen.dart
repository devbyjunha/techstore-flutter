import 'package:flutter/material.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/primary_button.dart';
import '../widgets/product_card.dart';

enum SortField { name, price, rating }

class CategoryScreen extends StatefulWidget {
  final String categorySlug;

  const CategoryScreen({super.key, required this.categorySlug});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  SortField _sortBy = SortField.name;
  bool _sortAsc = true;
  bool _showSaleOnly = false;
  List<Product> _filtered = [];

  String get _koreanCategory => categorySlugMap[widget.categorySlug] ?? widget.categorySlug;

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  void didUpdateWidget(CategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categorySlug != widget.categorySlug) _applyFilters();
  }

  void _applyFilters() {
    var list = products.where((p) => p.category == _koreanCategory).toList();
    if (_showSaleOnly) list = list.where((p) => p.isOnSale).toList();
    list.sort((a, b) {
      final cmp = switch (_sortBy) {
        SortField.name => a.name.compareTo(b.name),
        SortField.price => a.price.compareTo(b.price),
        SortField.rating => a.rating.compareTo(b.rating),
      };
      return _sortAsc ? cmp : -cmp;
    });
    setState(() => _filtered = list);
  }

  void _toggleSort(SortField field) {
    if (_sortBy == field) {
      _sortAsc = !_sortAsc;
    } else {
      _sortBy = field;
      _sortAsc = true;
    }
    _applyFilters();
  }

  String _sortIcon(SortField field) {
    if (_sortBy != field) return '↕';
    return _sortAsc ? '↑' : '↓';
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_koreanCategory, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text('${_filtered.length}개의 상품을 찾았습니다', style: const TextStyle(color: AppColors.slate600)),
                    const SizedBox(height: 16),
                    Material(
                      color: _showSaleOnly ? AppColors.rose500 : AppColors.slate100,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          setState(() => _showSaleOnly = !_showSaleOnly);
                          _applyFilters();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(_showSaleOnly ? '특가 상품만' : '전체 상품',
                              style: TextStyle(fontWeight: FontWeight.w600, color: _showSaleOnly ? Colors.white : AppColors.slate700)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text('정렬:', style: TextStyle(fontSize: 14, color: AppColors.slate600)),
                        _SortChip('상품명 ${_sortIcon(SortField.name)}', _sortBy == SortField.name, () => _toggleSort(SortField.name)),
                        _SortChip('가격 ${_sortIcon(SortField.price)}', _sortBy == SortField.price, () => _toggleSort(SortField.price)),
                        _SortChip('평점 ${_sortIcon(SortField.rating)}', _sortBy == SortField.rating, () => _toggleSort(SortField.rating)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          PageContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: _filtered.isEmpty
                  ? Column(
                      children: [
                        const Text('🔍', style: TextStyle(fontSize: 48)),
                        Text(_showSaleOnly ? '특가 상품이 없습니다' : '상품을 찾을 수 없습니다',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                        if (_showSaleOnly) ...[
                          const SizedBox(height: 16),
                          PrimaryButton(
                            label: '전체 상품 보기',
                            onPressed: () {
                              setState(() => _showSaleOnly = false);
                              _applyFilters();
                            },
                          ),
                        ],
                      ],
                    )
                  : ProductGrid(products: _filtered.map((p) => ProductCard(product: p)).toList()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortChip(this.label, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accent : AppColors.slate100,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? Colors.white : AppColors.slate700)),
        ),
      ),
    );
  }
}
