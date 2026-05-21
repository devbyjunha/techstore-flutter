import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/layout.dart';

/// Next.js: text-slate-400 transition-colors hover:text-white | hover:text-indigo-300
class _FooterLink extends StatefulWidget {
  final String label;
  final Color hoverColor;

  const _FooterLink({
    required this.label,
    required this.hoverColor,
  });

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;
  bool _pressed = false;

  static const _baseColor = AppColors.slate400;

  Color get _color {
    if (_pressed) {
      return Color.lerp(_hovered ? widget.hoverColor : _baseColor, Colors.black, 0.15)!;
    }
    if (_hovered) return widget.hoverColor;
    return _baseColor;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () {},
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          style: TextStyle(
            color: _color,
            fontSize: 14,
            height: 1.2,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const _brandHover = Colors.white;
  static const _linkHover = Color(0xFFA5B4FC); // tailwind indigo-300

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate950,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, AppColors.accent, Colors.transparent],
              ),
            ),
          ),
          ContentWidth(
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 56),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 768;
                    return isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: _brandSection()),
                              Expanded(child: _linkSection('고객 지원', ['고객센터', '자주 묻는 질문', '배송 안내', '반품/교환 안내'])),
                              Expanded(child: _linkSection('쇼핑 정보', ['이용약관', '개인정보처리방침', '전자상거래법', '사업자정보'])),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _brandSection(),
                              const SizedBox(height: 40),
                              _linkSection('고객 지원', ['고객센터', '자주 묻는 질문', '배송 안내', '반품/교환 안내']),
                              const SizedBox(height: 40),
                              _linkSection('쇼핑 정보', ['이용약관', '개인정보처리방침', '전자상거래법', '사업자정보']),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 48),
                const Divider(color: Color(0xFF1E293B), height: 1),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 768;
                      return isWide
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _businessInfo(),
                                const Text('© 2024 TechStore. All rights reserved.',
                                    style: TextStyle(fontSize: 12, height: 1.2, color: AppColors.slate500)),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _businessInfo(),
                                const SizedBox(height: 16),
                                const Text('© 2024 TechStore. All rights reserved.',
                                    style: TextStyle(fontSize: 12, height: 1.2, color: AppColors.slate500)),
                              ],
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentSecondary]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text('TechStore',
                style: TextStyle(color: Colors.white, fontSize: 20, height: 1.2, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxWidthMd),
          child: const Text(
            '최신 기술 제품을 합리적인 가격으로 제공하는 프리미엄 온라인 쇼핑몰입니다. 고객 만족을 최우선으로 하는 서비스를 제공합니다.',
            style: TextStyle(color: AppColors.slate400, fontSize: 14, height: 1.43),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: ['회사 소개', '채용 정보', '투자 정보']
              .map((t) => _FooterLink(label: t, hoverColor: _brandHover))
              .toList(),
        ),
      ],
    );
  }

  Widget _linkSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title.toUpperCase(),
            style: const TextStyle(
                color: Color(0xFFCBD5E1), fontSize: 12, height: 1.2, fontWeight: FontWeight.w600, letterSpacing: 1)),
        const SizedBox(height: 16),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _FooterLink(label: items[i], hoverColor: _linkHover),
        ],
      ],
    );
  }

  Widget _businessInfo() {
    return const Text(
      '사업자등록번호: 123-45-67890\n'
      '대표: 홍길동 | 서울특별시 강남구 테헤란로 123\n'
      '전화: 02-1234-5678 | info@techstore.com',
      style: TextStyle(fontSize: 12, height: 1.5, color: AppColors.slate500),
    );
  }
}
