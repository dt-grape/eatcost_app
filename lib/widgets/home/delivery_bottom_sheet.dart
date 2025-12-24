import 'package:flutter/material.dart';

class DeliveryBottomSheet extends StatelessWidget {
  const DeliveryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Индикатор свайпа
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Контент
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE07B39).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.delivery_dining,
                              color: Color(0xFFE07B39),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Доставка продуктов',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Описание
                      Text(
                        'Доставляем свежие продукты питания по Новосибирску и ближайшим районам города. Особое внимание уделяем качеству хранения и соблюдению температурного режима при транспортировке.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Условия для подписчиков
                      _buildSection(
                        icon: Icons.card_membership,
                        iconColor: const Color(0xFF3D5A3E),
                        title: 'Условия доставки для подписчиков',
                        content: [
                          'Снижение стоимости доставки или бесплатная доставка от 1500₽',
                          'Приоритетная сборка и доставка — заказы подписчиков комплектуются и отправляются в первую очередь',
                          'Возможность регулярных доставок с сохранением избранного списка продуктов',
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Условия без подписки
                      _buildSection(
                        icon: Icons.local_shipping,
                        iconColor: Colors.orange,
                        title: 'Условия доставки без подписки',
                        content: [
                          'Фиксированная стоимость доставки по городу — 250₽',
                          'Бесплатная доставка от 2500₽',
                          'Сборка и доставка заказов в общем порядке без приоритета',
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Особенности доставки
                      _buildSection(
                        icon: Icons.ac_unit,
                        iconColor: Colors.blue,
                        title: 'Особенности доставки продуктов',
                        content: [
                          'Все скоропортящиеся товары доставляются с соблюдением «холодовой цепи»',
                          'Фрукты и овощи проходят визуальный контроль качества',
                          'Если товара нет в наличии, менеджер свяжется для согласования замены',
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Время доставки
                      _buildSection(
                        icon: Icons.access_time,
                        iconColor: Colors.purple,
                        title: 'Время и сроки доставки',
                        content: [
                          'Доставка в день заказа при оформлении до 14:00',
                          'Заказы после 14:00 доставляются на следующий день',
                          'При высокой нагрузке время может быть увеличено',
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Проверка заказа
                      _buildSection(
                        icon: Icons.check_circle_outline,
                        iconColor: Colors.green,
                        title: 'Проверка заказа при получении',
                        content: [
                          'Проверьте целостность упаковки и внешний вид продуктов',
                          'Убедитесь в сроках годности и температуре охлаждённых товаров',
                          'В случае брака можно отказаться от отдельных позиций',
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...content.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
