import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// 상품 이미지 — Flutter Web(CanvasKit) CORS 회피를 위해 웹에서는 HTML img 사용
class NetworkProductImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const NetworkProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  static const _headers = {'Accept': 'image/*'};

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: AppColors.slate100,
      );

  Widget _error() => Container(
        width: width,
        height: height,
        color: AppColors.slate100,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported, color: AppColors.slate400, size: 40),
      );

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        headers: _headers,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _placeholder();
        },
        errorBuilder: (_, __, ___) => _error(),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      httpHeaders: _headers,
      placeholder: (_, __) => _placeholder(),
      errorWidget: (_, __, ___) => _error(),
    );
  }
}
