class CartItem {
  final String key;
  final int id;
  final String name;
  final int quantity;
  final String type;
  final String sku;
  final String permalink;
  final String? image;
  final String price;
  final String regularPrice;
  final String salePrice;
  final String lineTotal;

  CartItem({
    required this.key,
    required this.id,
    required this.name,
    required this.quantity,
    required this.type,
    required this.sku,
    required this.permalink,
    required this.image,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.lineTotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      key: json['key'],
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      type: json['type'],
      sku: json['sku'] ?? '',
      permalink: json['permalink'],
      image: json['image'],
      price: json['price'],
      regularPrice: json['regular_price'],
      salePrice: json['sale_price'],
      lineTotal: json['line_total'],
    );
  }
}

class CartTotals {
  final String totalItems;
  final String totalPrice;
  final String currencyCode;
  final String currencySymbol;
  final String currencySuffix;

  CartTotals({
    required this.totalItems,
    required this.totalPrice,
    required this.currencyCode,
    required this.currencySymbol,
    required this.currencySuffix,
  });

  factory CartTotals.fromJson(Map<String, dynamic> json) {
    return CartTotals(
      totalItems: json['total_items'],
      totalPrice: json['total_price'],
      currencyCode: json['currency_code'],
      currencySymbol: json['currency_symbol'],
      currencySuffix: json['currency_suffix'],
    );
  }
}

class ShippingRate {
  final int packageId;
  final String name;
  final List<Map<String, dynamic>> items;
  final List<dynamic> shippingRates;

  ShippingRate({
    required this.packageId,
    required this.name,
    required this.items,
    required this.shippingRates,
  });

  factory ShippingRate.fromJson(Map<String, dynamic> json) {
    return ShippingRate(
      packageId: json['package_id'],
      name: json['name'],
      items: List<Map<String, dynamic>>.from(json['items']),
      shippingRates: json['shipping_rates'],
    );
  }
}

class Cart {
  final List<CartItem> items;
  final CartTotals totals;
  final int itemsCount;
  final bool needsPayment;
  final bool needsShipping;
  final List<ShippingRate> shippingRates;
  final List<String> paymentMethods;

  Cart({
    required this.items,
    required this.totals,
    required this.itemsCount,
    required this.needsPayment,
    required this.needsShipping,
    required this.shippingRates,
    required this.paymentMethods,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totals: CartTotals.fromJson(json['totals']),
      itemsCount: json['items_count'],
      needsPayment: json['needs_payment'],
      needsShipping: json['needs_shipping'],
      shippingRates: (json['shipping_rates'] as List)
          .map((rate) => ShippingRate.fromJson(rate))
          .toList(),
      paymentMethods: List<String>.from(json['payment_methods']),
    );
  }
}
