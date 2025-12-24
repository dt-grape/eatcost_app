class OrderModel {
  final String orderNumber;
  final int totalPrice;
  final int itemCount;
  final OrderStatus status;
  final String date;
  final String address;
  final List<String> dishImages;
  final String recipient;
  final String phone;
  final String paymentMethod;
  final List<OrderItem> items;
  final int deliveryPrice;

  OrderModel({
    required this.orderNumber,
    required this.totalPrice,
    required this.itemCount,
    required this.status,
    required this.date,
    required this.address,
    required this.dishImages,
    required this.recipient,
    required this.phone,
    required this.paymentMethod,
    required this.items,
    required this.deliveryPrice,
  });

  int get subtotal => totalPrice - deliveryPrice;
}

class OrderItem {
  final String name;
  final int price;
  final int quantity;
  final String weight;
  final String imageUrl;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.weight,
    required this.imageUrl,
  });
}

enum OrderStatus {
  pending,
  cancelled,
  completed,
  inProgress,
}
