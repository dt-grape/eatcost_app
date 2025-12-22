import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final String name;
  final int weight;
  final String? ingredients;

  const ProductInfo({
    super.key,
    required this.name,
    required this.weight,
    this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Название
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),

        // Вес и описание
        Text(
          '$weight г, из натуральных продуктов',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),

        // Состав
        if (ingredients != null) ...[
          Text(
            ingredients!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
