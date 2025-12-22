import 'package:flutter/material.dart';

class ProductTabs extends StatefulWidget {
  final String? description;

  const ProductTabs({
    super.key,
    this.description,
  });

  @override
  State<ProductTabs> createState() => _ProductTabsState();
}

class _ProductTabsState extends State<ProductTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Табы
        Row(
          children: [
            _buildTab('Описание', 0),
            const SizedBox(width: 12),
            _buildTab('Доставка', 1),
            const SizedBox(width: 12),
            _buildTab('Оплата', 2),
          ],
        ),
        const SizedBox(height: 16),

        // Контент
        _buildTabContent(),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C4C3B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2C4C3B) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return Text(
          widget.description ?? 'Вкусное блюдо из свежих и натуральных продуктов.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            height: 1.5,
          ),
        );
      case 1:
        return const Text(
          'Доставка осуществляется ежедневно с 9:00 до 21:00. Минимальная сумма заказа - 500₽.',
          style: TextStyle(fontSize: 14, height: 1.5),
        );
      case 2:
        return const Text(
          'Оплата картой при получении или онлайн на сайте.',
          style: TextStyle(fontSize: 14, height: 1.5),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
