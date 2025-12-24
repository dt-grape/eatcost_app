import 'package:flutter/material.dart';

class PickupBottomSheet extends StatelessWidget {
  const PickupBottomSheet({super.key});

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
                              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.storefront,
                              color: Color(0xFF4CAF50),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Самовывоз продуктов',
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
                        'Вы можете самостоятельно забрать заказанные продукты в нашем пункте самовывоза. Это удобно, если вы находитесь поблизости или хотите забрать заказ по дороге с работы или домой.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Как работает
                      _buildSection(
                        icon: Icons.info_outline,
                        iconColor: const Color(0xFF4CAF50),
                        title: 'Как работает самовывоз',
                        content: [
                          'Оформите заказ на сайте и выберите способ получения «Самовывоз»',
                          'Выберите удобный пункт выдачи',
                          'Дождитесь SMS или email с подтверждением готовности',
                          'Приезжайте, назовите номер заказа и получите продукты',
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Сроки готовности
                      _buildSection(
                        icon: Icons.timer,
                        iconColor: Colors.orange,
                        title: 'Сроки готовности заказа',
                        content: [
                          'Основной ассортимент готов в течение 1–2 часов',
                          'При большом количестве свежих продуктов время может быть дольше',
                          'Подписчики получают приоритет при сборке',
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Условия хранения
                      _buildSection(
                        icon: Icons.kitchen,
                        iconColor: Colors.blue,
                        title: 'Условия хранения',
                        content: [
                          'Охлаждённые продукты — в холодильных камерах',
                          'Замороженные продукты — в морозильных камерах',
                          'Остальной ассортимент — в сухих складских зонах',
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Срок хранения
                      _buildSection(
                        icon: Icons.schedule,
                        iconColor: Colors.red,
                        title: 'Срок хранения заказа',
                        content: [
                          'Заказ хранится 24 часа',
                          'После этого скоропортящиеся товары могут быть списаны',
                          'Оплата возвращается в соответствии с политикой возврата',
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Проверка
                      _buildSection(
                        icon: Icons.check_circle_outline,
                        iconColor: Colors.green,
                        title: 'Проверка и частичный отказ',
                        content: [
                          'Осмотрите продукты и проверьте сроки годности',
                          'Откажитесь от позиций с видимыми дефектами',
                          'Остальные позиции можно выкупить без изменений',
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
