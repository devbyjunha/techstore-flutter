import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';

class ToastOverlay extends StatelessWidget {
  final Widget child;

  const ToastOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final toasts = context.watch<StoreProvider>().toasts;
    return Stack(
      children: [
        child,
        Positioned(
          top: 16,
          right: 16,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: toasts.map((toast) => _ToastItem(
                toast: toast,
                onDismiss: () => context.read<StoreProvider>().removeToast(toast.id),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ToastItem extends StatelessWidget {
  final AppToast toast;
  final VoidCallback onDismiss;

  const _ToastItem({required this.toast, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final (bg, border, icon, iconColor) = switch (toast.type) {
      ToastType.success => (const Color(0xFFF0FDF4), const Color(0xFFBBF7D0), Icons.check_circle, Colors.green),
      ToastType.error => (const Color(0xFFFEF2F2), const Color(0xFFFECACA), Icons.cancel, Colors.red),
      ToastType.info => (const Color(0xFFEFF6FF), const Color(0xFFBFDBFE), Icons.info, Colors.blue),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(toast.message, style: const TextStyle(fontWeight: FontWeight.w500))),
          IconButton(icon: const Icon(Icons.close, size: 16), onPressed: onDismiss, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
        ],
      ),
    );
  }
}
