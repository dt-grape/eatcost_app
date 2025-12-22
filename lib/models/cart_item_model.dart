class CartItem {
  final String id;
  final String name;
  final String image;
  final int price;
  final int weight;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.weight,
    required this.quantity,
  });

  int get totalPrice => price * quantity;
}
