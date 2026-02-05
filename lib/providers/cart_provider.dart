import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';

class CartProvider extends ChangeNotifier {
  Cart? _cart;
  bool _isLoading = false;
  String? _error;

  Cart? get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get itemCount => _cart?.itemsCount ?? 0;

  Future<void> loadCart() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final apiService = ApiService();
      apiService.setToken(token);
      final cart = await apiService.getCart();

      _cart = cart;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(int productId, int quantity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final apiService = ApiService();
      apiService.setToken(token);

      await apiService.addItemToCart(productId: productId, quantity: quantity);

      // Reload cart to get updated count
      await loadCart();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeItem(String productKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final apiService = ApiService();
      apiService.setToken(token);

      final updatedCart = await apiService.removeItemFromCart(productKey: productKey);

      _cart = updatedCart;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> editItem(String key, int quantity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final apiService = ApiService();
      apiService.setToken(token);

      await apiService.editCartItem(key: key, quantity: quantity);

      // Reload cart to get updated count
      await loadCart();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}