import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/constants.dart';
import '../data/products.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import 'primary_button.dart';

class GNB extends StatefulWidget {
  const GNB({super.key});

  @override
  State<GNB> createState() => _GNBState();
}

class _GNBState extends State<GNB> {
  final _searchController = TextEditingController();
  bool _showSuggestions = false;
  bool _showNotifications = false;
  List<Product> _suggestions = [];
  final _notificationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _suggestions = products
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .take(5)
          .toList();
      _showSuggestions = true;
    });
  }

  void _submitSearch() {
    final q = _searchController.text.trim();
    if (q.isNotEmpty) {
      setState(() => _showSuggestions = false);
      context.go('/search?q=${Uri.encodeComponent(q)}');
    }
  }

  String _formatNotificationTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return '${date.year}.${date.month}.${date.day}';
  }

  String _notificationIcon(NotificationType type) {
    return switch (type) {
      NotificationType.success => '✅',
      NotificationType.warning => '⚠️',
      NotificationType.error => '❌',
      NotificationType.info => 'ℹ️',
    };
  }

  Widget _buildSearchBar({bool fullWidth = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onSubmitted: (_) => _submitSearch(),
          onTap: () {
            if (_searchController.text.trim().isNotEmpty) {
              setState(() => _showSuggestions = true);
            }
          },
          decoration: InputDecoration(
            hintText: '상품명, 브랜드, 카테고리로 검색...',
            hintStyle: const TextStyle(color: AppColors.slate400, fontSize: 14),
            filled: true,
            fillColor: AppColors.slate50.withValues(alpha: 0.8),
            contentPadding: const EdgeInsets.symmetric(horizontal: 44, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.slate200.withValues(alpha: 0.8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.slate200.withValues(alpha: 0.8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.accent),
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.search, size: 20, color: AppColors.slate400),
              onPressed: _submitSearch,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
          ),
        ),
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 320),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.slate200.withValues(alpha: 0.8)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24)],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = _suggestions[index];
                return ListTile(
                  onTap: () {
                    setState(() => _showSuggestions = false);
                    context.go('/product/${p.id}');
                  },
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE0E7FF), Color(0xFFEDE9FE)],
                      ),
                    ),
                  ),
                  title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(p.category, style: const TextStyle(fontSize: 13)),
                  trailing: Text('${formatPrice(p.price)}원',
                      style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.accent, fontSize: 13)),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final location = GoRouterState.of(context).uri.path;
    final isWide = MediaQuery.sizeOf(context).width >= 1024;

    return Material(
      color: Colors.white.withValues(alpha: 0.72),
      child: Container(
        decoration: AppTheme.glassPanel(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SizedBox(
                height: 48,
                child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.accent, AppColors.accentSecondary],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 12)],
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 8),
                        const GradientText('TechStore', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  if (isWide) ...[
                    const SizedBox(width: 32),
                    Expanded(child: _buildSearchBar()),
                  ],
                  const Spacer(),
                  _IconAction(
                    icon: Icons.notifications_outlined,
                    badge: store.unreadNotificationCount,
                    badgeColor: AppColors.amber500,
                    onTap: () => setState(() => _showNotifications = !_showNotifications),
                    overlay: _showNotifications ? _buildNotificationPanel(store) : null,
                    key: _notificationKey,
                  ),
                  _IconAction(
                    icon: Icons.favorite_border,
                    badge: store.wishlistCount,
                    badgeColor: AppColors.rose500,
                    onTap: () => context.go('/wishlist'),
                  ),
                  _IconAction(
                    icon: Icons.shopping_cart_outlined,
                    badge: store.cartItemCount,
                    badgeColor: AppColors.accent,
                    onTap: () => context.go('/cart'),
                  ),
                  _IconAction(
                    icon: Icons.person_outline,
                    onTap: () => context.go('/mypage'),
                  ),
                  if (store.user.isLoggedIn) ...[
                    if (MediaQuery.sizeOf(context).width >= 640)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text('${store.user.name}님', style: const TextStyle(fontSize: 14, color: AppColors.slate600)),
                      ),
                    IconButton(
                      icon: const Icon(Icons.logout, size: 20),
                      onPressed: () {
                        store.logout();
                        context.go('/');
                      },
                    ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: PrimaryButton(
                        label: '로그인',
                        onPressed: () => context.go('/login'),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
              ),
            ),
            if (!isWide)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildSearchBar(),
              ),
            if (MediaQuery.sizeOf(context).width >= 768)
              Container(
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.slate100))),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: navCategories.map((cat) {
                      final href = '/category/${cat.slug}';
                      final isActive = location == href;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Material(
                          color: isActive ? AppColors.accent : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () => context.go(href),
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    _categoryIcon(cat.slug),
                                    size: 16,
                                    color: isActive ? Colors.white : AppColors.slate600,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(cat.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isActive ? Colors.white : AppColors.slate600,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String slug) => switch (slug) {
        'laptop' => Icons.laptop_mac,
        'smartphone' => Icons.smartphone,
        'tablet' => Icons.tablet_mac,
        _ => Icons.headphones,
      };

  Widget _buildNotificationPanel(StoreProvider store) {
    return Positioned(
      right: 0,
      top: 48,
      width: 320,
      child: Material(
        elevation: 12,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 384),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.slate200.withValues(alpha: 0.8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('알림', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    if (store.notifications.isNotEmpty)
                      TextButton(
                        onPressed: store.markAllNotificationsRead,
                        child: const Text('모두 읽음', style: TextStyle(color: AppColors.accent)),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (store.notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.notifications_none, size: 40, color: AppColors.slate200),
                      SizedBox(height: 12),
                      Text('새로운 알림이 없습니다', style: TextStyle(color: AppColors.slate500, fontSize: 14)),
                    ],
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: store.notifications.length,
                    itemBuilder: (context, index) {
                      final n = store.notifications[index];
                      return InkWell(
                        onTap: () {
                          if (!n.isRead) store.markNotificationRead(n.id);
                          if (n.actionUrl != null) context.go(n.actionUrl!);
                          setState(() => _showNotifications = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: !n.isRead ? AppColors.accent.withValues(alpha: 0.05) : null,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_notificationIcon(n.type), style: const TextStyle(fontSize: 18)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(n.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: !n.isRead ? AppColors.slate900 : AppColors.slate600,
                                              )),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 16),
                                          onPressed: () => store.removeNotification(n.id),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                    Text(n.message, style: const TextStyle(fontSize: 13, color: AppColors.slate500)),
                                    Text(_formatNotificationTime(n.createdAt),
                                        style: const TextStyle(fontSize: 11, color: AppColors.slate400)),
                                  ],
                                ),
                              ),
                              if (!n.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 4),
                                  decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final int badge;
  final Color badgeColor;
  final VoidCallback onTap;
  final Widget? overlay;
  final Key? key;

  const _IconAction({
    required this.icon,
    this.badge = 0,
    this.badgeColor = AppColors.accent,
    required this.onTap,
    this.overlay,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(icon, size: 22, color: AppColors.slate500),
            ),
          ),
        ),
        if (badge > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        if (overlay != null) overlay!,
      ],
    );
  }
}
