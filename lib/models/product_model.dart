class Product {
  final String id;
  final String name;
  final String image;
  final int price;
  final int weight;
  final bool hasDiscount;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    this.hasDiscount = false,
  });
}
