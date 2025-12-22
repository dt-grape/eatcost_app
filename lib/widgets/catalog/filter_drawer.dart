import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterDrawer({
    super.key,
    required this.onApplyFilters,
  });

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  RangeValues _priceRange = const RangeValues(100, 1000);
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedBrands = {};

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'Фильтры',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Содержимое фильтров
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Диапазон цен
                  const Text(
                    'Цена',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 2000,
                    divisions: 20,
                    activeColor: const Color(0xFF3D5A3E),
                    labels: RangeLabels(
                      '${_priceRange.start.round()} ₽',
                      '${_priceRange.end.round()} ₽',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('От ${_priceRange.start.round()} ₽'),
                      Text('До ${_priceRange.end.round()} ₽'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Категории
                  const Text(
                    'Категории',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCheckboxTile(
                    'Готовая еда',
                    _selectedCategories.contains('Готовая еда'),
                    (value) {
                      setState(() {
                        if (value!) {
                          _selectedCategories.add('Готовая еда');
                        } else {
                          _selectedCategories.remove('Готовая еда');
                        }
                      });
                    },
                  ),
                  _buildCheckboxTile(
                    'Полуфабрикаты',
                    _selectedCategories.contains('Полуфабрикаты'),
                    (value) {
                      setState(() {
                        if (value!) {
                          _selectedCategories.add('Полуфабрикаты');
                        } else {
                          _selectedCategories.remove('Полуфабрикаты');
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // Бренды
                  const Text(
                    'Бренды',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCheckboxTile(
                    'Локальные производители',
                    _selectedBrands.contains('Локальные производители'),
                    (value) {
                      setState(() {
                        if (value!) {
                          _selectedBrands.add('Локальные производители');
                        } else {
                          _selectedBrands.remove('Локальные производители');
                        }
                      });
                    },
                  ),
                ],
              ),
            ),

            // Кнопки действий
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApplyFilters({
                          'priceRange': _priceRange,
                          'categories': _selectedCategories.toList(),
                          'brands': _selectedBrands.toList(),
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D5A3E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Применить фильтры',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _priceRange = const RangeValues(0, 2000);
                        _selectedCategories.clear();
                        _selectedBrands.clear();
                      });
                    },
                    child: const Text(
                      'Сбросить все',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF3D5A3E),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
