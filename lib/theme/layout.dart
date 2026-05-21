import 'package:flutter/material.dart';

/// Tailwind breakpoints aligned with techstore-nextjs
class AppBreakpoints {
  static const sm = 640.0;
  static const md = 768.0;
  static const lg = 1024.0;
  static const xl = 1280.0;
  static const maxContent = 1280.0; // max-w-7xl
  static const maxWidthMd = 448.0; // max-w-md (footer intro)
  static const maxWidthXl = 576.0; // max-w-xl (hero subtitle)
  static const maxWidth3xl = 768.0; // max-w-3xl (hero column)
}

/// Next.js: mx-auto max-w-7xl px-4
class ContentWidth extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const ContentWidth({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.maxContent),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Tailwind viewport breakpoints: sm:2, lg:3, xl:4
int productGridColumnsForViewport(double viewportWidth) {
  if (viewportWidth >= AppBreakpoints.xl) return 4;
  if (viewportWidth >= AppBreakpoints.lg) return 3;
  if (viewportWidth >= AppBreakpoints.sm) return 2;
  return 1;
}
