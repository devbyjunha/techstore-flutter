import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    context.read<StoreProvider>().login(
          name: '테스트 사용자',
          email: _emailController.text,
        );
    setState(() => _isLoading = false);
    if (mounted) context.go('/mypage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('홈으로 돌아가기'),
                  style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('로그인', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const Text('TechStore 계정으로 로그인하세요', textAlign: TextAlign.center, style: TextStyle(color: AppColors.slate600)),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: '이메일 주소',
                    hintText: '이메일을 입력하세요',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력하세요',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (_) {}),
                    const Text('로그인 상태 유지', style: TextStyle(fontSize: 14)),
                    const Spacer(),
                    TextButton(onPressed: () {}, child: const Text('비밀번호를 잊으셨나요?')),
                  ],
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: _isLoading ? '로그인 중...' : '로그인',
                  onPressed: _isLoading ? null : _submit,
                ),
                const SizedBox(height: 16),
                const Text('계정이 없으신가요? 회원가입', textAlign: TextAlign.center, style: TextStyle(color: AppColors.slate600)),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('데모 계정', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E3A8A))),
                      SizedBox(height: 8),
                      Text(
                        '이메일과 비밀번호를 아무 값이나 입력하면 로그인됩니다.\n(실제 서비스에서는 API 연동이 필요합니다)',
                        style: TextStyle(fontSize: 12, color: Color(0xFF1D4ED8)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
