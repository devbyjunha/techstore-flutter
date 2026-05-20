/// Tailwind breakpoints aligned with techstore-nextjs
class AppBreakpoints {
  static const sm = 640.0;
  static const md = 768.0;
  static const lg = 1024.0;
  static const xl = 1280.0;
  static const maxContent = 1280.0; // max-w-7xl
}

/// Tailwind viewport breakpoints: sm:2, lg:3, xl:4
int productGridColumnsForViewport(double viewportWidth) {
  if (viewportWidth >= AppBreakpoints.xl) return 4;
  if (viewportWidth >= AppBreakpoints.lg) return 3;
  if (viewportWidth >= AppBreakpoints.sm) return 2;
  return 1;
}
