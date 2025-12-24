import 'package:flutter/material.dart';
import '../models/wishlist_item_model.dart';
import '../widgets/wishlist/wishlist_item_card.dart';
import '../widgets/wishlist/empty_wishlist.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Моковые данные
  final List<WishlistItem> _wishlistItems = [
    WishlistItem(
      id: '1',
      name: 'Курица (грудка) с картофелем по-домашнему',
      image: 'assets/images/food.png',
      price: 529,
      oldPrice: 650,
      category: 'Готовые блюда',
    ),
    WishlistItem(
      id: '2',
      name: 'Хлебная нарезка',
      image: 'assets/images/bread.png',
      price: 450,
      category: 'Выпечка',
    ),
    WishlistItem(
      id: '3',
      name: 'Борщ украинский с говядиной',
      image: 'assets/images/food2.png',
      price: 350,
      oldPrice: 400,
      category: 'Супы',
    ),
  ];

  void _removeFromWishlist(String id) {
    setState(() {
      _wishlistItems.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Товар удален из избранного'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _addToCart(WishlistItem item) {
    // Логика добавления в корзину
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} добавлен в корзину'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Перейти',
          onPressed: () {
            // Переход в корзину
          },
        ),
      ),
    );
  }

  void _clearWishlist() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить избранное?'),
        content: const Text('Все товары будут удалены из избранного'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _wishlistItems.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Избранное очищено')),
              );
            },
            child: const Text(
              'Очистить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        title: const Text(
          'Избранное',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_wishlistItems.isNotEmpty)
            TextButton.icon(
              onPressed: _clearWishlist,
              icon: const Icon(Icons.delete_outline, size: 20),
              label: const Text('Очистить'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
              ),
            ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: _wishlistItems.isEmpty
          ? EmptyWishlist(
        onBrowseProducts: () {
          // Переход в каталог (используй свою навигацию)
          Navigator.pop(context);
        },
      )
          : Column(
        children: [
          // Количество товаров
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Text(
              '${_wishlistItems.length} товаров в избранном',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          // Список товаров
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _wishlistItems.length,
              itemBuilder: (context, index) {
                final item = _wishlistItems[index];
                return WishlistItemCard(
                  item: item,
                  onRemove: () => _removeFromWishlist(item.id),
                  onAddToCart: () => _addToCart(item),
                );
              },
            ),
          ),

          // Кнопка "Добавить все в корзину"
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Все товары добавлены в корзину'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text(
                    'Добавить все в корзину',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D5A3E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
