import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/primary_button.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String _activeTab = 'profile';

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();

    if (!store.user.isLoggedIn) {
      return AppScaffold(
        body: PageContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: Column(
              children: [
                TextButton.icon(onPressed: () => context.go('/'), icon: const Icon(Icons.arrow_back), label: const Text('홈으로 돌아가기')),
                const Icon(Icons.person_outline, size: 64, color: AppColors.slate400),
                const SizedBox(height: 16),
                const Text('로그인이 필요합니다', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('마이페이지를 이용하려면 로그인해주세요', style: TextStyle(color: AppColors.slate600)),
                const SizedBox(height: 24),
                PrimaryButton(label: '로그인하기', onPressed: () => context.go('/login')),
              ],
            ),
          ),
        ),
      );
    }

    final tabs = [
      ('profile', '프로필', Icons.person_outline),
      ('orders', '주문 내역', Icons.inventory_2_outlined),
      ('wishlist', '찜한 상품', Icons.favorite_border),
      ('cart', '장바구니', Icons.shopping_cart_outlined),
      ('settings', '설정', Icons.settings_outlined),
    ];

    return AppScaffold(
      body: PageContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(onPressed: () => context.go('/'), icon: const Icon(Icons.arrow_back), label: const Text('홈으로 돌아가기')),
              Text('마이페이지', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text('안녕하세요, ${store.user.name}님!', style: const TextStyle(color: AppColors.slate600)),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 1024;
                  return isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 240, child: _Sidebar(tabs: tabs, active: _activeTab, onSelect: (t) => setState(() => _activeTab = t), onLogout: store.logout)),
                            const SizedBox(width: 32),
                            Expanded(child: _TabContent(tab: _activeTab, store: store)),
                          ],
                        )
                      : Column(
                          children: [
                            _Sidebar(tabs: tabs, active: _activeTab, onSelect: (t) => setState(() => _activeTab = t), onLogout: store.logout, horizontal: true),
                            const SizedBox(height: 24),
                            _TabContent(tab: _activeTab, store: store),
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

class _Sidebar extends StatelessWidget {
  final List<(String, String, IconData)> tabs;
  final String active;
  final ValueChanged<String> onSelect;
  final VoidCallback onLogout;
  final bool horizontal;

  const _Sidebar({required this.tabs, required this.active, required this.onSelect, required this.onLogout, this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    final content = [
      ...tabs.map((t) {
        final selected = active == t.$1;
        return Material(
          color: selected ? const Color(0xFFDBEAFE) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => onSelect(t.$1),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: horizontal ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  Icon(t.$3, size: 20, color: selected ? AppColors.accent : AppColors.slate600),
                  const SizedBox(width: 12),
                  Text(t.$2, style: TextStyle(color: selected ? AppColors.accent : AppColors.slate700)),
                ],
              ),
            ),
          ),
        );
      }),
      if (!horizontal) ...[
        const Divider(height: 32),
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.rose500),
          title: const Text('로그아웃', style: TextStyle(color: AppColors.rose500)),
          onTap: onLogout,
        ),
      ],
    ];

    if (horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: content.map((w) => Padding(padding: const EdgeInsets.only(right: 8), child: w)).toList()),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)]),
      child: Column(children: content),
    );
  }
}

class _TabContent extends StatelessWidget {
  final String tab;
  final StoreProvider store;

  const _TabContent({required this.tab, required this.store});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)]),
      child: switch (tab) {
        'profile' => _ProfileTab(store: store),
        'orders' => _OrdersTab(),
        'wishlist' => _MiniListTab(title: '찜한 상품', items: store.wishlist.map((w) => (w.product.name, formatPrice(w.product.price), '/product/${w.product.id}')).toList(), emptyIcon: Icons.favorite_border, emptyText: '찜한 상품이 없습니다', viewAll: '/wishlist'),
        'cart' => _MiniListTab(title: '장바구니', items: store.cart.map((c) => ('${c.product.name} × ${c.quantity}', formatPrice(c.product.price * c.quantity), '/cart')).toList(), emptyIcon: Icons.shopping_cart_outlined, emptyText: '장바구니가 비어있습니다', viewAll: '/cart'),
        'settings' => _SettingsTab(),
        _ => const SizedBox(),
      },
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final StoreProvider store;
  const _ProfileTab({required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('기본 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        TextField(controller: TextEditingController(text: store.user.name), readOnly: true, decoration: const InputDecoration(labelText: '이름', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        TextField(controller: TextEditingController(text: store.user.email), readOnly: true, decoration: const InputDecoration(labelText: '이메일', border: OutlineInputBorder())),
        const SizedBox(height: 32),
        const Text('계정 통계', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        Row(
          children: [
            _StatCard('${store.wishlistCount}', '찜한 상품', const Color(0xFFDBEAFE), AppColors.accent),
            const SizedBox(width: 16),
            _StatCard('${store.cartItemCount}', '장바구니', const Color(0xFFD1FAE5), AppColors.emerald500),
            const SizedBox(width: 16),
            _StatCard('0', '주문 완료', const Color(0xFFEDE9FE), AppColors.accentSecondary),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color bg;
  final Color color;

  const _StatCard(this.value, this.label, this.bg, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 13, color: color)),
          ],
        ),
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('주문 내역', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 32),
        const Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.slate200),
        const Text('아직 주문한 상품이 없습니다'),
        const SizedBox(height: 16),
        PrimaryButton(label: '상품 둘러보기', onPressed: () => context.go('/'), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), fontSize: 14),
      ],
    );
  }
}

class _MiniListTab extends StatelessWidget {
  final String title;
  final List<(String, String, String)> items;
  final IconData emptyIcon;
  final String emptyText;
  final String viewAll;

  const _MiniListTab({required this.title, required this.items, required this.emptyIcon, required this.emptyText, required this.viewAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            TextButton(onPressed: () => context.go(viewAll), child: const Text('전체 보기 →')),
          ],
        ),
        if (items.isEmpty)
          Column(children: [Icon(emptyIcon, size: 48, color: AppColors.slate200), Text(emptyText)])
        else
          ...items.take(3).map((item) => ListTile(
                title: Text(item.$1),
                subtitle: Text('${item.$2}원'),
                trailing: TextButton(onPressed: () => context.go(item.$3), child: const Text('보기')),
              )),
      ],
    );
  }
}

class _SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('계정 설정', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        ...['비밀번호 변경', '개인정보 수정', '알림 설정', '배송지 관리'].map((t) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)), child: Align(alignment: Alignment.centerLeft, child: Text(t))),
            )),
      ],
    );
  }
}
