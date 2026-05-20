class Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final int? originalPrice;
  final int? discount;
  final bool isOnSale;
  final String image;
  final String category;
  final double rating;
  final int reviews;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.discount,
    this.isOnSale = false,
    required this.image,
    required this.category,
    required this.rating,
    required this.reviews,
  });
}

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, required this.quantity});
}

class WishlistItem {
  final Product product;
  final DateTime addedAt;

  const WishlistItem({required this.product, required this.addedAt});
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String? actionUrl;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.actionUrl,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        message: message,
        type: type,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
        actionUrl: actionUrl,
      );
}

enum NotificationType { info, success, warning, error }

class AppToast {
  final String id;
  final ToastType type;
  final String message;
  final int durationMs;

  const AppToast({
    required this.id,
    required this.type,
    required this.message,
    this.durationMs = 2000,
  });
}

enum ToastType { success, error, info }
