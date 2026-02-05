import 'package:eatcost_app/screens/catalog_screen.dart';
import 'package:eatcost_app/screens/profile_screen.dart';
import 'package:eatcost_app/screens/search_screen.dart';
import 'package:eatcost_app/widgets/app/app_drawer.dart';
import 'package:eatcost_app/widgets/app/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import '../models/category_model.dart';
import '../providers/cart_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Load cart when main screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartProvider>().loadCart();
      }
    });
  }

  // Ключи для управления состоянием экранов
  final GlobalKey<CatalogScreenState> _catalogKey = GlobalKey<CatalogScreenState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigateToCatalogWithCategory(Category category) {
    setState(() {
      _selectedIndex = 1; // Индекс CatalogScreen
      _selectedCategory = category;
    });

    // Применяем категорию после перехода
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedCategory != null) {
        _catalogKey.currentState?.setCategory(_selectedCategory!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        title: const Text('EatCost'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            onCategorySelected: navigateToCatalogWithCategory,
          ),
          CatalogScreen(
            key: _catalogKey,
            initialCategory: _selectedCategory,
          ),
          const CartScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
