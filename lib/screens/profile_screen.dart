import 'package:eatcost_app/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_menu_item.dart';
import '../widgets/profile/subscription_banner.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Заголовок профиля
            ProfileHeader(
              userName: authService.userName,
              userPhone: authService.userPhone,
            ),
            const SizedBox(height: 16),

            // Профиль
            ProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Профиль',
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
            ),

            // История заказов
            ProfileMenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'История заказов',
              onTap: () {
                // Переход к истории заказов
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('История заказов')),
                );
              },
            ),

            // Баннер подписки
            SubscriptionBanner(
              onTap: () {
                // Переход к управлению подпиской
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Управление подпиской')),
                );
              },
            ),

            // Способы оплаты
            ProfileMenuItem(
              icon: Icons.credit_card_outlined,
              title: 'Способы оплаты',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Способы оплаты')),
                );
              },
            ),

            // Мои адреса
            ProfileMenuItem(
              icon: Icons.location_on_outlined,
              title: 'Мои адреса',
              subtitle: 'улица Горького, 75',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Мои адреса')),
                );
              },
            ),

            // Бот в Telegram
            ProfileMenuItem(
              icon: Icons.telegram,
              title: 'Бот в Telegram',
              subtitle: 'Получайте уведомления по заказам и ответы на вопросы',
              iconColor: const Color(0xFF0088CC),
              backgroundColor: const Color(0xFF0088CC).withOpacity(0.1),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Открыть Telegram бот')),
                );
              },
            ),

            // Выйти из профиля
            ProfileMenuItem(
              icon: Icons.logout,
              title: 'Выйти из профиля',
              iconColor: Colors.red,
              backgroundColor: Colors.red.withOpacity(0.1),
              onTap: () {
                _showLogoutDialog(context, authService);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthService authService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти из профиля?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              authService.logout();
              Navigator.pop(context);
            },
            child: const Text(
              'Выйти',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
