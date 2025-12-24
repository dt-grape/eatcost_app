import 'package:eatcost_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/catalog/catalog_header.dart';
import '../widgets/catalog/category_tabs.dart';
import '../widgets/catalog/product_card.dart';
import '../widgets/catalog/filter_drawer.dart';
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
      price: 1,
      weight: 710,
      hasDiscount: true,
      oldPrice: 664,
      discountPercent: '-15%',
      description: 'Вкусное домашнее блюдо из натуральных продуктов',
      ingredients:
          'Гренки ржаные, картофель фри, наггетсы, картофельные дольки, хот чиз, соус барбекю, соус сырный',
      nutritionFacts: {
        'fat': 15.15,
        'protein': 15.89,
        'carbs': 16.04,
        'calories': 264.9,
      },
    ),
    Product(
      id: '2',
      name: 'Рыба на пару с овощами',
      image: 'assets/images/food2.png',
      price: 650,
      weight: 400,
    ),
    Product(
      id: '3',
      name: 'Говядина с гречкой',
      image: 'assets/images/bread.png',
      price: 580,
      weight: 450,
      hasDiscount: true,
      oldPrice: 700,
      discountPercent: '-17%',
    ),
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
              categories: const ['Пельмени и вареники', 'Рыба и полуфабрикаты'],
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
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = _products[index];
                final quantity = _cart[product.id] ?? 0;

                return ProductCard(
                  id: product.id,
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
                  onFavoriteToggle: () {},
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                );
              }, childCount: _products.length),
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
