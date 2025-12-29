import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';
import '../widgets/cart/cart_item_card.dart';
import '../widgets/cart/promo_code_input.dart';
import '../widgets/cart/cart_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with WidgetsBindingObserver {
  Cart? _cart;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCart();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Приложение вернулось в фокус - обновляем корзину
      _loadCart();
    }
  }

  Future<void> _loadCart() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final apiService = ApiService();
      apiService.setToken(token);
      final cart = await apiService.getCart();

      setState(() {
        _cart = cart;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  int get _totalItems => _cart?.itemsCount ?? 0;
  double get _productsTotal => double.tryParse(_cart?.totals.totalPrice ?? '0') ?? 0.0;
  double get _deliveryFee => 457.0; // Пока жестко закодировано
  double get _discount => 0.0;
  double get _finalTotal => _productsTotal + _deliveryFee - _discount;

  bool _isUpdating = false;

  Future<void> _incrementItem(String key) async {
    if (_isUpdating) return; // Предотвращаем множественные нажатия

    final item = _cart!.items.firstWhere((i) => i.key == key);

    setState(() {
      _isUpdating = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final apiService = ApiService();
      apiService.setToken(token);

      await apiService.editCartItem(key: key, quantity: item.quantity + 1);

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedCart = await apiService.getCart();
      setState(() {
        _cart = updatedCart;
        _isUpdating = false;
      });
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
      }
      _loadCart();
    }
  }

  // То же самое для _decrementItem
  Future<void> _decrementItem(String key) async {
    if (_isUpdating) return;

    final item = _cart!.items.firstWhere((i) => i.key == key);

    if (item.quantity <= 1) {
      _removeItem(key);
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final apiService = ApiService();
      apiService.setToken(token);

      await apiService.editCartItem(key: key, quantity: item.quantity - 1);

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedCart = await apiService.getCart();
      setState(() {
        _cart = updatedCart;
        _isUpdating = false;
      });
    } catch (e) {
      setState(() {
        _isUpdating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
      }
      _loadCart();
    }
  }

  Future<void> _removeItem(String key) async {
    // Оптимистичное обновление UI
    final removedItem = _cart!.items.firstWhere((i) => i.key == key);

    setState(() {
      final updatedItems = _cart!.items.where((i) => i.key != key).toList();

      _cart = Cart(
        items: updatedItems,
        totals: _cart!.totals,
        itemsCount: _cart!.itemsCount - removedItem.quantity,
        needsPayment: _cart!.needsPayment,
        needsShipping: _cart!.needsShipping,
        shippingRates: _cart!.shippingRates,
        paymentMethods: _cart!.paymentMethods,
      );
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final apiService = ApiService();
      apiService.setToken(token);

      final updatedCart = await apiService.removeItemFromCart(productKey: key);
      setState(() {
        _cart = updatedCart;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Товар удален из корзины')),
        );
      }
    } catch (e) {
      _loadCart();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
      }
    }
  }

  void _clearCart() {
    // TODO: Implement clear cart via API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция очистки корзины пока не реализована'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F8),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F7F8),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 100, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки корзины',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadCart,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    final cartItems = _cart?.items ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                // Список товаров
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadCart,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return CartItemCard(
                          item: item,
                          onIncrement: () => _incrementItem(item.key),
                          onDecrement: () => _decrementItem(item.key),
                          onRemove: () => _removeItem(item.key),
                        );
                      },
                    ),
                  ),
                ),

                // Промокод
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: PromoCodeInput(
                    onApply: () {
                      // Применить промокод
                    },
                  ),
                ),

                // Итоговая сводка
                CartSummary(
                  totalItems: _totalItems,
                  productsTotal: _productsTotal.round(),
                  deliveryFee: _deliveryFee.round(),
                  discount: _discount.round(),
                  finalTotal: _finalTotal.round(),
                  minimumOrderText: 'Минимальный заказ от 1529 ₽',
                  onCheckout: () {
                    // TODO: Update CheckoutScreen to use new CartItem model
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Оформление заказа пока не реализовано'),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return RefreshIndicator(
      onRefresh: _loadCart,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Корзина пуста',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Добавьте товары из каталога',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Потяните вниз для обновления',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
