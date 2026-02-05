import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final itemCount = cartProvider.itemCount;

        return BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Главная',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Каталог',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: itemCount > 0 ? Text(itemCount.toString()) : null,
                child: const Icon(Icons.shopping_bag),
              ),
              activeIcon: Badge(
                label: itemCount > 0 ? Text(itemCount.toString()) : null,
                child: const Icon(Icons.shopping_bag),
              ),
              label: 'Корзина',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: const Color(0xFF2F5630),
          unselectedItemColor: Colors.grey,
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 8,
        );
      },
    );
  }
}
