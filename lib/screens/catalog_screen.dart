import 'package:flutter/material.dart';
import '../widgets/catalog_header.dart';
import '../widgets/category_tabs.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_drawer.dart';
import '../models/product_model.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedCategory = 'Пельмени и вареники';
  String _sortBy = 'По популярности';

  // Пример данных
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Курица (грудка) с картофелем по-домашнему',
      image: 'assets/images/food.png',
      price: 529,
      weight: 500,
      hasDiscount: true,
    ),
    Product(
      id: '2',
      name: 'Курица (грудка) с картофелем по-домашнему',
      image: 'assets/images/food.png',
      price: 529,
      weight: 500,
    ),
    Product(
      id: '3',
      name: 'Курица (грудка) с картофелем по-домашнему',
      image: 'assets/images/food.png',
      price: 529,
      weight: 500,
    ),
    // Добавь больше продуктов
  ];

  final Map<String, int> _cart = {}; // id продукта -> количество

  void _openFilters() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F7F8),
      body: CustomScrollView(
        slivers: [
          // Заголовок с кнопками
          SliverToBoxAdapter(
            child: CatalogHeader(
              title: 'Каталог',
              itemCount: 1000,
              sortBy: _sortBy,
              onFilterTap: _openFilters,
              onSortChanged: (value) {
                setState(() {
                  _sortBy = value;
                });
              },
            ),
          ),

          // Табы категорий
          SliverToBoxAdapter(
            child: CategoryTabs(
              categories: const [
                'Пельмени и вареники',
                'Рыба и полуфабрикаты',
              ],
              selectedCategory: _selectedCategory,
              onCategoryChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ),

          // Сетка продуктов
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16, 
                childAspectRatio: 0.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = _products[index];
                  final quantity = _cart[product.id] ?? 0;

                  return ProductCard(
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
                  );
                },
                childCount: _products.length,
              ),
            ),
          ),
        ],
      ),
      endDrawer: FilterDrawer(
        onApplyFilters: (filters) {
          // Обработка выбранных фильтров
          Navigator.pop(context);
        },
      ),
    );
  }
}
