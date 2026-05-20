import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: AppTheme.primaryButtonDecoration,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: Colors.white, size: fontSize + 2),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const GradientText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.indigo600, AppColors.violet600, Color(0xFFA855F7)],
      ).createShader(bounds),
      child: Text(
        text,
        style: (style ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            .copyWith(color: Colors.white),
      ),
    );
  }
}
