/// Tailwind breakpoints aligned with techstore-nextjs
class AppBreakpoints {
  static const sm = 640.0;
  static const md = 768.0;
  static const lg = 1024.0;
  static const xl = 1280.0;
  static const maxContent = 1280.0; // max-w-7xl
}

int productGridColumns(double width) {
  if (width >= AppBreakpoints.xl) return 4;
  if (width >= AppBreakpoints.lg) return 3;
  if (width >= AppBreakpoints.sm) return 2;
  return 1;
}
