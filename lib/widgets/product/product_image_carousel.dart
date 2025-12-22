import 'package:flutter/material.dart';

class ProductImageCarousel extends StatelessWidget {
  final String imageUrl;
  final bool hasDiscount;
  final String? discountPercent;
  final VoidCallback onFavoriteToggle;

  const ProductImageCarousel({
    super.key,
    required this.imageUrl,
    this.hasDiscount = false,
    this.discountPercent,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_outline, color: Colors.white),
          onPressed: onFavoriteToggle,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Карусель изображений
            PageView(
              children: [
                Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.fastfood, size: 80),
                  ),
                ),
              ],
            ),

            // Бейдж АКЦИЯ
            if (hasDiscount)
              Positioned(
                top: 60,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF09C3C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    discountPercent ?? '-15%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

            // Индикаторы точек
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  1,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == 0
                          ? const Color(0xFF2C4C3B)
                          : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
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
