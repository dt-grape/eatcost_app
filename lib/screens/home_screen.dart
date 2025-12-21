import 'package:eatcost_app/widgets/promo_section.dart';
import 'package:flutter/material.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/service_cards.dart';
import '../widgets/category_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          SizedBox(height: 16),
          PromoCarousel(),
          SizedBox(height: 24),
          ServiceCards(),
          SizedBox(height: 48),
          CategoryGrid(),
          PromoSection(),
        ],
      ),
    );
  }
}
