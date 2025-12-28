import 'package:flutter/material.dart';
import '../../models/category_model.dart';

class CategoryGrid extends StatelessWidget {
  final Function(int)? onCategorySelected;

  const CategoryGrid({
    super.key,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
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
          itemCount: availableCategories.length,
          itemBuilder: (context, index) {
            final category = availableCategories[index];
            return _buildCategoryCard(
              context,
              category.name,
              category.image,
              category.id,
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
    int categoryId,
  ) {
    return GestureDetector(
      onTap: () {
        // Вызываем callback для переключения на каталог с категорией
        onCategorySelected?.call(categoryId);
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
