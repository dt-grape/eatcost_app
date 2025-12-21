import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final int price;
  final String weight;
  final String imageUrl;
  final bool hasDiscount;
  final bool isInCart;
  final int count;
  final VoidCallback onAddToCart;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.weight,
    required this.imageUrl,
    this.hasDiscount = false,
    this.isInCart = false,
    this.count = 0,
    required this.onAddToCart,
    required this.onIncrement,
    required this.onDecrement,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Картинка + Бейджи
          Stack(
            children: [
              // Само изображение
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              
              // Бейдж "АКЦИЯ"
              if (hasDiscount)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF09C3C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'АКЦИЯ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              
              // Кнопка "Лайк"
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Название
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const Spacer(),

          // Цена и Вес
          Row(
            children: [
              Text(
                '$price ₽',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' / шт.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                weight,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Кнопка (Логика отображения: Корзина или Счетчик)
          if (!isInCart)
            // Вариант 1: Зеленая кнопка "В корзину"
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onAddToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C4C3B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.shopping_basket_outlined, color: Colors.white),
                label: const Text(
                  'В корзину',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            // Вариант 2: Счетчик количества
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onDecrement,
                    icon: const Icon(Icons.remove, color: Colors.black),
                  ),
                  Text(
                    '$count шт.',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: onIncrement,
                    icon: const Icon(Icons.add, color: Colors.black),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
