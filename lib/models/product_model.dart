class Product {
  final String id;
  final String name;
  final String image;
  final int price;
  final int weight;
  final bool hasDiscount;
  final int? oldPrice; 
  final String? discountPercent; 
  final String? description; 
  final String? ingredients; 
  final Map<String, double>? nutritionFacts;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    this.hasDiscount = false,
    this.oldPrice,
    this.discountPercent,
    this.description,
    this.ingredients,
    this.nutritionFacts,
  });
}
