class WishlistItem {
  final String id;
  final String name;
  final String image;
  final int price;
  final int? oldPrice;
  final String? category;

  WishlistItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.oldPrice,
    this.category,
  });
}
