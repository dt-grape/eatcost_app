import 'package:eatcost_app/widgets/home/promo_section.dart';
import 'package:flutter/material.dart';
import '../widgets/home/promo_carousel.dart';
import '../widgets/home/service_cards.dart';
import '../widgets/home/category_grid.dart';

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
