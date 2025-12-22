import 'package:flutter/material.dart';

class AddToCartBar extends StatelessWidget {
  final int quantity;
  final VoidCallback onAddToCart;
  final VoidCallback onFavoriteToggle;

  const AddToCartBar({
    super.key,
    required this.quantity,
    required this.onAddToCart,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Кнопка избранного
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_outline),
                onPressed: onFavoriteToggle,
              ),
            ),
            const SizedBox(width: 12),

            // Кнопка "В корзину"
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  onAddToCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Добавлено $quantity шт. в корзину'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C4C3B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(
                  Icons.shopping_basket_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'В корзину',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
