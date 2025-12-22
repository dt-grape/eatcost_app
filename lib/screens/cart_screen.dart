import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../widgets/cart/cart_item_card.dart';
import '../widgets/cart/promo_code_input.dart';
import '../widgets/cart/cart_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      name: 'Курица (грудка) с картофелем по-домашнему',
      image: 'assets/images/food.png',
      price: 529,
      weight: 500,
      quantity: 1,
    ),
    CartItem(
      id: '2',
      name: 'Курица (грудка) с картофелем по-домашнему',
      image: 'assets/images/food2.png',
      price: 312,
      weight: 122,
      quantity: 1,
    ),
  ];

  int get _totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  int get _productsTotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  int get _deliveryFee => 457;
  int get _discount => 0;
  int get _finalTotal => _productsTotal + _deliveryFee - _discount;

  void _incrementItem(String id) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item.id == id);
      item.quantity++;
    });
  }

  void _decrementItem(String id) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item.id == id);
      if (item.quantity > 1) {
        item.quantity--;
      }
    });
  }

  void _removeItem(String id) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Товар удален из корзины')));
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить корзину?'),
        content: const Text('Все товары будут удалены из корзины'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Очистить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: _cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Корзина',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_cartItems.isNotEmpty)
                        TextButton.icon(
                          onPressed: _clearCart,
                          icon: const Icon(Icons.delete_outline, size: 20),
                          label: const Text('Очистить'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                          ),
                        ),
                    ],
                  ),
                ),
                // Список товаров
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return CartItemCard(
                        item: item,
                        onIncrement: () => _incrementItem(item.id),
                        onDecrement: () => _decrementItem(item.id),
                        onRemove: () => _removeItem(item.id),
                        onFavorite: () {
                          // Добавить в избранное
                        },
                      );
                    },
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
                const SizedBox(height: 16),

                // Итоговая сводка
                CartSummary(
                  totalItems: _totalItems,
                  productsTotal: _productsTotal,
                  deliveryFee: _deliveryFee,
                  discount: _discount,
                  finalTotal: _finalTotal,
                  minimumOrderText: 'Минимальный заказ от 1529 ₽',
                  onCheckout: () {
                    // Оформление заказа
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Переход к оформлению заказа'),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
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
        ],
      ),
    );
  }
}
