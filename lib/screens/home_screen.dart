import 'package:flutter/material.dart';
import '../widgets/home/promo_carousel.dart';
import '../widgets/home/service_cards.dart';
import '../widgets/home/category_grid.dart';
import '../models/category_model.dart';
import '../screens/catalog_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(Category)? onCategorySelected;

  const HomeScreen({
    super.key,
    this.onCategorySelected,
  });

  void _navigateToCatalog(BuildContext context) {
    // Navigate to catalog screen without a specific category
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CatalogScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          PromoCarousel(
            onTryPressed: () => _navigateToCatalog(context),
          ),
          SizedBox(height: 24),
          ServiceCards(),
          SizedBox(height: 48),
          CategoryGrid(
            onCategorySelected: onCategorySelected,
          ),
          // PromoSection(
          //   onSeeAllPressed: () => _navigateToCatalog(context),
          // ),
        ],
      ),
    );
  }
}
