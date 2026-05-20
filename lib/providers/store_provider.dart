import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class StoreUser {
  final bool isLoggedIn;
  final String name;
  final String email;

  const StoreUser({
    this.isLoggedIn = false,
    this.name = '',
    this.email = '',
  });

  StoreUser copyWith({bool? isLoggedIn, String? name, String? email}) => StoreUser(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        name: name ?? this.name,
        email: email ?? this.email,
      );
}

class StoreProvider extends ChangeNotifier {
  List<CartItem> _cart = [];
  List<WishlistItem> _wishlist = [];
  StoreUser _user = const StoreUser();
  List<AppToast> _toasts = [];
  List<AppNotification> _notifications = [];

  List<CartItem> get cart => List.unmodifiable(_cart);
  List<WishlistItem> get wishlist => List.unmodifiable(_wishlist);
  StoreUser get user => _user;
  List<AppToast> get toasts => List.unmodifiable(_toasts);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  int get wishlistCount => _wishlist.length;
  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  void addToCart(Product product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      final item = _cart[index];
      _cart = [
        ..._cart.sublist(0, index),
        CartItem(product: item.product, quantity: item.quantity + 1),
        ..._cart.sublist(index + 1),
      ];
    } else {
      _cart = [..._cart, CartItem(product: product, quantity: 1)];
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart = _cart.where((item) => item.product.id != productId).toList();
    notifyListeners();
  }

  void updateCartQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    _cart = _cart
        .map((item) => item.product.id == productId
            ? CartItem(product: item.product, quantity: quantity)
            : item)
        .toList();
    notifyListeners();
  }

  void clearCart() {
    _cart = [];
    notifyListeners();
  }

  void addToWishlist(Product product) {
    if (_wishlist.any((item) => item.product.id == product.id)) return;
    _wishlist = [
      ..._wishlist,
      WishlistItem(product: product, addedAt: DateTime.now()),
    ];
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    _wishlist = _wishlist.where((item) => item.product.id != productId).toList();
    notifyListeners();
  }

  bool isInWishlist(String productId) =>
      _wishlist.any((item) => item.product.id == productId);

  bool isInCart(String productId) =>
      _cart.any((item) => item.product.id == productId);

  void login({required String name, required String email}) {
    _user = StoreUser(isLoggedIn: true, name: name, email: email);
    notifyListeners();
  }

  void logout() {
    _user = const StoreUser();
    notifyListeners();
  }

  void addToast({required ToastType type, required String message, int durationMs = 2000}) {
    final id = _randomId();
    _toasts = [..._toasts, AppToast(id: id, type: type, message: message, durationMs: durationMs)];
    notifyListeners();
    Future.delayed(Duration(milliseconds: durationMs + 300), () {
      removeToast(id);
    });
  }

  void removeToast(String id) {
    _toasts = _toasts.where((t) => t.id != id).toList();
    notifyListeners();
  }

  void addNotification({
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
    bool isRead = false,
    String? actionUrl,
  }) {
    _notifications = [
      AppNotification(
        id: _randomId(),
        title: title,
        message: message,
        type: type,
        isRead: isRead,
        createdAt: DateTime.now(),
        actionUrl: actionUrl,
      ),
      ..._notifications,
    ];
    notifyListeners();
  }

  void markNotificationRead(String id) {
    _notifications = _notifications
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    notifyListeners();
  }

  void markAllNotificationsRead() {
    _notifications =
        _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void removeNotification(String id) {
    _notifications = _notifications.where((n) => n.id != id).toList();
    notifyListeners();
  }

  String _randomId() =>
      Random().nextInt(0x7FFFFFFF).toRadixString(36);
}
