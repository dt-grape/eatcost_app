import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  final Function(String)? onCategorySelected;

  const CategoryGrid({
    super.key,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'title': 'Готовая еда',
        'image': 'assets/images/ready_food.png',
      },
      {
        'title': 'Молочка',
        'image': 'assets/images/dairy.png',
      },
      {
        'title': 'Хлеб',
        'image': 'assets/images/bread.png',
      },
      {
        'title': 'Мясо',
        'image': 'assets/images/meat.png',
      },
    ];

    return Container(
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(
              context,
              categories[index]['title']!,
              categories[index]['image']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        // Вызываем callback для переключения на каталог с категорией
        onCategorySelected?.call(title);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAEEEB),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Изображение на весь контейнер
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.fastfood,
                        size: 60,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              // Название категории
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
