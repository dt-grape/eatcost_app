class Category {
  final int id;
  final String name;
  final String image;

  const Category({
    required this.id,
    required this.name,
    required this.image,
  });
}

// Список доступных категорий
const List<Category> availableCategories = [
  Category(id: 340, name: 'Выпечка', image: ''),
  Category(id: 344, name: 'Готовые блюда', image: ''),
  Category(id: 328, name: 'Гриль', image: ''),
  Category(id: 390, name: 'Замороженные изделия', image: ''),
  Category(id: 355, name: 'Молочная продукция', image: ''),
  Category(id: 377, name: 'Мясные изделия', image: ''),
  Category(id: 343, name: 'Пицца', image: ''),
  Category(id: 396, name: 'Продовольственные товары', image: ''),
  Category(id: 437, name: 'Сопутствующие товары', image: ''),
  Category(id: 335, name: 'Стрит-фуд', image: ''),
  Category(id: 341, name: 'Сухарики и хлебная нарезка', image: ''),
  Category(id: 339, name: 'Фритюр', image: ''),
];
