import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/store_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TechStoreApp());
}

class TechStoreApp extends StatelessWidget {
  const TechStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoreProvider(),
      child: MaterialApp.router(
        title: 'TechStore - 최신 기술 제품 쇼핑몰',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter,
      ),
    );
  }
}
