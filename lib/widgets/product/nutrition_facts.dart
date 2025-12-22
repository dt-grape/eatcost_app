import 'package:flutter/material.dart';

class NutritionFacts extends StatelessWidget {
  final Map<String, double> nutritionFacts;

  const NutritionFacts({
    super.key,
    required this.nutritionFacts,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildNutritionItem('жиры', nutritionFacts['fat'] ?? 0),
        _buildNutritionItem('белки', nutritionFacts['protein'] ?? 0),
        _buildNutritionItem('углеводы', nutritionFacts['carbs'] ?? 0),
        _buildNutritionItem('ккал', nutritionFacts['calories'] ?? 0),
      ],
    );
  }

  Widget _buildNutritionItem(String label, double value) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(label == 'ккал' ? 1 : 2),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
