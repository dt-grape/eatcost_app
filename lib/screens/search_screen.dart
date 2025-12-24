import 'package:eatcost_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/catalog/product_card.dart';
import '../widgets/search/search_bar_widget.dart';
import '../widgets/search/search_history_item.dart';
import '../widgets/search/popular_search_chip.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _searchHistory = [];
  bool _isSearching = false;

  final List<String> _popularSearches = [
    'Курица',
    'Рыба',
    'Говядина',
    'Овощи',
    'Салаты',
    'Супы',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadSearchHistory();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadProducts() {
    _allProducts = [
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
  }

  final Map<String, int> _cart = {};

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

  void _loadSearchHistory() {
    // TODO: Загрузить историю из SharedPreferences
    _searchHistory = ['Курица', 'Рыба', 'Салат'];
  }

  void _saveSearchHistory(String query) {
    if (query.isEmpty) return;

    setState(() {
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.sublist(0, 10);
      }
    });

    // TODO: Сохранить в SharedPreferences
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
    // TODO: Очистить SharedPreferences
  }

  void _removeFromHistory(String query) {
    setState(() {
      _searchHistory.remove(query);
    });
    // TODO: Обновить SharedPreferences
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      _isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        _filteredProducts = [];
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _performSearch(String query) {
    _searchController.text = query;
    _saveSearchHistory(query);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: SearchBarWidget(
          controller: _searchController,
          focusNode: _focusNode,
          onClear: () {
            _searchController.clear();
          },
        ),
      ),
      body: _isSearching ? _buildSearchResults() : _buildSearchSuggestions(),
    );
  }

  Widget _buildSearchSuggestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Популярные запросы
        if (_popularSearches.isNotEmpty) ...[
          const Text(
            'Популярные запросы',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches
                .map(
                  (query) => PopularSearchChip(
                    label: query,
                    onTap: () => _performSearch(query),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],

        // История поиска
        if (_searchHistory.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'История поиска',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: _clearSearchHistory,
                child: Text(
                  'Очистить',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._searchHistory.map(
            (query) => SearchHistoryItem(
              query: query,
              onTap: () => _performSearch(query),
              onRemove: () => _removeFromHistory(query),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Ничего не найдено',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить запрос',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Найдено ${_filteredProducts.length} ${_getProductWord(_filteredProducts.length)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
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
            },
          ),
        ),
      ],
    );
  }

  String _getProductWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'товар';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return 'товара';
    } else {
      return 'товаров';
    }
  }
}
