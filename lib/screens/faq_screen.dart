import 'package:flutter/material.dart';
import '../models/faq_model.dart';
import '../widgets/faq/faq_category_button.dart';
import '../widgets/faq/faq_item.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  FaqCategory? _selectedCategory;
  int? _expandedIndex;

  final List<FaqCategoryData> _categories = [
    FaqCategoryData(
      category: FaqCategory.order,
      title: 'О еде',
      icon: Icons.restaurant_menu,
    ),
    FaqCategoryData(
      category: FaqCategory.payment,
      title: 'Оплата',
      icon: Icons.payment,
    ),
    FaqCategoryData(
      category: FaqCategory.delivery,
      title: 'Доставка',
      icon: Icons.local_shipping,
    ),
    FaqCategoryData(
      category: FaqCategory.subscription,
      title: 'Подписка',
      icon: Icons.card_membership,
    ),
    FaqCategoryData(
      category: FaqCategory.discounts,
      title: 'Скидки и акции',
      icon: Icons.discount,
    ),
  ];

  final List<FaqItem> _allFaqItems = [
    // О еде
    FaqItem(
      question: 'Как оформить заказ?',
      answer:
          'Чтобы оформить заказ, добавьте нужные товары в корзину, перейдите в корзину и нажмите кнопку "Оформить заказ". Затем укажите способ доставки и оплаты.',
      category: FaqCategory.order,
    ),
    FaqItem(
      question: 'Какое минимальное количество для заказа?',
      answer: 'Минимальная сумма заказа составляет 1529 ₽.',
      category: FaqCategory.order,
    ),
    FaqItem(
      question: 'Можно ли изменить заказ после оформления?',
      answer:
          'Да, вы можете изменить заказ до начала его приготовления. Свяжитесь с нами по телефону 8 (343) 344-23-56.',
      category: FaqCategory.order,
    ),

    // Оплата
    FaqItem(
      question: 'Какие способы оплаты доступны?',
      answer:
          'Мы принимаем оплату картой онлайн (Visa, MasterCard, МИР) и наличными курьеру при получении заказа.',
      category: FaqCategory.payment,
    ),
    FaqItem(
      question: 'Безопасна ли оплата онлайн?',
      answer:
          'Да, все платежи проходят через защищенное соединение. Мы не храним данные вашей карты.',
      category: FaqCategory.payment,
    ),

    // Доставка
    FaqItem(
      question: 'Условия доставки',
      answer:
          'Заказы доставляются по Москве и ближайшему Подмосковью при стоимости от 4000 ₽. В отдалённые районы Подмосковью при сумме от 6000 ₽, сбоем до 6000₽ доставка ваши любимые продукты, избежав вас от тяжёлых сумок с экономном ваше время.\n\nДоставка возможна только во время работы рынка. Последний заказ может быть оформлен до его закрытия, а именно до 19:00. Время доставки вы можете указать в комментариях при оформлении заказа.',
      category: FaqCategory.delivery,
    ),
    FaqItem(
      question: 'Стоимость доставки',
      answer:
          '- Любыми – 350 рублей\n- Иркутск – 450 рублей\n- Районы Москвы – 500 рублей',
      category: FaqCategory.delivery,
    ),
    FaqItem(
      question: 'Можно ли забрать заказ самостоятельно?',
      answer:
          'Да, вы можете забрать заказ самостоятельно по адресу: г. Новосибирск, ул. Городская, 1А',
      category: FaqCategory.delivery,
    ),

    // Подписка
    FaqItem(
      question: 'Что такое подписка?',
      answer:
          'Подписка дает вам доступ к покупке всех товаров по себестоимости. Стоимость подписки - 400₽ в месяц.',
      category: FaqCategory.subscription,
    ),
    FaqItem(
      question: 'Как активировать подписку?',
      answer:
          'Перейдите в раздел "Подписка и управление" в профиле и выберите подходящий тариф.',
      category: FaqCategory.subscription,
    ),
    FaqItem(
      question: 'Можно ли отменить подписку?',
      answer:
          'Да, вы можете отменить подписку в любой момент. Доступ будет действовать до конца оплаченного периода.',
      category: FaqCategory.subscription,
    ),

    // Скидки и акции
    FaqItem(
      question: 'Как использовать промокод?',
      answer:
          'Введите промокод в специальное поле при оформлении заказа. Скидка будет применена автоматически.',
      category: FaqCategory.discounts,
    ),
    FaqItem(
      question: 'Можно ли использовать несколько промокодов?',
      answer: 'Нет, одновременно можно использовать только один промокод.',
      category: FaqCategory.discounts,
    ),
  ];

  List<FaqItem> get _filteredFaqItems {
    if (_selectedCategory == null) return _allFaqItems;
    return _allFaqItems
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Часто задаваемые вопросы'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Категории
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _categories.map((category) {
                    return FaqCategoryButton(
                      category: category,
                      isSelected: _selectedCategory == category.category,
                      onTap: () {
                        setState(() {
                          if (_selectedCategory == category.category) {
                            _selectedCategory = null;
                          } else {
                            _selectedCategory = category.category;
                          }
                          _expandedIndex = null;
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Список вопросов
          Expanded(
            child: _filteredFaqItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredFaqItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredFaqItems[index];
                      return FaqItemWidget(
                        item: item,
                        index: index,
                        isExpanded: _expandedIndex == index,
                        onTap: () {
                          setState(() {
                            _expandedIndex = _expandedIndex == index
                                ? null
                                : index;
                          });
                        },
                      );
                    },
                  ),
          ),

          // Контактная информация
          _buildContactSection(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.help_outline, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Нет вопросов в этой категории',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Не нашли ответ?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Свяжитесь с нами любым удобным способом',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildContactButton(
                  icon: Icons.phone,
                  label: '8 (343) 344-23-56',
                  color: const Color(0xFF3D5A3E),
                  onTap: () {
                    // TODO: Позвонить
                  },
                ),
                const SizedBox(width: 12),
                _buildContactButton(
                  icon: Icons.email,
                  label: 'support@eatcost.ru',
                  color: const Color(0xFF3D5A3E),
                  onTap: () {
                    // TODO: Написать email
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
