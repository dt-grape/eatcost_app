import 'package:eatcost_app/widgets/home/promo_section.dart';
import 'package:flutter/material.dart';
import '../widgets/home/promo_carousel.dart';
import '../widgets/home/service_cards.dart';
import '../widgets/home/category_grid.dart';

class HomeScreen extends StatelessWidget {
  final Function(String)? onCategorySelected;

  const HomeScreen({
    super.key,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          PromoCarousel(),
          SizedBox(height: 24),
          ServiceCards(),
          SizedBox(height: 48),
          CategoryGrid(
            onCategorySelected: onCategorySelected,
          ),
          PromoSection(),
        ],
      ),
    );
  }
}
