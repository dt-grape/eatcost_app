import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product/product_image_carousel.dart';
import '../widgets/product/product_info.dart';
import '../widgets/product/nutrition_facts.dart';
import '../widgets/product/quantity_selector.dart';
import '../widgets/product/product_tabs.dart';
import '../widgets/product/add_to_cart_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() {
    // Логика добавления в корзину
  }

  void _toggleFavorite() {
    // Логика добавления в избранное
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Карусель изображений
          ProductImageCarousel(
            imageUrl: widget.product.image,
            hasDiscount: widget.product.hasDiscount,
            discountPercent: widget.product.discountPercent,
            onFavoriteToggle: _toggleFavorite,
          ),

          // Основной контент
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Информация о продукте
                  ProductInfo(
                    name: widget.product.name,
                    weight: widget.product.weight,
                    ingredients: widget.product.ingredients,
                  ),

                  // КБЖУ
                  if (widget.product.nutritionFacts != null) ...[
                    NutritionFacts(
                      nutritionFacts: widget.product.nutritionFacts!,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Цена и счетчик
                  QuantitySelector(
                    price: widget.product.price,
                    oldPrice: widget.product.oldPrice,
                    quantity: _quantity,
                    onIncrement: _incrementQuantity,
                    onDecrement: _decrementQuantity,
                  ),
                  const SizedBox(height: 24),

                  // Табы с описанием
                  ProductTabs(
                    description: widget.product.description,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Нижняя кнопка
      bottomNavigationBar: AddToCartBar(
        quantity: _quantity,
        onAddToCart: _addToCart,
        onFavoriteToggle: _toggleFavorite,
      ),
    );
  }
}
