import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart/cart_item_card.dart';
import '../widgets/cart/promo_code_input.dart';
import '../widgets/cart/cart_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      // Приложение вернулось в фокус - обновляем корзину
      context.read<CartProvider>().loadCart();
    }
  }

  void _incrementItem(BuildContext context, String key, Cart cart) async {
    final item = cart.items.firstWhere((i) => i.key == key);
    await context.read<CartProvider>().editItem(key, item.quantity + 1);
  }

  void _decrementItem(BuildContext context, String key, Cart cart) async {
    final item = cart.items.firstWhere((i) => i.key == key);
    if (item.quantity <= 1) {
      _removeItem(context, key);
      return;
    }
    await context.read<CartProvider>().editItem(key, item.quantity - 1);
  }

  void _removeItem(BuildContext context, String key) async {
    await context.read<CartProvider>().removeItem(key);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Товар удален из корзины')),
      );
    }
  }

  void _clearCart(BuildContext context) {
    // TODO: Implement clear cart via API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция очистки корзины пока не реализована'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.isLoading) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F7F8),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (cartProvider.error != null) {
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
                    cartProvider.error!,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => cartProvider.loadCart(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        }

        final cart = cartProvider.cart;
        final cartItems = cart?.items ?? [];

        final totalItems = cart?.itemsCount ?? 0;
        final productsTotal = double.tryParse(cart?.totals.totalPrice ?? '0') ?? 0.0;
        final deliveryFee = 457.0; // Пока жестко закодировано
        final discount = 0.0;
        final finalTotal = productsTotal + deliveryFee - discount;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F7F8),
          body: cartItems.isEmpty
              ? _buildEmptyCart(context)
              : Column(
                  children: [
                    // Список товаров
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => cartProvider.loadCart(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return CartItemCard(
                              item: item,
                              onIncrement: () => _incrementItem(context, item.key, cart!),
                              onDecrement: () => _decrementItem(context, item.key, cart!),
                              onRemove: () => _removeItem(context, item.key),
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
                      totalItems: totalItems,
                      productsTotal: productsTotal.round(),
                      deliveryFee: deliveryFee.round(),
                      discount: discount.round(),
                      finalTotal: finalTotal.round(),
                      minimumOrderText: 'Минимальный заказ от 1529 ₽',
                      onCheckout: () {
                        // TODO: Update CheckoutScreen to use new CartItem model
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Оформление заказа пока не реалиовано'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<CartProvider>().loadCart(),
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
