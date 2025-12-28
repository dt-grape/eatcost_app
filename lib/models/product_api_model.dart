class ProductCategory {
  final String categoryName;
  final List<Product> items;

  ProductCategory({
    required this.categoryName,
    required this.items,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      categoryName: json['category_name'],
      items: (json['items'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String slug;
  final String permalink;
  final String dateCreated;
  final String dateModified;
  final String type;
  final String status;
  final num price;
  final num regularPrice;
  final num salePrice;
  final String stockStatus;
  final List<ProductCategoryInfo> categories;
  final List<String> images;
  final List<ProductAttribute> attributes;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.permalink,
    required this.dateCreated,
    required this.dateModified,
    required this.type,
    required this.status,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.stockStatus,
    required this.categories,
    required this.images,
    required this.attributes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      permalink: json['permalink'],
      dateCreated: json['date_created'],
      dateModified: json['date_modified'],
      type: json['type'],
      status: json['status'],
      price: json['price'] ?? 0,
      regularPrice: json['regular_price'] ?? 0,
      salePrice: json['sale_price'] ?? 0,
      stockStatus: json['stock_status'],
      categories: (json['categories'] as List?)
              ?.map((cat) => ProductCategoryInfo.fromJson(cat))
              .toList() ??
          [],
      images: List<String>.from(json['images'] ?? []),
      attributes: (json['attributes'] as List?)
              ?.map((attr) => ProductAttribute.fromJson(attr))
              .toList() ??
          [],
    );
  }

  // Геттеры для совместимости с существующей моделью
  String get image => images.isNotEmpty ? images.first : '';
  int get weight => 0; // Нет в API, возвращаем 0
  bool get hasDiscount => salePrice < regularPrice && salePrice > 0;
  int? get oldPrice => hasDiscount ? regularPrice.toInt() : null;
  String? get discountPercent {
    if (hasDiscount) {
      final discount = ((regularPrice - salePrice) / regularPrice * 100).round();
      return '-$discount%';
    }
    return null;
  }
}

class ProductCategoryInfo {
  final Map<String, dynamic> properties;

  ProductCategoryInfo({required this.properties});

  factory ProductCategoryInfo.fromJson(Map<String, dynamic> json) {
    return ProductCategoryInfo(properties: json);
  }
}

class ProductAttribute {
  final int id;
  final String name;
  final String taxonomy;
  final bool hasVariations;
  final List<ProductAttributeTerm> terms;

  ProductAttribute({
    required this.id,
    required this.name,
    required this.taxonomy,
    required this.hasVariations,
    required this.terms,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      id: json['id'],
      name: json['name'],
      taxonomy: json['taxonomy'],
      hasVariations: json['has_variations'] ?? false,
      terms: (json['terms'] as List?)
              ?.map((term) => ProductAttributeTerm.fromJson(term))
              .toList() ??
          [],
    );
  }
}

class ProductAttributeTerm {
  final int id;
  final String name;
  final String slug;

  ProductAttributeTerm({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ProductAttributeTerm.fromJson(Map<String, dynamic> json) {
    return ProductAttributeTerm(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
    );
  }
}
