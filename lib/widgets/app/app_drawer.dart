import 'package:eatcost_app/screens/faq_screen.dart';
import 'package:eatcost_app/screens/how_it_works_screen.dart';
import 'package:eatcost_app/screens/pricing_plans_screen.dart';
import 'package:eatcost_app/screens/stores_screen.dart';
import 'package:flutter/material.dart';
import 'package:eatcost_app/screens/posts_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Новости и акции',
        'icon': Icons.campaign_outlined,
        'screen': const PostsScreen(),
      },
      {
        'title': 'Тарифы и условия',
        'icon': Icons.card_membership,
        'screen': const PricingPlansScreen(),
      },
      {
        'title': 'Магазины',
        'icon': Icons.store,
        'screen': const StoresScreen(),
      },
      {
        'title': 'Как это работает',
        'icon': Icons.qr_code,
        'screen': const HowItWorksScreen(),
      },
      {
        'title': 'Вопросы - ответы',
        'icon': Icons.question_answer,
        'screen': const FaqScreen(),
      },
    ];

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Хедер остается без изменений
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFF3D5A3E)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'EatCost',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Вкусная еда с доставкой',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ...menuItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'] as IconData),
                    title: Text(item['title'] as String),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => item['screen'] as Widget,
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(10),
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.phone_outlined,
                            size: 24,
                            color: Color(0xFF3D5A3E),
                          ),
                          SizedBox(width: 12),
                          Text(
                            '8 (343) 344-23-56',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          color: const Color(0xFF25D366),
                          icon: Icons.call,
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _buildSocialButton(
                          color: const Color(0xFF0088CC),
                          icon: Icons.telegram,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}