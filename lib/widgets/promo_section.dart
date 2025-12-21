import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../models/product_model.dart';


class PromoSection extends StatefulWidget {
  const PromoSection({super.key});

  @override
  State<PromoSection> createState() => _PromoSectionState();
}

class _PromoSectionState extends State<PromoSection> {
  // Храним состояние корзины
  final Map<String, int> _cart = {};

  void _addToCart(String productId) {
    setState(() {
      _cart[productId] = (_cart[productId] ?? 0) + 1;
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      if (_cart[productId] != null && _cart[productId]! > 0) {
        _cart[productId] = _cart[productId]! - 1;
        if (_cart[productId] == 0) {
          _cart.remove(productId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Данные продуктов
    final List<Product> products = [
      Product(
        id: '1',
        name: 'Курица (грудка) с картофелем по-домашнему',
        price: 529,
        weight: 500,
        image: 'assets/images/food.png',
        hasDiscount: true,
      ),
      Product(
        id: '2',
        name: 'Курица (грудка) с картофелем по-домашнему',
        price: 100,
        weight: 300,
        image: 'assets/images/food.png',
      ),
    ];

    return Container(
      color: const Color(0xFFFFF8F0),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок секции
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Стилизованный заголовок с "подложкой"
                Stack(
                  children: [
                    Positioned(
                      bottom: 2,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const Text(
                      'Акции',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                // Кнопка "Смотреть все"
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2C4C3B),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Смотреть все',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Горизонтальный список карточек
          SizedBox(
            height: 380,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = products[index];
                final quantity = _cart[product.id] ?? 0;

                return SizedBox(
                  width: 260,
                  child: ProductCard(
                    title: product.name,
                    price: product.price,
                    weight: '${product.weight}г',
                    imageUrl: product.image,
                    hasDiscount: product.hasDiscount,
                    isInCart: quantity > 0,
                    count: quantity,
                    onAddToCart: () => _addToCart(product.id),
                    onIncrement: () => _addToCart(product.id),
                    onDecrement: () => _removeFromCart(product.id),
                    onFavoriteToggle: () {
                      // Добавить в избранное
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
