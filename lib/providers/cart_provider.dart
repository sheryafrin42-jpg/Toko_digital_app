import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  Future<void> fetchCartItems() async {
    _cartItems = await DBHelper().getCartItems();
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    await DBHelper().addToCart(product);
    await fetchCartItems();
  }

  Future<void> updateQuantity(int id, int delta) async {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _cartItems[index];
      final newQty = item.quantity + delta;
      if (newQty > 0) {
        item.quantity = newQty;
        await DBHelper().updateCartItem(item);
      } else {
        await DBHelper().deleteCartItem(id);
      }
      await fetchCartItems();
    }
  }

  Future<void> removeItem(int id) async {
    await DBHelper().deleteCartItem(id);
    await fetchCartItems();
  }

  void toggleSelection(int id) {
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _cartItems[index].isSelected = !_cartItems[index].isSelected;
      notifyListeners();
    }
  }

  void toggleSelectAll(bool? value) {
    bool select = value ?? false;
    for (var item in _cartItems) {
      item.isSelected = select;
    }
    notifyListeners();
  }

  bool get isAllSelected =>
      _cartItems.isNotEmpty && _cartItems.every((item) => item.isSelected);

  int get selectedCount =>
      _cartItems.where((item) => item.isSelected).length;

  double get totalPrice {
    return _cartItems
        .where((item) => item.isSelected)
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}