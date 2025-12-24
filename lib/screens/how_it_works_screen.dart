import 'package:flutter/material.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> steps = [
      {
        'title':
            'В личном кабинете или приложении вы видите свой персональный QR-код',
        'icon': Icons.qr_code,
      },
      {
        'title': 'Кассир сканирует его при покупке',
        'icon': Icons.qr_code_scanner,
      },
      {
        'title': 'Система мгновенно проверяет статус подписки',
        'icon': Icons.speed,
      },
      {
        'title':
            'На экране отображается результат: активна ли подписка, имя клиента и срок действия',
        'icon': Icons.check_circle,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Как это работает"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(
            steps.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildStepCard(
                stepNumber: index + 1,
                title: steps[index]['title'],
                icon: steps[index]['icon'],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildStepCard({
    required int stepNumber,
    required String title,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Иконка с круглым фоном
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F8),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                // Основная иконка
                Center(
                  child: Icon(
                    icon,
                    size: 50,
                    color: const Color(0xFF3D5A3E),
                  ),
                ),
                // Номер шага
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE07B39),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$stepNumber',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Текст описания
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
