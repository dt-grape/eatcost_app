import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/catalog/product_card.dart';
import '../widgets/catalog/filter_drawer.dart';
import '../models/product_api_model.dart';
import '../models/category_model.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';

class CatalogScreen extends StatefulWidget {
  final Category? initialCategory;

  const CatalogScreen({super.key, this.initialCategory});

  @override
  State<CatalogScreen> createState() => CatalogScreenState();
}

class CatalogScreenState extends State<CatalogScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _sortBy = 'По популярности';

  List<Category> _categoryPath = [];
  List<Category> _subcategories = [];
  List<ProductCategory> _productCategories = [];
  bool _isLoading = true;
  String? _error;
  bool _showingProducts = false;

  @override
  void initState() {
    super.initState();
    final initialCategory = widget.initialCategory;
    if (initialCategory != null) {
      setState(() {
        _categoryPath = [initialCategory];
      });
      _navigateToCategory(initialCategory.id);
    } else {
      _loadInitial();
    }
  }

  Future<void> _loadInitial() async {
    // If no initial category, show all parent categories
    await _loadSubcategories(0);
  }

  // Новый метод для установки category
  void setCategory(Category category) {
    setState(() {
      _categoryPath = [category];
    });
    _navigateToCategory(category.id);
  }

  Future<void> _navigateToCategory(int categoryId) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final apiService = ApiService();
      final subcategories = await apiService.getCategories(
        parentCategoryId: categoryId,
      );

      if (subcategories.isNotEmpty) {
        // Has subcategories, show them
        setState(() {
          _subcategories = subcategories;
          _showingProducts = false;
          _isLoading = false;
        });
      } else {
        // No subcategories, load products
        await _loadProducts(categoryId);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSubcategories(int parentCategoryId) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final apiService = ApiService();
      final subcategories = await apiService.getCategories(
        parentCategoryId: parentCategoryId,
      );

      setState(() {
        _subcategories = subcategories;
        _showingProducts = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProducts(int categoryId) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final apiService = ApiService();
      final categories = await apiService.getProducts(categoryId: categoryId);

      setState(() {
        _productCategories = categories;
        _showingProducts = true;
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
    if (_showingProducts && _categoryPath.isNotEmpty) {
      final currentCategoryId = _categoryPath.last.id;
      try {
        final apiService = ApiService();
        final categories = await apiService.getProducts(
          categoryId: currentCategoryId,
        );

        setState(() {
          _productCategories = categories;
          _error = null;
        });
      } catch (e) {
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
  }

  List<Product> get _products {
    return _productCategories.expand((category) => category.items).toList();
  }

  String _getCategoryTitle() {
    if (_categoryPath.isEmpty) return 'Каталог';
    return _categoryPath.last.name;
  }

  bool get _canGoBack => _categoryPath.isNotEmpty;

  void _goBack() {
    if (_categoryPath.isNotEmpty) {
      setState(() {
        _categoryPath.removeLast();
      });
      if (_categoryPath.isEmpty) {
        _loadInitial();
      } else {
        final parentId = _categoryPath.last.id;
        _loadSubcategories(parentId);
      }
    }
  }

  void _onSubcategorySelected(int categoryId, String categoryName) {
    final category = Category(id: categoryId, name: categoryName, image: '');
    setState(() {
      _categoryPath.add(category);
    });
    _navigateToCategory(categoryId);
  }

  void _openFilters() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  Future<void> _addToCart(int productId) async {
    try {
      await context.read<CartProvider>().addItem(productId, 1);

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
        appBar: AppBar(
          leading: _canGoBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBack,
                )
              : null,
          title: Text(_getCategoryTitle()),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF7F7F8),
        appBar: AppBar(
          leading: _canGoBack
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBack,
                )
              : null,
          title: Text(_getCategoryTitle()),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 100, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки',
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
                onPressed: () {
                  if (_showingProducts && _categoryPath.isNotEmpty) {
                    _loadProducts(_categoryPath.last.id);
                  } else {
                    final parentId = _categoryPath.isNotEmpty
                        ? _categoryPath.last.id
                        : 0;
                    _loadSubcategories(parentId);
                  }
                },
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
      appBar: AppBar(
        leading: _canGoBack
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _goBack)
            : null,
        title: Text(_getCategoryTitle()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: _showingProducts
            ? [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _openFilters,
                ),
              ]
            : null,
      ),
      body: _showingProducts ? _buildProductsView() : _buildCategoriesView(),
      endDrawer: _showingProducts
          ? FilterDrawer(
              onApplyFilters: (filters) {
                // Обработка выбранных фильтров
                Navigator.pop(context);
              },
            )
          : null,
    );
  }

  Widget _buildCategoriesView() {
    return RefreshIndicator(
      onRefresh: () async {
        final parentId = _categoryPath.isNotEmpty ? _categoryPath.last.id : 0;
        await _loadSubcategories(parentId);
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: _subcategories.length,
        itemBuilder: (context, index) {
          final category = _subcategories[index];
          return _buildCategoryCard(category);
        },
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () => _onSubcategorySelected(category.id, category.name),
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
                child: category.image.isNotEmpty
                    ? Image.network(
                        category.image,
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
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.fastfood,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
              ),
              // Название категории
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Text(
                  category.name,
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

  Widget _buildProductsView() {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      child: CustomScrollView(
        slivers: [
          // Заголовок с кнопками
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '${_products.length} товаров',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: _sortBy,
                    items: const [
                      DropdownMenuItem(
                        value: 'По популярности',
                        child: Text('По популярности'),
                      ),
                      DropdownMenuItem(
                        value: 'По цене',
                        child: Text('По цене'),
                      ),
                      DropdownMenuItem(
                        value: 'По названию',
                        child: Text('По названию'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _sortBy = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Детали продукта пока не реализованы'),
                        ),
                      );
                    },
                  );
                }, childCount: _products.length),
              ),
            ),
        ],
      ),
    );
  }
}
