import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate950,
      child: Column(
        children: [
          Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, AppColors.accent, Colors.transparent],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 56),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Column(
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
                              children: [
                                _brandSection(),
                                const SizedBox(height: 32),
                                _linkSection('고객 지원', ['고객센터', '자주 묻는 질문', '배송 안내', '반품/교환 안내']),
                                const SizedBox(height: 24),
                                _linkSection('쇼핑 정보', ['이용약관', '개인정보처리방침', '전자상거래법', '사업자정보']),
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 48),
                  const Divider(color: Color(0xFF1E293B)),
                  const SizedBox(height: 32),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 768;
                      return isWide
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _businessInfo(),
                                const Text('© 2024 TechStore. All rights reserved.',
                                    style: TextStyle(fontSize: 12, color: AppColors.slate500)),
                              ],
                            )
                          : Column(
                              children: [
                                _businessInfo(),
                                const SizedBox(height: 16),
                                const Text('© 2024 TechStore. All rights reserved.',
                                    style: TextStyle(fontSize: 12, color: AppColors.slate500)),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            const Text('TechStore', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          '최신 기술 제품을 합리적인 가격으로 제공하는 프리미엄 온라인 쇼핑몰입니다. 고객 만족을 최우선으로 하는 서비스를 제공합니다.',
          style: TextStyle(color: AppColors.slate400, fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          children: ['회사 소개', '채용 정보', '투자 정보']
              .map((t) => Text(t, style: const TextStyle(color: AppColors.slate400, fontSize: 14)))
              .toList(),
        ),
      ],
    );
  }

  Widget _linkSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(item, style: const TextStyle(color: AppColors.slate400, fontSize: 14, height: 1.6)),
            )),
      ],
    );
  }

  Widget _businessInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('사업자등록번호: 123-45-67890', style: TextStyle(fontSize: 12, color: AppColors.slate500)),
        SizedBox(height: 4),
        Text('대표: 홍길동 | 서울특별시 강남구 테헤란로 123', style: TextStyle(fontSize: 12, color: AppColors.slate500)),
        SizedBox(height: 4),
        Text('전화: 02-1234-5678 | info@techstore.com', style: TextStyle(fontSize: 12, color: AppColors.slate500)),
      ],
    );
  }
}
