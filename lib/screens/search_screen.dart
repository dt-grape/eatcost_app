import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_api_model.dart';
import '../providers/cart_provider.dart';
import '../widgets/catalog/product_card.dart';
import '../widgets/search/search_bar_widget.dart';
import '../widgets/search/search_history_item.dart';
import '../widgets/search/popular_search_chip.dart';
import '../services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Product> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isSearching = false;
  bool _isLoading = false;
  String? _error;
  int _resultCount = 0;

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
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  void _saveSearchHistory(String query) async {
    if (query.isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.sublist(0, 10);
      }
    });
    await prefs.setStringList('search_history', _searchHistory);
  }

  void _clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.clear();
    });
    await prefs.remove('search_history');
  }

  void _removeFromHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.remove(query);
    });
    await prefs.setStringList('search_history', _searchHistory);
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    _searchController.text = query;
    _saveSearchHistory(query);
    _focusNode.unfocus();

    setState(() {
      _isSearching = true;
      _isLoading = true;
      _error = null;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.searchProducts(query: query);
      
      setState(() {
        _searchResults = response['results'] ?? [];
        _resultCount = response['count'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _searchResults = [];
      });
    }
  }

  // Добавление товара в корзину
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: ${e.toString()}')),
        );
      }
    }
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
            setState(() {
              _isSearching = false;
              _searchResults = [];
            });
          },
          onSubmitted: _performSearch,
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ошибка при поиске',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _performSearch(_searchController.text),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
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
            'Найдено $_resultCount ${_getProductWord(_resultCount)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final product = _searchResults[index];
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
