import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/catalog/catalog_header.dart';
import '../widgets/catalog/category_tabs.dart';
import '../widgets/catalog/product_card.dart';
import '../widgets/catalog/filter_drawer.dart';
import '../models/product_api_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CatalogScreen extends StatefulWidget {
  final int? initialCategoryId;

  const CatalogScreen({super.key, this.initialCategoryId});

  @override
  State<CatalogScreen> createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String _selectedCategory;
  late int _selectedCategoryId;
  String _sortBy = 'По популярности';

  List<ProductCategory> _productCategories = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'Каталог'; // Пока не используется
    _selectedCategoryId =
        widget.initialCategoryId ?? 340; // Выпечка по умолчанию
    _loadProducts();
  }

  // Публичный метод для изменения категории извне
  void setCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  // Новый метод для установки categoryId
  void setCategoryId(int categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
    _loadProducts(); // Перезагружаем продукты при смене категории
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final apiService = ApiService();
      final categories = await apiService.getProducts(
        categoryId: _selectedCategoryId,
      );

      setState(() {
        _productCategories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // НОВЫЙ МЕТОД: Обновление без показа индикатора загрузки
  Future<void> _refreshProducts() async {
    try {
      final apiService = ApiService();
      final categories = await apiService.getProducts(
        categoryId: _selectedCategoryId,
      );

      setState(() {
        _productCategories = categories;
        _error = null;
      });
    } catch (e) {
      // При ошибке обновления показываем снэкбар, но не меняем состояние загрузки
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка обновления: ${e.toString()}'),
            action: SnackBarAction(
              label: 'Повторить',
              onPressed: _refreshProducts,
            ),
          ),
        );
      }
    }
  }

  List<Product> get _products {
    // Объединяем все продукты из всех категорий
    return _productCategories.expand((category) => category.items).toList();
  }

  String _getCategoryTitle() {
    final category = availableCategories.firstWhere(
      (cat) => cat.id == _selectedCategoryId,
      orElse: () =>
          Category(id: _selectedCategoryId, name: 'Каталог', image: ''),
    );
    return category.name;
  }

  void _openFilters() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  Future<void> _addToCart(int productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final apiService = ApiService();
      apiService.setToken(token);

      await apiService.addItemToCart(productId: productId, quantity: 1);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Товар добавлен в корзину'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF7F7F8),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF7F7F8),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 100, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки продуктов',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F7F8),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: CustomScrollView(
          slivers: [
            // Заголовок с кнопками
            SliverToBoxAdapter(
              child: CatalogHeader(
                title: _getCategoryTitle(),
                itemCount: _products
                    .length, // Обновлено: показываем реальное количество
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
                  'Готовая еда',
                  'Молочка',
                  'Хлеб',
                  'Мясо',
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

            // ОБНОВЛЕНО: Проверка на пустой список продуктов
            if (_products.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 100,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Нет товаров',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Потяните вниз для обновления',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
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
                    return ProductCard(
                      id: product.id.toString(),
                      title: product.name,
                      price: product.price.toInt(),
                      weight: '${product.weight}г',
                      imageUrl: product.image,
                      hasDiscount: product.hasDiscount,
                      onAddToCart: () => _addToCart(product.id),
                      onTap: () {
                        // TODO: Update ProductDetailScreen to use new Product model
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Детали продукта пока не реализованы',
                            ),
                          ),
                        );
                      },
                    );
                  }, childCount: _products.length),
                ),
              ),
          ],
        ),
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
